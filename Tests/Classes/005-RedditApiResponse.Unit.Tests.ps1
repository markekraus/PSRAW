<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/20/2017 1:15 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditApiResponse.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditApiResponse Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditApiResponse'

$ClientId = '54321'
$ClientSecret = '12345'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSecret = 'password'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TokenId = 'access_token'
$TokenSecret = '34567'
$SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
$TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

$ApplicationScript = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $ClientCredential
    UserCredential   = $UserCredential
    Type             = 'Script'
}

$TokenScript = [RedditOAuthToken]@{
    Application        = $ApplicationScript
    IssueDate          = Get-Date
    ExpireDate         = (Get-Date).AddHours(1)
    LastApiCall        = Get-Date
    ExportPath         = 'c:\temp\AccessToken.xml'
    Scope              = 'read'
    GUID               = [guid]::newguid()
    Notes              = 'This is a test token'
    TokenType          = 'bearer'
    GrantType          = 'Password'
    RateLimitUsed      = 0
    RateLimitRemaining = 60
    RateLimitRest      = 60
    TokenCredential    = $TokenCredential
}

$Uri = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%0A%20%20%20%20%22comment_karma%22%3A%200%2C%20%0A%20%20%20%20%22created%22%3A%201389649907.0%2C%20%0A%20%20%20%20%22created_utc%22%3A%201389649907.0%2C%20%0A%20%20%20%20%22has_mail%22%3A%20false%2C%20%0A%20%20%20%20%22has_mod_mail%22%3A%20false%2C%20%0A%20%20%20%20%22has_verified_email%22%3A%20null%2C%20%0A%20%20%20%20%22id%22%3A%20%221%22%2C%20%0A%20%20%20%20%22is_gold%22%3A%20false%2C%20%0A%20%20%20%20%22is_mod%22%3A%20true%2C%20%0A%20%20%20%20%22link_karma%22%3A%201%2C%20%0A%20%20%20%20%22name%22%3A%20%22reddit_bot%22%2C%20%0A%20%20%20%20%22over_18%22%3A%20true%0A%7D'
$response = Invoke-WebRequest -UseBasicParsing -Uri $Uri

<#
{
    "comment_karma": 0, 
    "created": 1389649907.0, 
    "created_utc": 1389649907.0, 
    "has_mail": false, 
    "has_mod_mail": false, 
    "has_verified_email": null, 
    "id": "1", 
    "is_gold": false, 
    "is_mod": true, 
    "link_karma": 1, 
    "name": "reddit_bot", 
    "over_18": true
}
#>

$TestHashes = @(
    @{
        Name = 'TestHash'
        Hash = @{
            AccessToken   = $TokenScript
            Parameters    = @{
                ContentType     = 'application/json'
                Method          = 'Default'
                Uri             = 'https://oauth.reddit.com/api/v1/me'
                ErrorAction     = 'Stop'
                WebSession      = $TokenScript.Session
                UseBasicParsing = $true
            }
            RequestDate   = $response.Headers.Date[0]
            Response      = $response
            ContentObject = $response.Content | ConvertFrom-Json
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            {[RedditApiResponse]$TestHash.Hash} | should not throw
        }
    }
    It "Has a working default constructor" {
        {[RedditApiResponse]::new()} | Should not throw
        
    }
}