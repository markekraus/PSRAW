<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    4/30/2017 1:22 PM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Export-RedditApplication.Unit.Tests.ps1

    .DESCRIPTION
        Export-RedditApplication Function unit tests
#>

Describe "Export-RedditApplication" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $TestDrive, [guid]::NewGuid().toString()
        $Application = Get-ApplicationScript
        $Application.ExportPath = $ExportFile
        $TestCases = @(
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
    }
    It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
        param($Name, $Params)
        { & Export-RedditApplication @Params -ErrorAction Stop } | Should not throw
    }
    It "Exports a valid XML file." {
        Export-RedditApplication -Application $Application -Path $ExportFile
        Test-Path -Path $ExportFile | Should Be $True
        $xml = New-Object System.Xml.XmlDocument
        {$xml.Load($ExportFile)} | should not throw
    }
    It "Does not store secrets in plaintext" {
        Export-RedditApplication -Application $Application -Path $ExportFile
        $ExportFile | Should Not Contain $Application.GetClientSecret()
        $ExportFile | Should Not Contain $Application.GetUserPassword()
    }
}

