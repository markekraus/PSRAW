<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    05/01/2017 4:43 PM
     Edited on:     09/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Import-RedditApplication.Unit.Tests.ps1

    .DESCRIPTION
        Import-RedditApplication Function unit tests
#>
Describe "Import-RedditApplication" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $TestDrive, [guid]::NewGuid().toString()
        $Application = Get-ApplicationScript
        $Application.ExportPath = $ExportFile
        $Application | Export-Clixml -Path $ExportFile
        $TestCases = @(
            @{
                Name   = 'Path'
                Params = @{
                    Path = $ExportFile
                }
            }
            @{
                Name   = 'LiteralPath'
                Params = @{
                    LiteralPath = $ExportFile
                }
            }
        )
    }
    It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
        param($Name, $Params)
        { Import-RedditApplication @Params -ErrorAction Stop } | Should not throw
    }
    It "Emits a 'RedditApplication' Object" {
        (Get-Command Import-RedditApplication).OutputType.Name.where( { $_ -eq 'RedditApplication' }) | Should be 'RedditApplication'
    }
    It "Returns a 'RedditApplication' Object" {
        $Object = Import-RedditApplication -Path $ExportFile | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq 'RedditApplication' }) | Should be 'RedditApplication'
    }
}
