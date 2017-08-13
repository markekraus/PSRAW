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
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force
$Module = Get-Module -Name $ModuleName

$Command = 'Export-RedditOAuthToken'

function InitVariables {
    $ClientId = '54321'
    $ClientSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44e'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)
    
    $UserId = 'reddituser'
    $UserSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44f'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)
    
    $TokenId = 'access_token'
    $TokenSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44g'
    $SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
    $TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)
    
    $ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $TestDrive, [guid]::NewGuid().toString()
    $TokenExportFile = '{0}\RedditTokenExport-{1}.xml' -f $TestDrive, [guid]::NewGuid().toString()
    
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
    
    $TokenScript = [RedditOAuthToken]@{
        Application        = $Application
        IssueDate          = Get-Date
        ExpireDate         = (Get-Date).AddHours(1)
        LastApiCall        = Get-Date
        ExportPath         = $TokenExportFile
        Scope              = $Application.Scope
        GUID               = [guid]::NewGuid()
        Notes              = 'This is a test token'
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential
    }
    
    $ParameterSets = @(
        @{
            Name   = 'Path'
            Params = @{
                Path        = $TokenExportFile
                AccessToken = $TokenScript
            }
        }
        @{
            Name   = 'LiteralPath'
            Params = @{
                LiteralPath = $TokenExportFile
                AccessToken = $TokenScript
            }
        }
        @{
            Name   = 'ExportPath'
            Params = @{
                AccessToken = $TokenScript
            }
        }
    )
}


function MyTest {
    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    It "Exports a valid XML file." {
        Test-Path -Path $TokenExportFile | Should Be $True
        $xml = [System.Xml.XmlDocument]::new()
        {$xml.Load($TokenExportFile)} | should not throw
    }
    It "Does not store secrets in plaintext" {
        $Params = @{
            Path        = $TokenExportFile
            SimpleMatch = $true
            Pattern     = '08239842-a6f5-4fe5-ab4c-4592084ad44' 
        }
        Select-String @Params | should be $null
    }
    It "Exports the default Token when one is not supplied" {
        & $Module { $PsrawSettings.AccessToken = $TokenScript }
        { & $Command -Path $TokenExportFile -ErrorAction Stop } | Should not throw
    }
}

Describe "$command Unit" -Tags Unit {
    $CommandPresent = Get-Command -Name $Command -Module $ModuleName -ErrorAction SilentlyContinue
    if (-not $CommandPresent) {
        Write-Warning "'$command' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    . InitVariables
    MyTest
}

Describe "$command Build" -Tags Build {
    . InitVariables
    MyTest
}
