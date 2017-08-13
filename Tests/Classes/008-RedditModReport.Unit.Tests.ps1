<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    6/02/2017 4:28 AM
     Edited on:     6/02/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditModReport.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditModReport Class
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditModReport'

Function MyTest {
    It 'Creates a RedditModReport from an object collection' {
        $RedditModReport = [RedditModReport]@('Breaks Rule 12', 'markekraus')
        $RedditModReport.Reason | should be 'Breaks Rule 12'
        $RedditModReport.Moderator | Should be 'markekraus'
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