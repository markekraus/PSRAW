<#
    .NOTES

     Created with:  VSCode
     Created on:    6/02/2017 4:50 AM
     Edited on:     9/01/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     008-RedditUserReport.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditUserReport Class
#>

Describe "[RedditUserReport] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    Reason = 'Spam'
                    Count  = 5
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        { [RedditUserReport]$Hash } | should not throw
    }
    It "Has a working default constructor" {
        { [RedditUserReport]::New() } | Should not throw
    }
    It "Has a working ([Object[]]`$InputObjects) constructor" {
        $Result = @{}
        $InputObject = @('Breaks Rule 12', 5)
        { $Result['object'] = [RedditUserReport]::New($InputObject) } | Should not throw
        $Result['object'].Reason | Should Be 'Breaks Rule 12'
        $Result['object'].Count  | Should Be 5
    }
}