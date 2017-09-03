<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/20/2017 1:15 PM
     Edited on:     9/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditApiResponse.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditApiResponse Class
#>

Describe "[RedditApiResponse] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $Uri = Get-WebListenerUrl -Test 'User'
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Uri -SessionVariable 'Session'
        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    AccessToken   = Get-TokenScript
                    RequestDate   = $response.Headers.Date[0]
                    Response      = $response
                    ContentObject = $response.Content | ConvertFrom-Json
                    ContentType   = 'application/json'
                    Parameters    = @{
                        ContentType     = 'application/json'
                        Method          = 'Default'
                        Uri             = $Uri
                        ErrorAction     = 'Stop'
                        WebSession      = $Session
                        UseBasicParsing = $true
                    }
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        {[RedditApiResponse]$Hash} | should not throw
    }
    It "Has a working default constructor" {
        {[RedditApiResponse]::new()} | Should not throw

    }
}
