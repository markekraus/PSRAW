<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/30/2017 1:22 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Export-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
        Export-RedditOAuthToken Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Export-RedditOAuthToken'

$ClientId = '54321'
$ClientSecret = '12345'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSecret = 'password12345'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TokenId = 'access_token'
$TokenSecret = '34567'
$SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
$TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

$RefreshId = 'refresh_token'
$RefreshSecret = '76543'
$SecRefreshSecret = $RefreshSecret | ConvertTo-SecureString -AsPlainText -Force 
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

$ParameterSets = @(
    @{
        Name   = 'Path'
        Params = @{
            Path        = $TokenExportFile
            AccessToken = $Token
        }
    }
    @{
        Name   = 'LiteralPath'
        Params = @{
            LiteralPath = $TokenExportFile
            AccessToken = $Token
        }
    }
    @{
        Name   = 'ExportPath'
        Params = @{
            AccessToken = $Token
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
    It "Exports a valid XML file." {
        Test-Path -Path $TokenExportFile | Should Be $True
        $xml = New-Object System.Xml.XmlDocument
        {$xml.Load($TokenExportFile)} | should not throw
    }
    It "Does not store secrets in plaintext" {
        $Params = @{
            Path        = $TokenExportFile
            SimpleMatch = $true
            Pattern     = '12345', '34567', "76543" 
        }
        Select-String @Params | should be $null
    }
}

Describe "$command Unit" -Tags Unit {
    $CommandPresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
    if (-not $CommandPresent) {
        Write-Warning "'$command' was not found in '$moduleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}

Describe "$command Build" -Tags Build {
    MyTest
}

Remove-Item -Force -Path $TokenExportFile -ErrorAction SilentlyContinue