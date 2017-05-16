<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/28/2017 04:40 AM
     Edited on:     5/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditApplication.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditApplication Class
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditApplication'

$ClientId = '54321'
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId,$SecClientSecret)

$UserId = 'reddituser'
$UserSceret = 'password'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId,$SecUserSecret)

$EmptyCred = [System.Management.Automation.PSCredential]::Empty

$TestHashes = @(
    @{
        Name = 'WebApp'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            Type = 'WebApp'
        }
    }
    @{
        Name = 'Script'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
            Type = 'Script'
        }
    }
    @{
        Name = 'Installed'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            Type = 'Installed'
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach($TestHash in $TestHashes){
        It "Converts the '$($TestHash.Name)' hash"{
            {[RedditApplication]$TestHash.Hash} | should not throw
        }
    }
     It "Has a working Uber Constructor." {
        {
            [RedditApplication]::new(
                'TestApplication',
                'This is only a test',
                'https://localhost/',
                'windows:PSRAW-Unit-Tests:v1.0.0.0',
                'Script',
                [guid]::NewGuid(),
                'c:\RedditApplication.xml',
                'read',
                $ClientCredential,
                $UserCredential
            )
        } | should not throw
    }
    $Application = [RedditApplication]::new('TestApplication',
            'This is only a test',
            'https://localhost/',
            'windows:PSRAW-Unit-Tests:v1.0.0.0',
            'Script',
            [guid]::NewGuid(),
            'c:\RedditApplication.xml',
            'read',
            $ClientCredential,
            $UserCredential)
    It "Has a working GetClientSecret() method" {
        $Application.GetClientSecret() | should be $ClientSceret
    }
    It "Has a working GetClientSecret() method" {
        $Application.GetUserPassword() | should be $UserSceret
    }
    It "Has a working GetAuthorzationUrl() method" {
        $url = $Application.GetAuthorzationUrl()
        $url | should match 'client_id=54321'
        $url | should match 'response_type=Code'
        $url | should match 'redirect_uri=https%3a%2f%2flocalhost%2f'
        $url | should match 'duration=Permanent'
        $url | should match 'https://www.reddit.com:443/api/v1/authorize'
    }
    It "Has a working GetAuthorzationUrl(ResponseType, Duration) method" {
        $url = $Application.GetAuthorzationUrl('code','permanent')
        $url | should match 'client_id=54321'
        $url | should match 'response_type=Code'
        $url | should match 'redirect_uri=https%3a%2f%2flocalhost%2f'
        $url | should match 'duration=Permanent'
        $url | should match 'https://www.reddit.com:443/api/v1/authorize'
    }
    It "Has a working GetAuthorzationUrl(ResponseType, Duration, State) method" {
        $url = $Application.GetAuthorzationUrl('code','permanent','myteststate')
        $url | should match 'client_id=54321'
        $url | should match 'response_type=Code'
        $url | should match 'redirect_uri=https%3a%2f%2flocalhost%2f'
        $url | should match 'duration=Permanent'
        $url | should match 'https://www.reddit.com:443/api/v1/authorize'
        $url | should match 'state=myteststate'
    }
    It "Has a working GetAuthorzationUrl(ResponseType, Duration, State, AuthBaseUrl) method" {
        $url = $Application.GetAuthorzationUrl('code','permanent','myteststate','https://google.com/')
        $url | should match 'client_id=54321'
        $url | should match 'response_type=Code'
        $url | should match 'redirect_uri=https%3a%2f%2flocalhost%2f'
        $url | should match 'duration=Permanent'
        $url | should match 'https://google.com'
        $url | should match 'state=myteststate'
    }
    It "Has a AuthBaseURL static property" {
        {[RedditApplication]::AuthBaseURL} | should not throw
        [RedditApplication]::AuthBaseURL | should not BeNullOrEmpty
    }
    It "Throws an exception with the default constructor" {
        {[RedditApplication]::new()} | Should throw "The method or operation is not implemented."
    }
    It "Throws an exception with the default constructor" {
        {[RedditApplication]::new()} | Should throw "The method or operation is not implemented."
    }
    It "Requires a Type" {
        {
            [RedditApplication]@{
                Name = 'TestApplication'
                Description = 'This is only a test'
                RedirectUri = 'https://localhost/'
                UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope = 'read'
                ClientCredential = $ClientCredential
                UserCredential = $UserCredential
            }
        } | Should Throw 
    }
    It "Requires a ClientCredential" {
        {
            [RedditApplication]@{
                Name = 'TestApplication'
                Description = 'This is only a test'
                RedirectUri = 'https://localhost/'
                UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope = 'read'
                Type = 'Script'
                UserCredential = $UserCredential
            }
        } | Should Throw 
    }
    It "Requires a UserAgent" {
        {
            [RedditApplication]@{
                Name = 'TestApplication'
                Description = 'This is only a test'
                RedirectUri = 'https://localhost/'
                Scope = 'read'
                Type = 'Script'
                ClientCredential = $ClientCredential
                UserCredential = $UserCredential
            }
        } | Should Throw 
    }
    It "Requires a RedirectUri" {
        {
            [RedditApplication]@{
                Name = 'TestApplication'
                Description = 'This is only a test'
                UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope = 'read'
                Type = 'Script'
                ClientCredential = $ClientCredential
                UserCredential = $UserCredential
            }
        } | Should Throw 
    }
    It "Requires a Scope" {
        {
            [RedditApplication]@{
                Name = 'TestApplication'
                Description = 'This is only a test'                
                RedirectUri = 'https://localhost/'
                UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Type = 'Script'
                ClientCredential = $ClientCredential
                UserCredential = $UserCredential
            }
        } | Should Throw 
    }
    It "Converts a [PSObject] to [$Class]" {
        {
            [RedditApplication][pscustomobject]@{
                Name = 'TestApplication'
                Description = 'This is only a test'
                RedirectUri = 'https://localhost/'
                UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope = 'read'
                ClientCredential = $ClientCredential
                UserCredential = $UserCredential
                Type = 'Script'
            }
        } | Should Not Throw
    }
}