<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    8/12/2017 8:16 AM
     Edited on:     8/12/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Set-RedditDefaultOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
       Set-RedditDefaultOAuthToken Function unit tests
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$Global:moduleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force
$Global:Module = Get-Module $ModuleName

$Global:Command = 'Set-RedditDefaultOAuthToken'

Function MyTest {
    
    $Command = $Global:Command
    $ModuleName = $Global:moduleName
    $Module = $Global:Module 

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
    $TokenPassword = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
    }

    It "Runs without error" {
        { $TokenPassword | Set-RedditDefaultOAuthToken } | Should Not Throw
    }
    It "Sets the default token" {
        $TokenPassword | Set-RedditDefaultOAuthToken 
        $Result = Get-RedditDefaultOAuthToken
        $Result.GUID | Should Be $TokenPassword.GUID
    }
    It "Supports what if" {
        { $TokenPassword | Set-RedditDefaultOAuthToken -WhatIf }  | Should Not Throw
    }
}
Describe "$Command Unit" -Tags Unit {
    $CommandPresent = Get-Command -Name $Command -Module $ModuleName -ErrorAction SilentlyContinue
    if (-not $CommandPresent) {
        Write-Warning "'$command' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "$command Build" -Tags Build {
    MyTest
}