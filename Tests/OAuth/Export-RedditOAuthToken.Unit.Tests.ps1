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
Describe "Export-RedditOAuthToken Build" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $Module = Get-Module -Name $ModuleName
        $TokenExportFile = '{0}\RedditTokenExport.xml' -f $TestDrive
        $TokenScript = Get-TokenScript
        $TokenScript.ExportPath = $TokenExportFile
        $TestCases = @(
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
    Context "Test cases" {
        It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
            param ($Name, $Params)
            { Export-RedditOAuthToken @Params -ErrorAction Stop } | Should not throw
        }
    }
    Context "Features" {
        It "Exports a valid XML file." {
            $TokenScript | Export-RedditOAuthToken
            Test-Path -Path $TokenExportFile | Should Be $True
            $xml = [System.Xml.XmlDocument]::new()
            { $xml.Load($TokenExportFile) } | should not throw
        }
        It "Does not store secrets in plaintext" {
            $TokenScript | Export-RedditOAuthToken
            $Params = @{
                Path        = $TokenExportFile
                SimpleMatch = $true
                Pattern     = $TokenScript.GetAccessToken()
            }
            Select-String @Params | should be $null
        }
        It "Exports the default Token when one is not supplied" {
            $TokenScript | Set-RedditDefaultOAuthToken
            { Export-RedditOAuthToken -Path $TokenExportFile -ErrorAction Stop } | Should not throw
        }
    }
}
