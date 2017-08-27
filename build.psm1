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

Function Publish-TestTools {
    $DotnetExists = Test-DotnetExists
    $DotNetVersion = [string]::Empty
    if ($DotNetExists) {
        $DotNetVersion = (dotnet --version)
    }
    if (!$DotNetExists -or $DotNetVersion -ne $DotnetCLIRequiredVersion) {
        if(!$dotNetExistis) {
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

    foreach ($Tool in $Tools){
        Push-Location $tool
        try {
            dotnet publish --output bin --configuration Release
            $toolPath = Join-Path -Path $tool -ChildPath "bin"
            if ( $env:PATH -notcontains $toolPath ) {
                $env:PATH = '{0}{1}{2}' -f $toolPath, [System.IO.Path]::PathSeparator, $($env:PATH)
            }
        } finally {
            Pop-Location
        }
    }
}

Function Start-PSRAWPester {
    param(
        [string]$WebListenerPort = 8080,
        [string[]]$ExcludeTag = 'Exclude',
        [string[]]$Tag = "Build",
        [string[]]$Path = "$ProjectRoot/Tests/",
        [string[]]$Show = 'All',
        [string]$OutputFormat = "NUnitXml",
        [string]$OutputFile = "pester-tests.xml",
        [object[]]$CodeCoverage = (Get-ChildItem -Recurse -Path $moduleFolder -Include  '*.ps1', '*.psm1' ),
        [switch]$PassThru,
        [switch]$ThrowOnFailure
    )
    $lines
    Find-Dotnet
    Publish-TestTools
    Import-PSRAWModule

    Write-Host "Starting WebListener on port $WebListenerPort"
    $Null = Start-WebListener -HttpPort $WebListenerPort -ErrorAction Stop

    Write-Host "Running pester tests at '$path' with tag '$($Tag -join ''', ''')' and ExcludeTag '$($ExcludeTag -join ''', ''')'" 

    # Gather test results. Store them in a variable and file
    $Timestamp = 
    $TestFile = 
    $parameters = @{
        Script       = "$ProjectRoot\Tests"
        PassThru     = $true
        OutputFormat = $OutputFormat
        OutputFile   = "pester-tests.xml"
        Tag          = $Tag
        Show         = $Show
        CodeCoverage = $CodeCoverage
    }
    $TestResults = Invoke-Pester @parameters 

    If($PassThru){
        $TestResults 
    }
    
    Write-Host "Stopping WebListener"
    Stop-WebListener
    
    $CoveragePercent = $TestResults.CodeCoverage.NumberOfCommandsExecuted / $TestResults.CodeCoverage.NumberOfCommandsAnalyzed
    Write-Host " "
    Write-Host "Code coverage report"
    Write-Host ("   Files:             {0:N0}" -f $TestResults.CodeCoverage.NumberOfFilesAnalyzed)
    Write-Host ("   Commands Analyzed: {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsAnalyzed)
    Write-Host ("   Commands Hit:      {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsExecuted)
    Write-Host ("   Commands Missed:   {0:N0}" -f $TestResults.CodeCoverage.NumberOfCommandsMissed)
    Write-Host ("   Coverage:          {0:P2}" -f $CoveragePercent)
    Write-Host " "
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
    if ($TestResults.FailedCount -gt 0) {
        Write-Host " "
        $Message = "Failed '$($TestResults.FailedCount)' tests"
        if($ThrowOnFailure.IsPresent){ Write-Error $Message}
        else{Write-Warning $Message}
    }
    Write-Host " "
}

function Import-PSRAWModule {
    Write-Host "Locading module $moduleFolder/$moduleName.psd1"
    Import-Module "$moduleFolder/$moduleName.psd1"
}

$lines = '----------------------------------------------------------------------'
$dotnetCLIChannel = "release"
$dotnetCLIRequiredVersion = "2.0.0"
$TestModulePathSeparator = [System.IO.Path]::PathSeparator
$Environment = Get-EnvironmentInformation
$PSVersion = $PSVersionTable.PSVersion.Major
$ProjectRoot = $PSScriptRoot
$moduleFolder = "$ProjectRoot/PSRAW"
$moduleRoot = "$ProjectRoot/PSRAW"
$moduleName = "PSRAW"

# adds auto loading for Build and Test Functions
$BuildModulePath = Join-Path $PSScriptRoot "BuildTools/Modules"
if ( $env:PSModulePath -notcontains $TestModulePath ) {
    $env:PSModulePath = $TestModulePath+$TestModulePathSeparator+$($env:PSModulePath)
}
$TestModulePath = Join-Path $PSScriptRoot "Tests/tools/Modules"
if ( $env:PSModulePath -notcontains $TestModulePath ) {
    $env:PSModulePath = $TestModulePath+$TestModulePathSeparator+$($env:PSModulePath)
}