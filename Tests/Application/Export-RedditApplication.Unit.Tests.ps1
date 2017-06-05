<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/30/2017 1:22 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Export-RedditApplication.Unit.Tests.ps1
    
    .DESCRIPTION
        Export-RedditApplication Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Export-RedditApplication'

$ClientId = '54321'
$ClientSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44e'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSecret = '08239842-a6f5-4fe5-ab4c-4592084ad44f'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()

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

$ParameterSets = @(
    @{
        Name   = 'Path'
        Params = @{
            Path        = $ExportFile
            Application = $Application
        }
    }
    @{
        Name   = 'LiteralPath'
        Params = @{
            LiteralPath = $ExportFile
            Application = $Application
        }
    }
    @{
        Name   = 'ExportPath'
        Params = @{
            Application = $Application
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
        Test-Path -Path $ExportFile | Should Be $True
        $xml = New-Object System.Xml.XmlDocument
        {$xml.Load($ExportFile)} | should not throw
    }
    It "Does not store secrets in plaintext" {
        $Params = @{
            Path        = $ExportFile
            SimpleMatch = $true
            Pattern     = '08239842-a6f5-4fe5-ab4c-4592084ad44'
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

Remove-Item -Force -Path $ExportFile -ErrorAction SilentlyContinue