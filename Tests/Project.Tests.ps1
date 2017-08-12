<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    04/23/2017 12:06 PM
     Edited on:     08/11/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Project.Tests.ps1
    
    .DESCRIPTION
        General Pester Tests for the project
#>

$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf

Describe "General project validation: $ModuleName" -Tags Build, Unit {
    
    It "Module '$ModuleName' can import cleanly" {
        { Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -force } | Should Not Throw
    }
    Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -force
    It "Module '$ModuleName' Imports Functions" {
        Get-Command -Module $ModuleName | 
            Measure-Object | 
            Select-Object -ExpandProperty Count | 
            Should BeGreaterThan 0 
    }
}