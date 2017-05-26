<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/01/2017 12:00 PM
     Edited on:     5/10/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	003-RedditOAuthCode.psm1
    
    .DESCRIPTION
        RedditOAuthCode Class
#>

Class RedditOAuthCode {
    [RedditApplication]$Application
    [string]$AuthBaseURL
    [datetime]$IssueDate
    [String]$StateSent
    [String]$StateReceived
    [RedditOAuthDuration]$Duration
    [RedditOAuthResponseType]$ResponseType
    hidden [System.Management.Automation.PSCredential]$AuthCodeCredential
    # https://github.com/reddit/reddit/blob/master/r2/r2/models/token.py
    static [timespan]$TTL = [timespan]::FromMinutes(10)

    RedditOAuthCode() {}

    [string] GetAuthorizationCode () {
        Return $This.AuthCodeCredential.GetNetworkCredential().Password
    }

    [DateTime] GetExpireDate() {
        Return ($This.IssueDate + [RedditOAuthCode]::TTL)
    }

    [bool] IsExpired() {
        Return ((Get-Date) -ge $This.GetExpireDate())
    }

    [string] ToString() {
        Return ('Expires: {0} Application: ({1})' -f $This.GetExpireDate(), $This.Application)
    }

}