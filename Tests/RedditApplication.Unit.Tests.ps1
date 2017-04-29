<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    4/28/2017 04:40 AM
     Edited on:     4/29/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditApplication.Unit.Tests.ps1
    ===========================================================================
    .DESCRIPTION
        Unit Tests for RedditApplication Class
#>
Using module '..\PSRAW\Classes\RedditApplication.psm1'

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