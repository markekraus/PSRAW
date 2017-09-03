<#
    .NOTES

     Created with:  VSCode
     Created on:    8/12/2017 8:16 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     Set-RedditDefaultOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
       Set-RedditDefaultOAuthToken Function unit tests
#>
Describe "Set-RedditDefaultOAuthToken" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    BeforeEach {
        $TokenScript = Get-TokenScript
    }
    It "Runs without error" {
        { $TokenScript | Set-RedditDefaultOAuthToken } | Should Not Throw
    }
    It "Returns the default token" {
        $TokenScript | Set-RedditDefaultOAuthToken
        $Result = Get-RedditDefaultOAuthToken
        $Result.GUID | Should Be $TokenScript.GUID
    }
    It "Supports what if" {
        { $TokenScript | Set-RedditDefaultOAuthToken -WhatIf }  | Should Not Throw
    }
}
