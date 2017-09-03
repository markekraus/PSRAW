<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    8/12/2017 8:10 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     Get-RedditDefaultOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
       Get-RedditDefaultOAuthToken Function unit tests
#>
Describe "Get-RedditDefaultOAuthToken" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    It "Runs without error" {
        { Get-RedditDefaultOAuthToken } | Should Not Throw
    }
    It "Returns the default token" {
        $TokenScript = Get-TokenScript
        $TokenScript | Set-RedditDefaultOAuthToken
        $Result = Get-RedditDefaultOAuthToken
        $Result.GUID | Should Be $TokenScript.GUID
    }
    It "Supports what if" {
        { Get-RedditDefaultOAuthToken -WhatIf }  | Should Not Throw
    }
}
