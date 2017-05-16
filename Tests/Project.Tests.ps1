<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    04/23/2017 12:06 PM
     Edited on:     05/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Project.Tests.ps1
    
    .DESCRIPTION
        General Pester Tests for the project
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Describe "General project validation: $moduleName" -Tags Build, Unit {
    
    It "Module '$moduleName' can import cleanly" {
        { Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
    }
}