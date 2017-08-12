<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/10/2017 04:09 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditOAuthToken Class
#>

$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditOAuthToken'

$ClientId = '54321'
$ClientSecret = '12345'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$InstalledId = '54321'
$SecInstalledSecret = [System.Security.SecureString]::new()
$InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

$UserId = 'reddituser'
$UserSecret = 'password'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TokenId = 'access_token'
$TokenSecret = '34567'
$SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
$TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

$ApplicationWebApp = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $ClientCredential
    Type             = 'WebApp'
}
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
$ApplicationInstalled = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $InstalledCredential
    Type             = 'Installed'
}

<#
{"access_token": "34567", "token_type": "bearer", "device_id": "MyDeviceID", "expires_in": 3600, "scope": "*"}
#>
$EchoUriInstalled = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%2234567%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22device_id%22%3A%20%22MyDeviceID%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
$Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriInstalled
$ResponseObjectInstalled = [RedditOAuthResponse]@{
    Response    = $Response
    RequestDate = $Response.Headers.Date[0]
    Content     = $Response.Content
    ContentType = 'application/json'
} 
<#
{"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "scope": "read"}
#>
$EchoUriPassword = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%2234567%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22read%22%7D'
$Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriPassword
$ResponseObjectPassword = [RedditOAuthResponse]@{
    Response    = $Response
    RequestDate = $Response.Headers.Date[0]
    Content     = $Response.Content
    ContentType = 'application/json'
} 
<#
{"access_token": "AABBCC", "token_type": "bearer", "expires_in": 3600, "scope": "*"}
#>
$EchoUriRefresh = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%22AABBCC%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
$Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriRefresh
$ResponseObjectRefresh = [RedditOAuthResponse]@{
    Response    = $Response
    RequestDate = $Response.Headers.Date[0]
    Content     = $Response.Content
    ContentType = 'application/json'
} 

$ResponseUri = [System.Uri]('https://localhos/#access_token=34567&token_type=bearer&state=MyState&expires_in=3600&scope=read')
$ResponseUriRefresh = [System.Uri]('https://localhos/#access_token=DDEEFF&token_type=bearer&state=MyState&expires_in=3600&scope=read')

$TestHashes = @(
    @{
        Name = 'Token'
        Hash = @{
            Application        = $ApplicationScript
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
            TokenCredential    = $TokenCredential
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            {[RedditOAuthToken]$TestHash.Hash} | should not throw
        }
    }
    It "Has a working Constructor for response objects." {
        {
            [RedditOAuthToken]::new(
                'Installed',
                $ApplicationInstalled,
                $ResponseObjectInstalled
            )
        } | should not throw
    }
    It "Fails if the Object is not an application/json response" {
        {
            [RedditOAuthToken]::new(
                'Password',
                $ApplicationInstalled,
                [RedditOAuthResponse]@{ContentType = 'invalid'}
            )
        } | should throw "Response Content-Type is not 'application/json'"
    }
    $TokeScript = [RedditOAuthToken]::new(
        'Password',
        $ApplicationScript,
        $ResponseObjectPassword
    )
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
        $TokeScript.GetAccessToken() | should be 34567
    }
    It "Has a working ToString() method" {
        $TokeScript.ToString() | should Match 'GUID: '
        $TokeScript.ToString() | should Match 'Expires: '
    }
    It "Has a working Refresh() method" {
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
        $TokeScript.GetAccessToken() | should be 'AABBCC'
        $TokeScript.IssueDate | Should BeGreaterThan $OldToken.IssueDate
        $TokeScript.ExpireDate | Should BeGreaterThan $OldToken.ExpireDate
    }
    It "Has a working Reserialize() static method" {
        $Object = [PSCustomObject]@{
            Application        = $ApplicationWebApp
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
            TokenCredential    = $TokenCredential
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