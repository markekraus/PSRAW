<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/28/2017 04:40 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditApplication.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditApplication Class
#>

$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditApplication'

$ClientId = '54321'
$ClientSecret = '12345'
$SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

$UserId = 'reddituser'
$UserSecret = 'password'
$SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId, $SecUserSecret)

$TestHashes = @(
    @{
        Name = 'WebApp'
        Hash = @{
            Name             = 'TestApplication'
            Description      = 'This is only a test'
            RedirectUri      = 'https://localhost/'
            UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope            = 'read'
            ClientCredential = $ClientCredential
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
            ClientCredential = $ClientCredential
            UserCredential   = $UserCredential
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
            ClientCredential = $ClientCredential
            Type             = 'Installed'
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
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
        $Application.GetClientSecret() | should be $ClientSecret
    }
    It "Has a working GetClientSecret() method" {
        $Application.GetUserPassword() | should be $UserSecret
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
                ClientCredential = $ClientCredential
                UserCredential   = $UserCredential
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
                UserCredential = $UserCredential
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
                ClientCredential = $ClientCredential
                UserCredential   = $UserCredential
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
                ClientCredential = $ClientCredential
                UserCredential   = $UserCredential
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
                ClientCredential = $ClientCredential
                UserCredential   = $UserCredential
            }
        } | Should Throw 
    }
    It "Converts a [PSObject] to [$Class]" {
        {
            [RedditApplication][pscustomobject]@{
                Name             = 'TestApplication'
                Description      = 'This is only a test'
                RedirectUri      = 'https://localhost/'
                UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                Scope            = 'read'
                ClientCredential = $ClientCredential
                UserCredential   = $UserCredential
                Type             = 'Script'
            }
        } | Should Not Throw
    }
    It "Converts a [Object] to [$Class]" {
        $Hash = @{
            Name             = 'TestApplication'
            Description      = 'This is only a test'
            RedirectUri      = 'https://localhost/'
            UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope            = 'read'
            ClientCredential = $ClientCredential
            UserCredential   = $UserCredential
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
                ClientCredential = $ClientCredential
                Type             = 'Script'
            }
        } | Should Throw "'UserCredential' required for 'Script' type"
    }
}