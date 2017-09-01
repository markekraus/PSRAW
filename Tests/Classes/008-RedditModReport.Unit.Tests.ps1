<#
    .NOTES

     Created with:  VSCode
     Created on:    6/02/2017 4:28 AM
     Edited on:     9/01/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     008-RedditModReport.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditModReport Class
#>

Describe "[RedditModReport] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    Reason    = 'Spam'
                    Moderator = 'TestMod'
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        { [RedditModReport]$Hash } | should not throw
    }
    It "Has a working default constructor" {
        { [RedditModReport]::New() } | Should not throw
    }
    It "Has a working ([Object[]]`$InputObjects) constructor" {
        $Result = @{}
        $InputObject = @('Breaks Rule 12', 'markekraus')
        { $Result['object'] = [RedditModReport]::New($InputObject) } | Should not throw
        $Result['object'].Reason    | Should Be 'Breaks Rule 12'
        $Result['object'].Moderator | Should Be 'markekraus'
    }
}