<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    8/2/2017 4:51 PM
     Edited on:     8/29/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditOAuthResponse.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditOAuthResponse Class
#>
Describe "[RedditOAuthResponse] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $Uri      = Get-WebListenerUrl -Test Token
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Uri
        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    Parameters  = @{
                        ContentType     = 'application/json'
                        Method          = 'Default'
                        Uri             = 'https://oauth.reddit.com/api/v1/me'
                        ErrorAction     = 'Stop'
                        UseBasicParsing = $true
                    }
                    RequestDate = $response.Headers.Date[0]
                    Response    = $response
                    Content     = $response.Content
                    ContentType = 'application/json'
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        Param($Name,$Hash)
        {[RedditOAuthResponse]$Hash} | should not throw
    }
    It "Has a working default constructor" {
        {[RedditOAuthResponse]::new()} | Should not throw        
    }
}
