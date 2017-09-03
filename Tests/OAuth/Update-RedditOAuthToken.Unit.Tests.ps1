<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/18/2017 4:31 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     Update-RedditOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
       Update-RedditOAuthToken Function unit tests
#>
Describe "Update-RedditOAuthToken Build" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $OriginalAuthBaseURL = [RedditOAuthToken]::AuthBaseURL
        $TestCases = @(
            @{
                Name   = 'Installed'
                Params = @{
                    AccessToken = Get-TokenInstalled -Expired
                }
            }
            @{
                Name   = 'Password'
                Params = @{
                    AccessToken = Get-TokenScript -Expired
                }
            }
            @{
                Name   = 'Client'
                Params = @{
                    AccessToken = Get-TokenClient -Expired
                }
            }
        )
    }
    AfterAll {
        [RedditOAuthToken]::AuthBaseURL = $OriginalAuthBaseURL
    }
    BeforeEach {
        # Tricks the private functions to use WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token/New'
        $ExpiredToken = Get-TokenScript -Expired
    }
    Context "Test cases" {
        It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
            Param($Name, $Params)
            { Update-RedditOAuthToken @Params -ErrorAction Stop } | Should not throw
        }
    }
    Context "Features" {
        It "Emits a 'RedditOAuthToken' Object" {
            (Get-Command Update-RedditOAuthToken).
            OutputType.Name.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
        It "Returns a 'RedditOAuthToken' Object when PassThru is supplied" {
            $Object = Update-RedditOAuthToken -AccessToken $ExpiredToken -PassThru |
                Select-Object -First 1
            $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
        It "Supports WhatIf" {
            $TokenBefore = $ExpiredToken.GetAccessToken()
            $ExpiredToken | Update-RedditOAuthToken -WhatIf
            $ExpiredToken.GetAccessToken() | should be $TokenBefore
        }
        It "Supports PassThru" {
            $TokenBefore = $ExpiredToken.GetAccessToken()
            $Result = Update-RedditOAuthToken -AccessToken $ExpiredToken -PassThru
            $Result.GetAccessToken() | should Not BeNullOrEmpty
            $Result.GetAccessToken() | should Not Be $TokenBefore
        }
        It "Supports Force" {
            $TokenScript = Get-TokenScript
            $TokenBefore = $TokenScript.GetAccessToken()
            Update-RedditOAuthToken -Force -AccessToken $TokenScript
            $TokenScript.GetAccessToken() | should Not BeNullOrEmpty
            $TokenScript.GetAccessToken() | should Not Be $TokenBefore
        }
        It "Updates the Default Token if one is not provided" {
            $TokenBefore = $ExpiredToken.GetAccessToken()
            $ExpiredToken | Set-RedditDefaultOAuthToken
            (Get-RedditDefaultOAuthToken).GetAccessToken() | should be $TokenBefore
            { Update-RedditOAuthToken -ErrorAction Stop } | Should Not Throw
            (Get-RedditDefaultOAuthToken).GetAccessToken() | Should Not BeNullOrEmpty
            (Get-RedditDefaultOAuthToken).GetAccessToken() | Should Not Be $TokenBefore
        }
        It "Sets the Updated token to the Default Token with -SetAsDefault" {
            $DefaultToken = Get-TokenScript
            $TokenBefore = $DefaultToken.GetAccessToken()
            $DefaultToken  | Set-RedditDefaultOAuthToken
            (Get-RedditDefaultOAuthToken).GetAccessToken() | should be $TokenBefore
            { Update-RedditOAuthToken -AccessToken  $ExpiredToken -SetDefault -ErrorAction Stop } |
                Should Not Throw
            (Get-RedditDefaultOAuthToken).GetAccessToken() | Should Not BeNullOrEmpty
            (Get-RedditDefaultOAuthToken).GetAccessToken() | Should Not Be $TokenBefore
        }
    }
}
