<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/05/2017 02:48 PM
     Edited on:     5/15/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	004-RedditOAuthToken.ps1
    
    .DESCRIPTION
        RedditOAuthToken Class
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]

Class RedditOAuthToken {
    [RedditApplication]$Application
    [datetime]$IssueDate
    [datetime]$ExpireDate
    [datetime]$LastApiCall
    [string]$ExportPath
    [RedditOAuthScope[]]$Scope
    [guid]$GUID = [guid]::NewGuid()
    [string]$Notes
    [string]$TokenType
    [RedditOAuthGrantType]$GrantType
    [int]$RateLimitUsed
    [int]$RateLimitRemaining
    [int]$RateLimitRest
    [string]$DeviceId
    hidden [pscredential]$TokenCredential
    hidden [pscredential]$RefreshCredential
    hidden [Microsoft.PowerShell.Commands.WebRequestSession]$Session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    static [string] $AuthBaseURL = 'https://www.reddit.com/api/v1/access_token'

    RedditOAuthToken () {}

    RedditOAuthToken (
        [RedditOAuthGrantType]$GrantType, 
        [RedditApplication]$Application, 
        [Object]$Response
    ) {
        #URI Handler
        If ($Response.psobject.typenames -contains 'system.uri') {
            if (-not $Response.Fragment) {
                $Exception = [System.ArgumentException]::New(
                    "Response does not include Fragment"
                )
                $Exception | Add-Member -Name Uri -MemberType NoteProperty -Value $Response
                Throw $Exception
            }
            $Content = @{}
            $Parsed = [System.Web.HttpUtility]::
            ParseQueryString($Response.Fragment -replace '^#')
            $Parsed.Getenumerator() |
                ForEach-Object {
                $Content.Add($_, $Parsed[$_])
            }
        }
        #WebResponse Handler
        Else {
            If ( -not ($Response.Headers.'Content-type' -match 'application/json')) {
                $Exception = [System.ArgumentException]::New(
                    "Response Content-Type is not 'application/json'"
                )
                $Exception | Add-Member -Name Response -MemberType NoteProperty -Value $Response
                Throw $Exception
            }
            $Content = $Response.Content | ConvertFrom-Json -ErrorAction Stop
        }
        # Do the needful
        $This.GrantType = $GrantType
        $This.Application = $Application
        $This.DeviceId = $Content.DeviceId
        $This.IssueDate = Get-Date
        $This.LastApiCall = $This.IssueDate
        $This.TokenType = $Content.token_type
        $This.Scope = $Content.Scope -split ' '
        $This.ExpireDate = (get-date).AddSeconds($Content.expires_in)
        $This.RateLimitRemaining = 60
        $This.RateLimitUsed = 0
        $This.RateLimitRest = 60
        if ($Content.access_token) {
            $SecString = $Content.access_token | ConvertTo-SecureString -AsPlainText -Force
            $This.TokenCredential = [pscredential]::new('access_token', $SecString)
        }
        if ($Content.refresh_token) {
            $SecString = $Content.refresh_token | ConvertTo-SecureString -AsPlainText -Force
            $This.RefreshCredential = [pscredential]::new('refresh_token', $SecString)
        }
    }

    [datetime] GetRateLimitReset() {
        return ($This.LastApiCall).AddSeconds($This.RateLimitRest)
    }

    [bool]IsRateLimited() {
        $Now = Get-date
        $Reset = $This.GetRateLimitReset()
        if ($now -ge $Reset) {
            return $False
        }
        if ($Now -lt $Reset -and $This.RateLimitRemaining -gt 0) {
            return $false
        }
        return $true
    }

    [bool] IsExpired() {
        return ((get-date) -ge $This.ExpireDate)
    }

    [string] GetAccessToken() {
        return $This.TokenCredential.GetNetworkCredential().Password
    }
    [string] GetRefreshToken() {
        return $This.RefreshCredential.GetNetworkCredential().Password
    }

    [string] ToString() {
        Return ('GUID: {0} Expires: {1}' -f $This.GUID, $This.ExpireDate)
    }
    [void] Refresh ([Object]$Response) {
        #URI Handler
        If ($Response.psobject.typenames -contains 'system.uri') {
            if (-not $Response.Fragment) {
                $Exception = [System.ArgumentException]::New(
                    "Response does not include Fragment"
                )
                $Exception | Add-Member -Name Uri -MemberType NoteProperty -Value $Response
                Throw $Exception
            }
            $Content = @{}
            $Parsed = [System.Web.HttpUtility]::
            ParseQueryString($Response.Fragment -replace '^#')
            $Parsed.Getenumerator() |
                ForEach-Object {
                $Content.Add($_, $Parsed[$_])
            }
        }
        #WebResponse Handler
        Else {
            If ( -not ($Response.Headers.'Content-type' -match 'application/json')) {
                $Exception = [System.ArgumentException]::New(
                    "Response Content-Type is not 'application/json'"
                )
                $Exception | Add-Member -Name Response -MemberType NoteProperty -Value $Response
                Throw $Exception
            }
            $Content = $Response.Content | ConvertFrom-Json -ErrorAction Stop
        }
        # Do the needful
        $This.IssueDate = Get-Date
        $This.TokenType = $Content.token_type
        $This.Scope = $Content.Scope -split ' '
        $This.ExpireDate = (get-date).AddSeconds($Content.expires_in)
        if ($Content.access_token) {
            $SecString = $Content.access_token | ConvertTo-SecureString -AsPlainText -Force
            $This.TokenCredential = [pscredential]::new('access_token', $SecString)
        }
    }

    [void] UpdateRateLimit ([Object]$Response) {
        $This.RateLimitRemaining = $Response.Headers.'x-ratelimit-remaining'
        $This.RateLimitUsed = $Response.Headers.'x-ratelimit-used'
        $This.RateLimitRest = $Response.Headers.'x-ratelimit-reset'
        $This.LastApiCall = $Response.Headers.date
    }

    Static [RedditOAuthToken] Reserialize ([Object]$Object) {
        $Token = [RedditOAuthToken]::new()
        $Properties = $object.psobject.properties.name | Where-Object {-not ($_ -like 'Session' )}
        Foreach ($Property in $Properties) {
            $Token.$Property = $Object.$Property
        }
        return $Token
    }
}