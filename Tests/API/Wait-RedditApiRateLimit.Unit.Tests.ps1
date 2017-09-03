<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/18/2017 06:19 PM
     Edited on:     9/01/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Wait-RedditApiRateLimit.Unit.Tests.ps1

    .DESCRIPTION
        Wait-RedditApiRateLimit Function unit tests
#>

Describe "Wait-RedditApiRateLimit" -Tags Unit, Build {
    Initialize-PSRAWTest
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    Import-Module -force $ModulePath

    InModuleScope $ModuleName {
        $TestCases = @(
            @{
                Name   = 'Code'
                Params = @{
                    AccessToken = Get-TokenScript
                }
            }
            @{
                Name   = 'Sleep'
                Params = @{
                    AccessToken     = Get-TokenScript
                    MaxSleepSeconds = 300
                }
            }
        )
        It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
            Param($Name, $Params)
            { Wait-RedditApiRateLimit @Params -ErrorAction Stop } | Should Not throw
        }
        It "Emits a 'System.Void' Object" {
            (Get-Command Wait-RedditApiRateLimit).OutputType.Name.where( { $_ -eq 'System.Void' }) | Should Be 'System.Void'
        }
        It "Sleeps when the Token is Rate Limited" {
            $AccessToken = Get-TokenScript
            $AccessToken.RateLimitRemaining = 0
            $AccessToken.RateLimitRest = 3
            Measure-Command {
                $AccessToken.LastApiCall = Get-Date
                $AccessToken | Wait-RedditApiRateLimit
            } | Select-Object -ExpandProperty TotalSeconds | Should BeGreaterThan 2
        }
        It "Sleeps only until MaxSleepSeconds" {
            $AccessToken = Get-TokenScript
            $AccessToken.RateLimitRemaining = 0
            $AccessToken.RateLimitRest = 5
            Measure-Command {
                $AccessToken.LastApiCall = Get-Date
                $AccessToken | Wait-RedditApiRateLimit -MaxSleepSeconds 3
            } | Select-Object -ExpandProperty TotalSeconds | Should BeLessThan 5
        }
        It "Supports WhatIf" {
            $AccessToken = Get-TokenScript
            $AccessToken.RateLimitRemaining = 0
            $AccessToken.RateLimitRest = 5
            Measure-Command {
                $AccessToken.LastApiCall = Get-Date
                $AccessToken | Wait-RedditApiRateLimit -WhatIf
            } | Select-Object -ExpandProperty TotalSeconds | Should BeLessThan 1
        }
    }
}
