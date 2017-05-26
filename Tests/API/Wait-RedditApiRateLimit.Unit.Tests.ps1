<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/18/2017 06:19 PM
     Edited on:     5/18/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Wait-RedditApiRateLimit.Unit.Tests.ps1
    
    .DESCRIPTION
        Wait-RedditApiRateLimit Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope $moduleName {    
    $Command = 'Wait-RedditApiRateLimit'
    $TypeName = 'System.Void'

    Function MyTest {
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

        $RefreshId = 'refresh_token'
        $RefreshSecret = '76543'
        $SecRefreshSecret = $RefreshSecret | ConvertTo-SecureString -AsPlainText -Force 
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
            IssueDate          = (Get-Date).AddHours(-2)
            ExpireDate         = (Get-Date).AddHours(-1)
            LastApiCall        = Get-Date
            Scope              = $ApplicationScript.Scope
            GUID               = [guid]::NewGuid()
            TokenType          = 'bearer'
            GrantType          = 'Authorization_Code'
            RateLimitUsed      = 0
            RateLimitRemaining = 60
            RateLimitRest      = 60
            TokenCredential    = $TokenCredential.psobject.copy()
            RefreshCredential  = $RefreshCredential.psobject.copy()
        }

        $ParameterSets = @(
            @{
                Name   = 'Code'
                Params = @{
                    AccessToken = $TokenCode
                }
            }
            @{
                Name   = 'Sleep'
                Params = @{
                    AccessToken     = $TokenCode
                    MaxSleepSeconds = 300
                }
            }
        )
        foreach ($ParameterSet in $ParameterSets) {
            It "'$($ParameterSet.Name)' Parameter set does not have errors" {
                $LocalParams = $ParameterSet.Params
                { & $Command @LocalParams -ErrorAction Stop } | Should not throw
            }
        }
        It "Emits a $TypeName Object" {
            (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
        }
        It "Sleeps when the Token is Rate Limited" {
            $TokenCode.RateLimitRemaining = 0
            $TokenCode.RateLimitRest = 3
            Measure-Command {
                $TokenCode.LastApiCall = Get-Date
                $TokenCode | & $Command 
            } | Select-Object -ExpandProperty TotalSeconds | Should BeGreaterThan 2
        }
        It "Sleeps only until MaxSleepSeconds" {
            $TokenCode.RateLimitRemaining = 0
            $TokenCode.RateLimitRest = 5
            Measure-Command {
                $TokenCode.LastApiCall = Get-Date
                $TokenCode | & $Command -MaxSleepSeconds 3
            } | Select-Object -ExpandProperty TotalSeconds | Should BeLessThan 5
        }
        It "Supports WhatIf" {
            $TokenCode.RateLimitRemaining = 0
            $TokenCode.RateLimitRest = 5
            Measure-Command {
                $TokenCode.LastApiCall = Get-Date
                $TokenCode | & $Command -WhatIf
            } | Select-Object -ExpandProperty TotalSeconds | Should BeLessThan 1
        }
    }
    Describe "$command Unit" -Tags Unit {
        $CommandPresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
        if (-not $CommandPresent) {
            Write-Warning "'$command' was not found in '$moduleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
            return
        }
        MyTest
    }
    Describe "$command Build" -Tags Build {
        MyTest
    }
}