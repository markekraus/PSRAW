<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    05/11/2017 4:41 AM
     Edited on:     05/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Import-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
        Import-RedditOAuthToken Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Import-RedditOAuthToken'
$TypeName = 'RedditOAuthToken'

$ClientId = '54321'
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSceret = 'password12345'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TokenId = 'access_token'
$TokenSceret = '34567'
$SecTokenSecret = $TokenSceret | ConvertTo-SecureString -AsPlainText -Force 
$TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

$RefreshId = 'refresh_token'
$RefreshSceret = '76543'
$SecRefreshSecret = $RefreshSceret | ConvertTo-SecureString -AsPlainText -Force 
$RefreshCredential = [pscredential]::new($RefreshId, $SecRefreshSecret)

$ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()
$TokenExportFile = '{0}\RedditTokenExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()

$Application = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $ClientCredential
    UserCredential   = $UserCredential
    Type             = 'Script'
    ExportPath       = $ExportFile 
}

$Token = [RedditOAuthToken]@{
    Application        = $Application
    IssueDate          = Get-Date
    ExpireDate         = (Get-Date).AddHours(1)
    LastApiCall        = Get-Date
    ExportPath         = $TokenExportFile
    Scope              = $Application.Scope
    GUID               = [guid]::NewGuid()
    Notes              = 'This is a test token'
    TokenType          = 'bearer'
    GrantType          = 'Authorization_Code'
    RateLimitUsed      = 0
    RateLimitRemaining = 60
    RateLimitRest      = 60
    TokenCredential    = $TokenCredential
    RefreshCredential  = $RefreshCredential
}

$Token | Export-Clixml -Path $TokenExportFile 

$ParameterSets = @(
    @{
        Name   = 'Path'
        Params = @{
            Path = $TokenExportFile
        }
    }
    @{
        Name   = 'LiteralPath'
        Params = @{
            LiteralPath = $TokenExportFile
        }
    }
)

function MyTest {
    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    It "Emits a $TypeName Object" {
        (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns a $TypeName Object" {
        $LocalParams = $ParameterSets[0].Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
}

Describe "$command Unit" -Tags Unit {
    $commandpresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
    if (-not $commandpresent) {
        Write-Warning "'$command' was not found in '$moduleName' during prebuild tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}

Describe "$command Build" -Tags Build {
    MyTest
}

Remove-Item -Force -Path $TokenExportFile -ErrorAction SilentlyContinue