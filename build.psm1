<#
    .NOTES
        Much of this has been borrowed and modified from the PowerShell build.psm1
#>

function Get-EnvironmentInformation
{
    $environment = @{}
    # Use the .NET Core APIs to determine the current platform.
    # If a runtime exception is thrown, we are on Windows PowerShell, not PowerShell Core,
    # because System.Runtime.InteropServices.RuntimeInformation
    # and System.Runtime.InteropServices.OSPlatform do not exist in Windows PowerShell.
    try {
        $Runtime = [System.Runtime.InteropServices.RuntimeInformation]
        $OSPlatform = [System.Runtime.InteropServices.OSPlatform]

        $environment += @{'IsCoreCLR' = $true}
        $environment += @{'IsLinux' = $Runtime::IsOSPlatform($OSPlatform::Linux)}
        $environment += @{'IsOSX' = $Runtime::IsOSPlatform($OSPlatform::OSX)}
        $environment += @{'IsWindows' = $Runtime::IsOSPlatform($OSPlatform::Windows)}
    } catch {
        $environment += @{'IsCoreCLR' = $false}
        $environment += @{'IsLinux' = $false}
        $environment += @{'IsOSX' = $false}
        $environment += @{'IsWindows' = $true}
    }

    if ($Environment.IsWindows)
    {
        $environment += @{'IsAdmin' = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)}
        # Can't use $env:HOME - not available on older systems (e.g. in AppVeyor)
        $environment += @{'nugetPackagesRoot' = "${env:HOMEDRIVE}${env:HOMEPATH}\.nuget\packages"}
    }
    else
    {
        $environment += @{'nugetPackagesRoot' = "${env:HOME}/.nuget/packages"}
    }

    if ($Environment.IsLinux) {
        $LinuxInfo = Get-Content /etc/os-release -Raw | ConvertFrom-StringData

        $environment += @{'LinuxInfo' = $LinuxInfo}
        $environment += @{'IsUbuntu' = $LinuxInfo.ID -match 'ubuntu'}
        $environment += @{'IsUbuntu14' = $Environment.IsUbuntu -and $LinuxInfo.VERSION_ID -match '14.04'}
        $environment += @{'IsUbuntu16' = $Environment.IsUbuntu -and $LinuxInfo.VERSION_ID -match '16.04'}
        $environment += @{'IsCentOS' = $LinuxInfo.ID -match 'centos' -and $LinuxInfo.VERSION_ID -match '7'}
        $environment += @{'IsFedora' = $LinuxInfo.ID -match 'fedora' -and $LinuxInfo.VERSION_ID -ge 24}
        $environment += @{'IsOpenSUSE' = $LinuxInfo.ID -match 'opensuse'}
        $environment += @{'IsOpenSUSE13' = $Environment.IsOpenSUSE -and $LinuxInfo.VERSION_ID  -match '13'}
        $environment += @{'IsOpenSUSE42.1' = $Environment.IsOpenSUSE -and $LinuxInfo.VERSION_ID  -match '42.1'}
        $environment += @{'IsRedHatFamily' = $Environment.IsCentOS -or $Environment.IsFedora -or $Environment.IsOpenSUSE}

        # Workaround for temporary LD_LIBRARY_PATH hack for Fedora 24
        # https://github.com/PowerShell/PowerShell/issues/2511
        if ($environment.IsFedora -and (Test-Path ENV:\LD_LIBRARY_PATH)) {
            Remove-Item -Force ENV:\LD_LIBRARY_PATH
            Get-ChildItem ENV:
        }
    }

    return [PSCustomObject] $environment
}

