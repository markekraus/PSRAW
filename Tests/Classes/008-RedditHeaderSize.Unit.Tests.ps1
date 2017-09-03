<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    9/01/2017 4:17 AM
     Edited on:     9/01/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditHeaderSize.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditHeaderSize Class
#>

Describe "[RedditHeaderSize] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    Width  = 5
                    Height = 10
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        { [RedditHeaderSize]$Hash } | should not throw
    }
    It "Has a working default constructor" {
        { [RedditHeaderSize]::New() } | Should not throw
    }
    It "Has a working ([Object[]]`$InputObjects) constructor" {
        $Result = @{}
        $InputObject = @(5, 10)
        { $Result['object'] = [RedditHeaderSize]::New($InputObject) } | Should not throw
        $Result['object'].Width  | Should Be 5
        $Result['object'].Height | Should Be 10
    }
}
