<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/07/2017 11:50 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Request-RedditOAuthTokenPassword.Unit.Tests.ps1

    .DESCRIPTION
        Request-RedditOAuthTokenPassword Function unit tests
#>
Describe "Request-RedditOAuthTokenPassword" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $OriginalAuthBaseURL = [RedditOAuthToken]::AuthBaseURL
        # Tricks Request-RedditOAuthTokenPassword into using WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token'
    }
    AfterAll {
        [RedditOAuthToken]::AuthBaseURL = $OriginalAuthBaseURL
    }
    InModuleScope $ModuleName {
        Context "Test Cases" {
            $TestCases = @(
                @{
                    Name   = 'Script'
                    Params = @{
                        Application = Get-ApplicationScript
                    }
                }
            )
            It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
                Param($Name, $Params)
                { Request-RedditOAuthTokenPassword @Params -ErrorAction Stop } | Should not throw
            }
        }
        Context "Features" {
            It "Emits a 'RedditOAuthResponse' Object" {
                (Get-Command Request-RedditOAuthTokenPassword).
                OutputType.Name.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
            It "Returns a 'RedditOAuthResponse' Object" {
                $ApplicationScript = Get-ApplicationScript
                $Object = Request-RedditOAuthTokenPassword -Application $ApplicationScript |
                    Select-Object -First 1
                $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
            It "Does not support 'Installed' apps" {
                $ApplicationInstalled = Get-ApplicationInstalled
                { Request-RedditOAuthTokenPassword -Application $ApplicationInstalled -ErrorAction Stop } |
                    Should throw "RedditApplicationType must be 'Script'"
            }
            It "Does not support 'WebApp' apps" {
                $ApplicationWebApp = Get-ApplicationWebApp
                { Request-RedditOAuthTokenPassword -Application $ApplicationWebApp -ErrorAction Stop } |
                    Should throw "RedditApplicationType must be 'Script'"
            }
        }
    }
}