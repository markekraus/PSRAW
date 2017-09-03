<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    04/23/2017 12:06 PM
     Edited on:     09/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     Project.Tests.ps1

    .DESCRIPTION
        General Pester Tests for the project
#>
Describe "General project validation: PSRAW" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    }
    It "Module '$ModuleName' can import cleanly" {
        { Import-Module $ModulePath -force } | Should Not Throw
    }
    Import-Module $ModulePath -force
    It "Module '$ModuleName' Imports Functions" {
        Get-Command -Module $ModuleName |
            Measure-Object |
            Select-Object -ExpandProperty Count |
            Should BeGreaterThan 0
    }
}