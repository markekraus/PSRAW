<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/07/2017 8:50 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Request-RedditOAuthTokenClient.Unit.Tests.ps1

    .DESCRIPTION
        Request-RedditOAuthTokenClient Function unit tests
#>
Describe "Request-RedditOAuthTokenClient" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $OriginalAuthBaseURL = [RedditOAuthToken]::AuthBaseURL
        # Tricks Request-RedditOAuthTokenClient into using WebListener
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
                @{
                    Name   = 'WebApp'
                    Params = @{
                        Application = Get-ApplicationWebApp
                    }
                }
            )
            It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
                Param($Name, $Params)
                { Request-RedditOAuthTokenClient @Params -ErrorAction Stop } | Should not throw
            }
        }
        Context "Features" {
            It "Emits a 'RedditOAuthResponse' Object" {
                (Get-Command Request-RedditOAuthTokenClient).
                OutputType.Name.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
            It "Returns a 'RedditOAuthResponse' Object" {
                $ApplicationScript = Get-ApplicationScript
                $Object = Request-RedditOAuthTokenClient -Application $ApplicationScript |
                    Select-Object -First 1
                $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
            It "Does not support 'Installed' apps" {
                $ApplicationInstalled = Get-ApplicationInstalled
                { Request-RedditOAuthTokenClient -Application $ApplicationInstalled -ErrorAction Stop } |
                    Should throw "RedditApplicationType must be 'Script' or 'WebApp"
            }
        }
    }
}
