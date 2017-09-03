<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    4/28/2017 04:40 AM
     Edited on:     09/03/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditApplication.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditApplication Class
#>

Describe "[RedditApplication] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $ClientCredential = Get-ClientCredential
        $UserCredential = Get-UserCredential
        $TestCases = @(
            @{
                Name = 'WebApp'
                Hash = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    Type             = 'WebApp'
                }
            }
            @{
                Name = 'Script'
                Hash = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    UserCredential   = Get-UserCredential
                    Type             = 'Script'
                }
            }
            @{
                Name = 'Installed'
                Hash = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    Type             = 'Installed'
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        {[RedditApplication]$Hash} | should not throw
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
                (Get-ClientCredential),
                (Get-UserCredential)
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
        $UserCredential
    )
    It "Has a working GetClientSecret() method" {
        $Application.GetClientSecret() | should be $ClientCredential.GetNetworkCredential().Password
    }
    It "Has a working GetClientSecret() method" {
        $Application.GetUserPassword() | should be $UserCredential.GetNetworkCredential().Password
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
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope            = 'read'
                ClientCredential = Get-ClientCredential
                UserCredential   = Get-UserCredential
            }
        } | Should Throw
    }
    It "Requires a ClientCredential" {
        {
            [RedditApplication]@{
                Name           = 'TestApplication'
                Description    = 'This is only a test'
                RedirectUri    = 'https://localhost/'
                UserAgent      = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope          = 'read'
                Type           = 'Script'
                UserCredential = Get-UserCredential
            }
        } | Should Throw
    }
    It "Requires a UserAgent" {
        {
            [RedditApplication]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                Scope            = 'read'
                Type             = 'Script'
                ClientCredential = Get-ClientCredential
                UserCredential   = Get-UserCredential
            }
        } | Should Throw
    }
    It "Requires a RedirectUri" {
        {
            [RedditApplication]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope            = 'read'
                Type             = 'Script'
                ClientCredential = Get-ClientCredential
                UserCredential   = Get-UserCredential
            }
        } | Should Throw
    }
    It "Requires a Scope" {
        {
            [RedditApplication]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Type             = 'Script'
                ClientCredential = Get-ClientCredential
                UserCredential   = Get-UserCredential
            }
        } | Should Throw
    }
    It "Converts a [PSObject] to [RedditApplication]" {
        {
            [RedditApplication][pscustomobject]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope            = 'read'
                ClientCredential = Get-ClientCredential
                UserCredential   = Get-UserCredential
                Type             = 'Script'
            }
        } | Should Not Throw
    }
    It "Converts a [Object] to [RedditApplication]" {
        $Hash = @{
            Name             = 'TestApplication'
            Description      = 'This is only a test'
            RedirectUri      = 'https://localhost/'
            UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope            = 'read'
            ClientCredential = Get-ClientCredential
            UserCredential   = Get-UserCredential
            Type             = 'Script'
        }
        $Object = [System.Object]::New()
        $Hash.GetEnumerator() | ForEach-Object {
            $LocalParams = @{
                MemberType = 'NoteProperty'
                Name       = $_.Name
                Value      = $_.Value
            }
            $Object | Add-Member @LocalParams
        }
        {
            [RedditApplication]$Object
        } | Should Not Throw
    }
    It "Throws when a Script Application is missing a UserCredential" {
        {
            [RedditApplication][pscustomobject]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope            = 'read'
                ClientCredential = Get-ClientCredential
                Type             = 'Script'
            }
        } | Should Throw "'UserCredential' required for 'Script' type"
    }
}