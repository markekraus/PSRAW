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
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditDate'

Function MyTest {
    It 'Creates a RedditDate from a Unix string' {
        $RedditDate = [RedditDate]'31536000'
        $RedditDate.Date | should be (get-date '1971/1/1')
        $RedditDate.Unix | should be 31536000
    }
    It 'Creates a RedditDate from a Date string' {
        $RedditDate = [RedditDate]'1971/1/1'
        $RedditDate.Date | should be (get-date '1971/1/1')
        $RedditDate.Unix | should be 31536000
    }
    It 'Throws when the string cannot be parsed' {
        Try { [RedditDate]'invalid' } 
        Catch { $Exception = $_ } 
        $Message = 'Cannot convert value "invalid" to type "RedditDate". Error: "Unable to parse string as System.DateTime or System.Double."'
        $Exception.Exception.Message | Should Be $Message
        $Exception.Exception.InnerException.InnerException.InnerException | should BeOfType 'System.ArgumentException'
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
        Write-Warning "'$class' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "[$Class] Build Tests" -Tag Build {
    MyTest
}