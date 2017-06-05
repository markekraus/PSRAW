<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/29/2017 9:26 PM
     Edited on:     6/02/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditThing.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditThing Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditThing'

<#
    PowerShell initializes class statements before everything else in the script.
    Since the inherited class in not in scope before the class statement is called
    We need to trick PowerShell into creating the class on-demand instead of before 
    importing the module. Create the Class Definition as a string and later 
    call Invoke-Expression on it.
    Without this you will get the following error:
        Unable to find type [$Class].
#>
$FakeInherit = @"
Class FakeInherit : $Class {
    FakeInherit () {}
}
"@

Function MyTest {
    It 'Is an abstract class which cannot be directly initialized' {
        {[RedditThing]::New()} | should Throw "Class $class must be inherited"
    }
    Invoke-Expression -Command $FakeInherit
    $Inherited = [FakeInherit]::New()
    It 'Has a GetApiEndpointUri method which must be overridden' {
        {$Inherited.GetApiEndpointUri()} | should throw "Must Override Method"
    }
    It 'Has a GetFullName method which must be overridden' {
        {$Inherited.GetFullName()} | should throw "Must Override Method"
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