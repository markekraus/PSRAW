<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    6/02/2017 4:50 AM
     Edited on:     6/02/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditUserReport.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditUserReport Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditUserReport'

Function MyTest {
    It 'Creates a RedditUserReport from an object collection' {
        $RedditUserReport = [RedditUserReport]@('Breaks Rule 12', 3)
        $RedditUserReport.Reason | should be 'Breaks Rule 12'
        $RedditUserReport.Count | Should be 3
    }
}

Describe "[$Class] Unit Tests" -Tag Unit {
    if (-not ($Class -as [Type])) {
        Write-Warning "'$class' was not found in '$moduleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "[$Class] Build Tests" -Tag Build {
    MyTest
}