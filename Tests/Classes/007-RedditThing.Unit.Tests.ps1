<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/29/2017 9:26 PM
     Edited on:     6/02/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditThing.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditThing Class
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditThing'

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

$TestHashes = @(
    @{
        Name = 'TestHash'
        Hash = @{
            AccessToken = $TokenScript
            Kind        = 't1'
            Data        = [pscustomobject]@{
                test = 'test'
            }
            Name        = 'test'
            Id          = 'test'
            Parent      = [pscustomobject]@{
                test = 'test'
            }
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            { 
                $TestCommand = '[{0}]$TestHash.Hash' -f $Class
                Invoke-Expression $TestCommand
            } | should not throw
        }
    }
    It "Has a working default constructor" {
        {
            $TestCommand = '[{0}]::new()' -f $Class
            Invoke-Expression $TestCommand
        } | Should not throw
        
    }
}