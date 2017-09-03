<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/07/2017 8:50 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Request-RedditOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
        Request-RedditOAuthToken Function unit tests
#>
Describe "Request-RedditOAuthToken" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $OriginalAuthBaseURL = [RedditOAuthToken]::AuthBaseURL
        $TestCases = @(
            @{
                Name   = 'Script/Script'
                Url    = Get-WebListenerUrl -Test 'Token'
                Params = @{
                    Application = Get-ApplicationScript
                    Script      = $True
                }
            }
            @{
                Name   = 'Client/Script'
                Url    = Get-WebListenerUrl -Test 'Token'
                Params = @{
                    Application = Get-ApplicationScript
                    Client      = $True
                }
            }
            @{
                Name   = 'Client/WebApp'
                Url    = Get-WebListenerUrl -Test 'Token'
                Params = @{
                    Application = Get-ApplicationWebApp
                    Client      = $True
                }
            }
            @{
                Name   = 'Installed/Installed'
                Url    = Get-WebListenerUrl -Test 'Token/Installed'
                Params = @{
                    Application = Get-ApplicationInstalled
                    Installed   = $True
                }
            }
            @{
                Name   = 'Installed/Installed/DeviceID'
                Url    = Get-WebListenerUrl -Test 'Token/Installed'
                Params = @{
                    Application = Get-ApplicationInstalled
                    Installed   = $True
                    DeviceID    = 'MyDeviceID'
                }
            }
        )
    }
    BeforeEach {
        # Tricks the private functions to use WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token'
    }
    AfterAll {
        [RedditOAuthToken]::AuthBaseURL = $OriginalAuthBaseURL
    }
    Context "Test Cases" {
        It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
            Param($Name, $Url, $Params)
            # Tricks the private functions to use WebListener
            [RedditOAuthToken]::AuthBaseURL = $Url
            { Request-RedditOAuthToken @Params -ErrorAction Stop } | Should not throw
        }
    }
    Context "Features" {
        It "Emits a 'RedditOAuthToken' Object" {
            (Get-Command Request-RedditOAuthToken).
            OutputType.Name.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
        It "Returns a 'RedditOAuthToken' Object with PassThru" {
            $ApplicationScript = Get-ApplicationScript
            $Object = Request-RedditOAuthToken -Script -Application $ApplicationScript -PassThru |
                Select-Object -First 1
            $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthToken' }) |
                Should be 'RedditOAuthToken'
        }
    }
}