function Install-Dotnet {
    [CmdletBinding()]
    param(
        [string]$Channel = $dotnetCLIChannel,
        [string]$Version = $dotnetCLIRequiredVersion,
        [switch]$NoSudo
    )

    # This allows sudo install to be optional; needed when running in containers / as root
    # Note that when it is null, Invoke-Expression (but not &) must be used to interpolate properly
    $sudo = if (!$NoSudo) { "sudo" }
    $Environment = Get-EnvironmentInformation
    $obtainUrl = "https://raw.githubusercontent.com/dotnet/cli/master/scripts/obtain"

    # Install for Linux and OS X
    if ($Environment.IsLinux -or $Environment.IsOSX) {
        # Uninstall all previous dotnet packages
        $uninstallScript = if ($Environment.IsUbuntu) {
            "dotnet-uninstall-debian-packages.sh"
        } elseif ($Environment.IsOSX) {
            "dotnet-uninstall-pkgs.sh"
        }

        if ($uninstallScript) {
            Start-NativeExecution {
                curl -sO $obtainUrl/uninstall/$uninstallScript
                Invoke-Expression "$sudo bash ./$uninstallScript"
            }
        } else {
            Write-Warning "This script only removes prior versions of dotnet for Ubuntu 14.04 and OS X"
        }

        # Install new dotnet 1.1.0 preview packages
        $installScript = "dotnet-install.sh"
        Start-NativeExecution {
            curl -sO $obtainUrl/$installScript
            bash ./$installScript -c $Channel -v $Version
        }
    } elseif ($Environment.IsWindows) {
        Remove-Item -ErrorAction SilentlyContinue -Recurse -Force ~\AppData\Local\Microsoft\dotnet
        $installScript = "dotnet-install.ps1"
        Invoke-WebRequest -Uri $obtainUrl/$installScript -OutFile $installScript

        if (-not $Environment.IsCoreCLR) {
            & ./$installScript -Channel $Channel -Version $Version
        } else {
            # dotnet-install.ps1 uses APIs that are not supported in .NET Core, so we run it with Windows PowerShell
            $fullPSPath = Join-Path -Path $env:windir -ChildPath "System32\WindowsPowerShell\v1.0\powershell.exe"
            $fullDotnetInstallPath = Join-Path -Path $pwd.Path -ChildPath $installScript
            Start-NativeExecution { & $fullPSPath -NoLogo -NoProfile -File $fullDotnetInstallPath -Channel $Channel -Version $Version }
        }
    }
}

function Find-Dotnet() {
    $OriginalPath = $env:PATH
    $Environment = Get-EnvironmentInformation
    $DotnetPath = if ($Environment.IsWindows) {
        "$env:LocalAppData\Microsoft\dotnet"
    } else {
        "$env:HOME/.dotnet"
    }
    if (-not (Test-DotnetExists)) {
        "Could not find 'dotnet', appending $DotnetPath to PATH."
        $env:PATH += [IO.Path]::PathSeparator + $dotnetPath
    }
    if (-not (Test-DotnetExists)) {
        "Still could not find 'dotnet', restoring PATH."
        $env:PATH = $originalPath
    }
}

Function Test-DotnetExists () {
    if(Get-Command dotnet -ErrorAction SilentlyContinue){
        $True
    }
    Else {
        $False
    }
}

function script:Start-NativeExecution([scriptblock]$sb, [switch]$IgnoreExitcode)
{
    $backupEAP = $script:ErrorActionPreference
    $script:ErrorActionPreference = "Continue"
    try {
        & $sb
        # note, if $sb doesn't have a native invocation, $LASTEXITCODE will
        # point to the obsolete value
        if ($LASTEXITCODE -ne 0 -and -not $IgnoreExitcode) {
            throw "Execution of {$sb} failed with exit code $LASTEXITCODE"
        }
    } finally {
        $script:ErrorActionPreference = $backupEAP
    }
}

$TestToolsPublished = $false
Function Publish-TestTools {
    param([switch]$Force)
    if ($Script:TestToolsPublished -and -not $Force.IsPresent) {
        "Test Tools already published. Skipping."
        return
    }
    $DotnetExists = Test-DotnetExists
    $DotNetVersion = [string]::Empty
    if ($DotNetExists) {
        $DotNetVersion = (dotnet --version)
    }
    if (!$DotNetExists -or $DotNetVersion -ne $DotnetCLIRequiredVersion) {
        if (!$dotNetExistis) {
            "dotnet not present. Installing dotnet."
        }
        else {
            "dotnet out of date ($dotNetVersion). Updating dotnet."
        }
        Install-Dotnet -Channel $DotnetCLIChannel -Version $DotnetCLIRequiredVersion
    }
    else {
        "dotnet is already installed. Skipping installation."
    }
    Find-Dotnet
    $Tools = @(
        "$ProjectRoot/Tests/tools/WebListener"
    )

    foreach ($Tool in $Tools) {
        Push-Location $tool
        try {
            dotnet publish --output bin --configuration Release
            $toolPath = Join-Path -Path $tool -ChildPath "bin"
            if ( $env:PATH -notcontains $toolPath ) {
                $env:PATH = '{0}{1}{2}' -f $toolPath, [System.IO.Path]::PathSeparator, $($env:PATH)
            }
        }
        finally {
            Pop-Location
            $Script:TestToolsPublished = $true
        }
    }
}

