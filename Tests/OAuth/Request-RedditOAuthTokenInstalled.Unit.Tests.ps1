<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/07/2017 12:45 PM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Request-RedditOAuthTokenInstalled.Unit.Tests.ps1

    .DESCRIPTION
        Request-RedditOAuthTokenInstalled Function unit tests
#>
Describe "Request-RedditOAuthTokenInstalled" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        # Tricks Request-RedditOAuthTokenInstalled into using WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token/Installed'
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
                    Name   = 'Script with DeviceID'
                    Params = @{
                        Application = Get-ApplicationScript
                        DeviceID    = 'MyDeviceID'
                    }
                }
                @{
                    Name   = 'WebApp'
                    Params = @{
                        Application = Get-ApplicationWebApp
                    }
                }
                @{
                    Name   = 'WebApp with DeviceID'
                    Params = @{
                        Application = Get-ApplicationWebApp
                        DeviceID    = 'MyDeviceID'
                    }
                }
                @{
                    Name   = 'Installed'
                    Params = @{
                        Application = Get-ApplicationInstalled
                    }
                }
                @{
                    Name   = 'Installed with DeviceID'
                    Params = @{
                        Application = Get-ApplicationInstalled
                        DeviceID    = 'MyDeviceID'
                    }
                }
            )
            It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
                Param($Name, $Params)
                { Request-RedditOAuthTokenInstalled @Params -ErrorAction Stop } |
                    Should not throw
            }
        }
        Context "Features" {
            It "Emits a 'RedditOAuthResponse' Object" {
                (Get-Command Request-RedditOAuthTokenInstalled).
                OutputType.Name.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
            It "Returns a 'RedditOAuthResponse' Object" {
                $ApplicationScript = Get-ApplicationScript
                $Object = Request-RedditOAuthTokenInstalled -Application $ApplicationScript |
                    Select-Object -First 1
                $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthResponse' }) |
                    Should be 'RedditOAuthResponse'
            }
        }
    }
}
