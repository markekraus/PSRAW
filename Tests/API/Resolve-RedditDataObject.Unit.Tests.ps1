<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    9/03/2017 11:02 AM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Resolve-RedditDataObject.Unit.Tests.ps1

    .DESCRIPTION
        Resolve-RedditDataObject Function unit tests
#>
Describe "Resolve-RedditDataObject" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

    }
    InModuleScope $ModuleName {
        $Url = Get-WebListenerUrl -Test 'Subreddit'
        Get-TokenScript | Set-RedditDefaultOAuthToken
        $Response = Invoke-RedditRequest -Uri $Url
        $RedditThing = [RedditThing]$Response.ContentObject
        $PSObject = $Response.ContentObject
        Context "Test Cases" {
            $TestCases = @(
                @{
                    Name   = 'RedditApiResponse'
                    Params = @{
                        RedditAPIResponse = $Response
                    }
                }
                @{
                    Name   = 'RedditThing'
                    Params = @{
                        RedditThing = $RedditThing
                    }
                }
                @{
                    Name   = 'PSObject'
                    Params = @{
                        PSObject = $PSObject
                    }
                }
            )
            It "'<Name>' Parameter set has no errors" -TestCases $TestCases {
                Param($Name, $Params)
                $Result = @{}
                { $Result['Object'] = Resolve-RedditDataObject @Params -ErrorAction Stop } |
                    Should Not Throw
                $Result.Object | Should Not BeNullOrEmpty
                $Result.Object.psobject.typenames.where( { $_ -eq 'RedditListing' }) |
                    Should Be 'RedditListing'
            }
        }
        Context "Features" {
            It "Supports WhatIf" {

                {Resolve-RedditDataObject -RedditThing $RedditThing -WhatIf } | Should Not Throw
            }
        }
    }
}
