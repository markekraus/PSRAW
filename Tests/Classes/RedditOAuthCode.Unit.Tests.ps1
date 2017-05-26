<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/04/2017 04:13 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditOAuthCode.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditOAuthCode Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force
$Class = 'RedditOAuthCode'

$ClientId = '54321'
$ClientSecret = '12345'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSecret = 'password12345'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()

$Application = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $ClientCredential
    UserCredential   = $UserCredential
    Type             = 'Script'
    ExportPath       = $ExportFile 
}

$CodeId = 'AuthCode'
$CodeSecret = '98765'
$SecCodeSecret = $CodeSecret | ConvertTo-SecureString -AsPlainText -Force 
$CodeCredential = [pscredential]::new($CodeId, $SecCodeSecret)

$IssueDate = Get-Date
$ExpireDate = $IssueDate + [timespan]::FromMinutes(10)

$TestHashes = @(
    @{
        Name = 'Valid'
        Hash = @{
            Application        = $Application
            AuthBaseURL        = [RedditApplication]::AuthBaseURL            
            IssueDate          = $IssueDate
            StateSent          = '75c3c667-8bd9-4755-a0c9-e438f224f93a'
            StateReceived      = '75c3c667-8bd9-4755-a0c9-e438f224f93a'
            Duration           = 'Permanent'
            ResponseType       = 'Code'
            AuthCodeCredential = $CodeCredential
        }
    }
    @{
        Name = 'Expired'
        Hash = @{
            Application        = $Application
            AuthBaseURL        = [RedditApplication]::AuthBaseURL            
            IssueDate          = [datetime]::MinValue
            StateSent          = '75c3c667-8bd9-4755-a0c9-e438f224f93a'
            StateReceived      = '75c3c667-8bd9-4755-a0c9-e438f224f93a'
            Duration           = 'Permanent'
            ResponseType       = 'Code'
            AuthCodeCredential = $CodeCredential
        }
    }
)
Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            {[RedditOAuthCode]$TestHash.Hash} | should not throw
        }
    }
    It 'Has a [TimeSpan] TTL static property' {
        [RedditOAuthCode]::TTL | should BeOfType System.TimeSpan
        ([RedditOAuthCode]::TTL).Ticks | should BeGreaterThan 0
    }
    It 'Has a working GetAuthorizationCode() method' {
        ([RedditOAuthCode]$TestHashes[0].Hash).
        GetAuthorizationCode() | should be $CodeSecret
    }
    It 'Has a working GetExpireDate() method' {
        ([RedditOAuthCode]$TestHashes[0].Hash).GetExpireDate() |
            should be $ExpireDate
    }
    It 'Has a working IsExpired() method' {
        ([RedditOAuthCode]$TestHashes[0].Hash).IsExpired() |
            should be $false
        ([RedditOAuthCode]$TestHashes[1].Hash).IsExpired() |
            should be $true
    }
    It 'Has a working ToString() method' {
        ([RedditOAuthCode]$TestHashes[0].Hash).ToString() | should match "Expires: .* Application: \(.*\)"
    }
}