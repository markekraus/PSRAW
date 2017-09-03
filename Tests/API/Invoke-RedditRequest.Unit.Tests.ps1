<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/20/2017 1:34 PM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Invoke-RedditRequest.Unit.Tests.ps1

    .DESCRIPTION
        Invoke-RedditRequest Function unit tests
#>

Describe "Invoke-RedditRequest" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $Uri = Get-WebListenerUrl -Test 'User'
        $UriBad = Get-WebListenerUrl -Test 'StatusCode' -Query @{StatusCode = 404}
        $UriRaw = Get-WebListenerUrl -Test 'Echo' -Query @{StatusCode = 200; 'Content-Type' = 'text/plain'; Body = 'Hello World'}
        $UriDefaultToken = Get-WebListenerUrl -Test 'Get'
        $OriginalAuthBaseURL = [RedditOAuthToken]::AuthBaseURL
    }
    BeforeEach {
        # Tricks Request-RedditOAuthToken into using WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token'
        $TokenScript = Get-TokenScript
    }
    AfterAll {
        [RedditOAuthToken]::AuthBaseURL = $OriginalAuthBaseURL
    }
    $TestCases = @(
        @{
            Name   = 'Uri Only'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
            }
        }
        @{
            Name   = 'Get'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Method      = 'Get'
            }
        }
        @{
            Name   = 'Post Body'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Method      = 'Post'
                Body        = @{
                    Test = "Testy"
                } | ConvertTo-Json
            }
        }
        @{
            Name   = 'Headers'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Headers     = @{
                    'x-narwhals' = 'bacon'
                }
            }
        }
        @{
            Name   = 'Timeout'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                TimeoutSec  = '2'
            }
        }
    )
    It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
        param ($Name, $Params)
        { Invoke-RedditRequest @Params -ErrorAction Stop } | Should not throw
    }
    It "Emits a RedditApiResponse Object" {
        (Get-Command Invoke-RedditRequest).
        OutputType.Name.where( { $_ -eq 'RedditApiResponse' }) |
            Should be 'RedditApiResponse'
    }
    It "Returns a 'RedditApiResponse' Object" {
        $LocalParams = @{
            AccessToken = $TokenScript
            Uri         = $Uri
        }
        $Object = Invoke-RedditRequest @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq 'RedditApiResponse' }) |
            Should be 'RedditApiResponse'
    }
    It "Supports WhatIf" {
        {Invoke-RedditRequest -Uri $Uri -WhatIf -ErrorAction Stop } | should not throw
    }
    It "Has an irr alias" {
        { irr -Uri $Uri -AccessToken $TokenScript -ErrorAction Stop } | should not throw
    }
    It "Uses the Default token when one is not supplied" {
        Set-RedditDefaultOAuthToken -AccessToken $TokenScript
        { Invoke-RedditRequest -Uri $UriDefaultToken } | Should Not Throw
    }
    It 'Handles Token Refresh errors gracefully' {
        [RedditOAuthToken]::AuthBaseURL = $UriBad
        $LocalParams = @{
            AccessToken = Get-TokenBad
            Uri         = $Uri
        }
        Try {
            Invoke-RedditRequest @LocalParams -ErrorAction Stop
        }
        Catch {
            $Exception = $_
        }
        $Exception.ErrorDetails | Should match 'Unable to refresh Access Token'
    }
    It "Handles Invoke-WebRequest errors gracefully" {
        $LocalParams = @{
            AccessToken = $TokenScript
            Uri         = $UriBad
        }
        Try {
            Invoke-RedditRequest @LocalParams -ErrorAction Stop
        }
        Catch {
            $Exception = $_
        }
        $Exception.ErrorDetails | Should match "Unable to query Uri"
    }
    It "Handles Handles non-JSON responses" {
        $LocalParams = @{
            AccessToken = $TokenScript
            Uri         = $UriRaw
        }
        { Invoke-RedditRequest @LocalParams -ErrorAction Stop } | Should not Throw
    }
}
