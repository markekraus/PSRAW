<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/10/2017 04:09 PM
     Edited on:     09/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditOAuthToken.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditOAuthToken Class
#>

Describe "[RedditOAuthToken] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $UriPassword = Get-WebListenerUrl -Test 'Token'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $UriPassword
        $ResponseObjectPassword = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        }
        $TokenSecret = $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty access_token
        $TokeScript = [RedditOAuthToken]::new(
            'Password',
            (Get-ApplicationScript),
            $ResponseObjectPassword
        )

        $TestCases = @(
            @{
                Name = 'Token'
                Hash = @{
                    Application        = Get-ApplicationScript
                    IssueDate          = Get-Date
                    ExpireDate         = (Get-Date).AddHours(1)
                    LastApiCall        = Get-Date
                    ExportPath         = 'c:\temp\AccessToken.xml'
                    Scope              = 'read'
                    GUID               = [guid]::NewGuid()
                    Notes              = 'This is a test token'
                    TokenType          = 'bearer'
                    GrantType          = 'Password'
                    RateLimitUsed      = 0
                    RateLimitRemaining = 60
                    RateLimitRest      = 60
                    TokenCredential    = Get-TokenCredential
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        {[RedditOAuthToken]$Hash} | should not throw
    }
    It "Has a working Constructor for response objects." {
        $UriInstalled = Get-WebListenerUrl -Test 'Token/Installed'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $UriInstalled
        $ResponseObjectInstalled = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        }
        {
            [RedditOAuthToken]::new(
                'Installed',
                (Get-ApplicationInstalled),
                $ResponseObjectInstalled
            )
        } | should not throw
    }
    It "Fails if the Object is not an application/json response" {
        {
            [RedditOAuthToken]::new(
                'Password',
                (Get-ApplicationInstalled),
                [RedditOAuthResponse]@{ContentType = 'invalid'}
            )
        } | should throw "Response Content-Type is not 'application/json'"
    }
    It "Has a working GetRateLimitReset() method" {
        $TokeScript.GetRateLimitReset() | should BeOfType system.datetime
        $TokeScript.GetRateLimitReset() | should BeGreaterThan (get-date)
    }
    It "Has a working IsRateLimited() method" {
        $TokeScript.IsRateLimited() | should BeOfType System.Boolean
        $TokeScript.IsRateLimited() | should be $false
        $tempval = $TokeScript.LastApiCall.PSObject.copy()
        $TokeScript.LastApiCall = (get-date).AddHours(-3)
        $TokeScript.IsRateLimited() | should be $false
        $TokeScript.LastApiCall = $tempval
        $tempval = $TokeScript.RateLimitRemaining
        $TokeScript.RateLimitRemaining = 0
        $TokeScript.IsRateLimited() | should be $true
    }
    It "Has a working IsExpired() method" {
        $TokeScript.IsExpired() | should BeOfType System.Boolean
        $TokeScript.IsExpired() | should be $false
    }
    it "Has a working GetAccessToken() method" {
        $TokeScript.GetAccessToken() | should be $TokenSecret
    }
    It "Has a working ToString() method" {
        $TokeScript.ToString() | should Match 'GUID: '
        $TokeScript.ToString() | should Match 'Expires: '
    }
    It "Has a working Refresh() method" {
        $UriRefresh = Get-WebListenerUrl -Test 'Token/New'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $UriRefresh
        $ResponseObjectRefresh = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        }
        $RefreshToken = $Response.Content | ConvertFrom-Json | Select-Object -ExpandProperty access_token
        $OldToken = @{
            IssueDate  = $TokeScript.IssueDate.psobject.copy()
            ExpireDate = $TokeScript.ExpireDate.psobject.copy()
            GUID       = $TokeScript.GUID.psobject.copy()
        }
        {
            $TokeScript.Refresh(
                [RedditOAuthResponse]@{ContentType = 'invalid'}
            )
        } | should throw "Response Content-Type is not 'application/json'"
        {$TokeScript.Refresh($ResponseObjectRefresh)} | Should Not throw
        $TokeScript.GUID | should be  $OldToken.GUID
        $TokeScript.GetAccessToken() | should Be $RefreshToken
        $TokeScript.IssueDate | Should BeGreaterThan $OldToken.IssueDate
        $TokeScript.ExpireDate | Should BeGreaterThan $OldToken.ExpireDate
    }
    It "Has a working Reserialize() static method" {
        $Object = [PSCustomObject]@{
            Application        = Get-ApplicationWebApp
            IssueDate          = Get-Date
            ExpireDate         = (Get-Date).AddHours(1)
            LastApiCall        = Get-Date
            ExportPath         = 'c:\temp\AccessToken.xml'
            Scope              = 'read'
            GUID               = [guid]::NewGuid()
            Notes              = 'This is a test token'
            TokenType          = 'bearer'
            GrantType          = 'Password'
            RateLimitUsed      = 0
            RateLimitRemaining = 60
            RateLimitRest      = 60
            TokenCredential    = Get-TokenCredential
        }
        $Token = [RedditOAuthToken]::Reserialize($Object)
        foreach ($Property in $Object.psobject.Properties.Name) {
            $token.$Property | should be $Object.$Property
        }
    }
    It "has a working UpdateRateLimit() method" {
        $Response = [PSCustomObject]@{
            Headers = @{
                Date                    = Get-Date '2017/05/20'
                'x-ratelimit-remaining' = 59
                'x-ratelimit-used'      = 1
                'x-ratelimit-reset'     = 30
            }
        }
        $TokeScript.UpdateRateLimit($Response)
        $TokeScript.RateLimitRemaining | should be 59
        $TokeScript.RateLimitUsed | should be 1
        $TokeScript.RateLimitRest | should be 30
        $TokeScript.LastApiCall | should be $(Get-Date '2017/05/20')
    }
}
