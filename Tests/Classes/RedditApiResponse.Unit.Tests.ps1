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
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$InstalledId = '54321'
$InstalledSceret = ''
$SecInstalledSecret = [System.Security.SecureString]::new()
$InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

$UserId = 'reddituser'
$UserSceret = 'password'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TokenId = 'access_token'
$TokenSceret = '34567'
$SecTokenSecret = $TokenSceret | ConvertTo-SecureString -AsPlainText -Force 
$TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

$RefreshId = 'refresh_token'
$RefreshSceret = '76543'
$SecRefreshSecret = $RefreshSceret | ConvertTo-SecureString -AsPlainText -Force 
$RefreshCredential = [pscredential]::new($RefreshId, $SecRefreshSecret)

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

$TokenCode = [RedditOAuthToken]@{
    Application        = $ApplicationScript
    IssueDate          = Get-Date
    ExpireDate         = (Get-Date).AddHours(1)
    LastApiCall        = Get-Date
    ExportPath         = 'c:\temp\AccessToken.xml'
    Scope              = 'read'
    GUID               = [guid]::newguid()
    Notes              = 'This is a test token'
    TokenType          = 'bearer'
    GrantType          = 'Authorization_Code'
    RateLimitUsed      = 0
    RateLimitRemaining = 60
    RateLimitRest      = 60
    TokenCredential    = $TokenCredential
    RefreshCredential  = $RefreshCredential
}

$TempHtml = "{0}\{1}-empty.html" -f $env:TEMP, [guid]::NewGuid()
'' | Set-Content $TempHtml
$Request = [System.Net.WebRequest]::Create("file://$TempHtml")
$Response = $Request.GetResponse()
$Response.Headers['Content-Type'] = 'application/json'
$Result = [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]::new($Response)
Remove-Item -Force -Confirm:$false -Path $TempHtml -ErrorAction SilentlyContinue
$JSON = @'
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
'@
$TestHashes = @(
    @{
        Name = 'TestHash'
        Hash = @{
            AccessToken   = $TokenCode
            Parameters    = @{
                ContentType     = 'application/json'
                Method          = 'Default'
                Uri             = 'https://oauth.reddit.com/api/v1/me'
                ErrorAction     = 'Stop'
                WebSession      = $TokenCode.Session
                UseBasicParsing = $true
            }
            RequestDate   = Get-Date
            Response      = $Result
            ContentObject = $JSON | ConvertFrom-Json
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