Function Start-PSRAWPester {
    param(
        [string]$WebListenerPort = 8080,
        [string[]]$ExcludeTag = 'Exclude',
        [string[]]$Tag = "Build",
        [Alias('Script')]
        [string[]]$Path = "$ProjectRoot/Tests/",
        [string[]]$Show = 'All',
        [string]$OutputFormat = "NUnitXml",
        [string]$OutputFile = "pester-tests.xml",
        [object[]]$CodeCoverage,
        [switch]$PassThru,
        [switch]$ThrowOnFailure
    )
    Write-host $lines
    Find-Dotnet | Out-Host
    Publish-TestTools | Out-Host

    Write-Host "Starting WebListener on port $WebListenerPort"
    $Null = Start-WebListener -HttpPort $WebListenerPort -ErrorAction Stop

    Write-Host "Running pester tests at '$path' with tag '$($Tag -join ''', ''')' and ExcludeTag '$($ExcludeTag -join ''', ''')'"

    # Gather test results. Store them in a variable and file
    $Timestamp =
    $TestFile =
    $parameters = @{
        Script       = $Path
        PassThru     = $true
        OutputFormat = $OutputFormat
        OutputFile   = "pester-tests.xml"
        Tag          = $Tag
        Exclude      = $ExcludeTag
        Show         = $Show
        CodeCoverage = $CodeCoverage
    }
    $TestResults = Invoke-Pester @parameters

    If($PassThru){
        $TestResults
    }

    if($null -ne $CodeCoverage){
    $CoveragePercent = $TestResults.CodeCoverage.NumberOfCommandsExecuted / $TestResults.CodeCoverage.NumberOfCommandsAnalyzed
        Write-Host " "
        Write-Host "Code coverage Details"
        Write-Host ("   Files:             {0:N0}" -f $TestResults.CodeCoverage.NumberOfFilesAnalyzed)
        Write-Host ("   Commands Analyzed: {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsAnalyzed)
        Write-Host ("   Commands Hit:      {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsExecuted)
        Write-Host ("   Commands Missed:   {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsMissed)
        Write-Host ("   Coverage:          {0:P2}" -f $CoveragePercent)
        Write-Host " "
        <#
        Write-Host "Missed Commands:"
        $TestResults.CodeCoverage.MissedCommands | Select-Object @{
            Name       = 'File'
            Expression = {
                $_.file.replace($ProjectRoot, '') -replace '^\\', ''
            }
        }, line, function, command | Out-String | Out-Host
        if ($CoveragePercent -lt 0.90) {
            $Message = "Coverage {0:P2} is below 90%" -f $CoveragePercent
            if($ThrowOnFailure.IsPresent){ Write-Error $Message}
            else{Write-Warning $Message}
        }
        #>
    }
    if ($TestResults.FailedCount -gt 0) {
        Write-Host " "
        $Message = "Failed '$($TestResults.FailedCount)' tests"
        if($ThrowOnFailure.IsPresent){ Write-Error $Message}
        else{Write-Warning $Message}
    }
    Write-Host " "
    Write-Host "Stopping WebListener"
    Stop-WebListener
}

function Import-PSRAWModule {
    param([switch]$Force)
    Import-Module "$moduleFolder/$moduleName.psd1" -Global -Force:$($Force.IsPresent)
}

function Get-ModulePath {
    Resolve-Path "$moduleFolder/$moduleName.psd1"
}

function Get-ModuleName {
   $moduleName
}

function Get-ModuleRoot {
    $moduleRoot
 }
function Get-ProjectRoot {
    $ProjectRoot
 }

 function Initialize-PSRAWTest {
    New-Variable -Scope 1 -Name ModuleName -value  $moduleName -Force
    New-Variable -Scope 1 -Name ModuleRoot -value  $moduleRoot -Force
    New-Variable -Scope 1 -Name ModulePath -value  $modulePath -Force
    New-Variable -Scope 1 -Name ProjectRoot -value $ProjectRoot -Force
 }

$lines = '----------------------------------------------------------------------'
$dotnetCLIChannel = "release"
$dotnetCLIRequiredVersion = "2.0.0"
$TestModulePathSeparator = [System.IO.Path]::PathSeparator
$Environment = Get-EnvironmentInformation
$PSVersion = $PSVersionTable.PSVersion.Major
$ProjectRoot = $PSScriptRoot
$moduleName = "PSRAW"
$moduleFolder = (Resolve-Path "$ProjectRoot/$moduleName" ).Path
$moduleRoot = $moduleFolder
$modulePath = (Resolve-Path "$moduleFolder/$moduleName.psd1").Path

# adds auto loading for Build and Test Functions
$BuildModulePath = Join-Path $PSScriptRoot "BuildTools/Modules"
if ( $env:PSModulePath -notcontains $BuildModulePath ) {
    $env:PSModulePath = $BuildModulePath + $TestModulePathSeparator + $($env:PSModulePath)
}
$TestModulePath = Join-Path $PSScriptRoot "Tests/tools/Modules"
if ( $env:PSModulePath -notcontains $TestModulePath ) {
    $env:PSModulePath = $TestModulePath + $TestModulePathSeparator + $($env:PSModulePath)
}
if ( $env:PSModulePath -notcontains $moduleRoot ) {
    $env:PSModulePath = $moduleRoot + $TestModulePathSeparator + $($env:PSModulePath)
}


#Test Functions

Function Get-ClientCredential {
    $ClientId = '54321'
    $ClientSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44e'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
    [pscredential]::new($ClientId, $SecClientSecret)
}

Function Get-UserCredential {
    $UserId = 'reddituser'
    $UserSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44f'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force
    [pscredential]::new($UserId, $SecUserSecret)
}

Function Get-TokenSecret {
    '34567'
}
Function Get-TokenCredential {
    $TokenId = 'access_token'
    $TokenSecret = Get-TokenSecret
    $SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force
    [pscredential]::new($TokenId, $SecTokenSecret)
}

function Get-ApplicationScript {
    [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = Get-ClientCredential
        UserCredential   = Get-UserCredential
        Type             = 'Script'
    }
}

function Get-ApplicationInstalled {
    [RedditApplication] @{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = Get-ClientCredential
        Type             = 'Installed'
    }
}

function Get-ApplicationWebApp {
    [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = Get-ClientCredential
        Type             = 'WebApp'
    }
}

Function Get-TokenScript {
    Param ([switch]$Expired)
    $MinutesIssued = -13
    $MinutesExpired = 60
    If ($Expired.IsPresent) {
        $MinutesIssued = -120
        $MinutesExpired = -60
    }
    [RedditOAuthToken]@{
        Application        = Get-ApplicationScript
        IssueDate          = (Get-Date).AddMinutes($MinutesIssued)
        ExpireDate         = (Get-Date).AddMinutes($MinutesExpired)
        LastApiCall        = Get-Date
        Scope              = '*'
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 300
        RateLimitRest      = 99999
        TokenCredential    = Get-TokenCredential
    }
}

Function Get-TokenInstalled {
    Param ([switch]$Expired)
    $MinutesIssued = -13
    $MinutesExpired = 60
    If ($Expired.IsPresent) {
        $MinutesIssued = -120
        $MinutesExpired = -60
    }
    [RedditOAuthToken]@{
        Application        = Get-ApplicationInstalled
        IssueDate          = (Get-Date).AddMinutes($MinutesIssued)
        ExpireDate         = (Get-Date).AddMinutes($MinutesExpired)
        LastApiCall        = Get-Date
        Scope              = '*'
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Installed_Client'
        RateLimitUsed      = 0
        RateLimitRemaining = 300
        RateLimitRest      = 99999
        TokenCredential    = Get-TokenCredential
        DeviceID           = 'MyDeviceID'
    }
}

Function Get-TokenClient {
    Param ([switch]$Expired)
    $MinutesIssued  = -13
    $MinutesExpired = 60
    If ($Expired.IsPresent) {
        $MinutesIssued = -120
        $MinutesExpired = -60
    }
    [RedditOAuthToken]@{
        Application        = Get-ApplicationScript
        IssueDate          = (Get-Date).AddMinutes($MinutesIssued)
        ExpireDate         = (Get-Date).AddMinutes($MinutesExpired)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Client_Credentials'
        RateLimitUsed      = 0
        RateLimitRemaining = 300
        RateLimitRest      = 99999
        TokenCredential    = Get-TokenCredential
    }
}

function Get-TokenBad {

    $ApplicationScript = Get-ApplicationScript
    $TokenCredential   = Get-TokenCredential
    [RedditOAuthToken]@{
        Application        = $ApplicationScript
        Notes              = 'badupdate'
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential
    }
}

Function Start-PSRAWBuild {
    Param([String]$Task = 'Default')
    . .\BuildTools\build.ps1 -Task $Task
}