<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    6/02/2017 4:28 AM
     Edited on:     5/29/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditDate.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditDate Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditDate'

Function MyTest {
    It 'Creates a RedditDate from a string' {
        $RedditDate = [RedditDate]'31536000'
        $RedditDate.Date | should be (get-date '1971/1/1')
    }
    It 'Creates a RedditDate from a Double' {
        $RedditDate = [RedditDate]31536000.0
        $RedditDate.Date | should be (get-date '1971/1/1')
    }
    It 'Creates a RedditDate from a DateTime' {
        $RedditDate = [RedditDate](get-date '1971/1/1')
        $RedditDate.Unix | Should be 31536000.0
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