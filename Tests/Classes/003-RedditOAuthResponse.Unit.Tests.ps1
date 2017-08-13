<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    8/2/2017 4:51 PM
     Edited on:     8/2/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditOAuthResponse.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditOAuthResponse Class
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditOAuthResponse'


#$response = Invoke-WebRequest -UseBasicParsing -Uri "https://www.reddit.com/api/info.json?id=t1_dkxm9j5" -ErrorAction SilentlyContinue
$response = Invoke-WebRequest -UseBasicParsing -Uri 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%0A%20%20%20%20%22access_token%22%3A%20%223fdd9e66-eaaa-4263-a834-a33cff22886e%2C%0A%20%20%20%20%22token_type%22%3A%20%22bearer%22%2C%0A%20%20%20%20%22expires_in%22%3A%20900%2C%0A%20%20%20%20%22scope%22%3A%20%22*%22%2C%0A%20%20%20%20%22refresh_token%22%3A%20%2297483996-a6da-41c6-a535-2a289b10591b%22%0A%7D'
<#
{
    "access_token": "3fdd9e66-eaaa-4263-a834-a33cff22886e,
    "token_type": "bearer",
    "expires_in": 900,
    "scope": "*",
    "refresh_token": "97483996-a6da-41c6-a535-2a289b10591b"
}
#>
$TestHashes = @(
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


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            {[RedditOAuthResponse]$TestHash.Hash} | should not throw
        }
    }
    It "Has a working default constructor" {
        {[RedditOAuthResponse]::new()} | Should not throw
        
    }
}