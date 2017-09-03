<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    05/11/2017 4:41 AM
     Edited on:     09/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Import-RedditOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
        Import-RedditOAuthToken Function unit tests
#>
Describe "Import-RedditOAuthToken" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $Module = Get-Module $ModuleName
        $TokenExportFile = '{0}\RedditTokenExport.xml' -f $TestDrive
        $TokenScript = Get-TokenScript
        $TokenScript |  Export-Clixml -Path $TokenExportFile
        $TestCases = @(
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
            @{
                Name   = 'Path PassThru'
                Params = @{
                    Path     = $TokenExportFile
                    PassThru = $true
                }
            }
            @{
                Name   = 'LiteralPath PassThru'
                Params = @{
                    LiteralPath = $TokenExportFile
                    PassThru    = $true
                }
            }
        )
    }
    Context "Test Cases" {
        It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
            Param($Name, $Params)
            { Import-RedditOAuthToken @Params -ErrorAction Stop } | Should not throw
        }
    }
    Context "Features" {
        It "Emits a 'RedditOAuthToken' Object" {
            (Get-Command Import-RedditOAuthToken).
            OutputType.Name.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
        It "Returns a 'RedditOAuthToken' Object with -PassThru" {
            $Object = Import-RedditOAuthToken -Path $TokenExportFile -PassThru | Select-Object -First 1
            $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
        It "Sets the imported token as the default token" {
            & $Module { $PsrawSettings.AccessToken = $null }
            & $Module { $PsrawSettings.AccessToken } | Should BeNullOrEmpty
            { Import-RedditOAuthToken -Path $TokenExportFile -ErrorAction Stop } | Should not throw
            & $Module { $PsrawSettings.AccessToken.GUID } | Should Be $TokenScript.GUID
        }
    }
}