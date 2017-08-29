<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/20/2017 1:34 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Invoke-RedditRequest.Unit.Tests.ps1
    
    .DESCRIPTION
        Invoke-RedditRequest Function unit tests
#>

Describe "Invoke-RedditRequest" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        #region insanity
        # For whatever reason, pester chokes trying to mock Update-RedditOAuthToken
        # So, we remove it from the module and replace it with a script scope function
        # We later mock that function too because it wont work without the mock either
        $module = Get-Module $ModuleName
        & $module {
            Get-ChildItem function:\ | 
                Where-Object {$_.name -like 'Update-RedditOAuthToken'} | 
                Remove-Item -Force -Confirm:$false
            Get-ChildItem function:\ | 
                Where-Object {$_.name -like 'Update-RedditOAuthToken'} | 
                Remove-Item -Force -Confirm:$false
        }
        function Update-RedditOAuthToken {
            [CmdletBinding()]
            param (
                [Parameter(
                    ValueFromPipeline = $true
                )]
                [Object]
                $AccessToken
            )
            process {
                If ($AccessToken.Note -like 'badupdate') {
                    Write-Error 'Bad'
                }
            }
        }
        #endregion insanity
        
        $Uri = Get-WebListenerUrl -Test 'User'
        $UriBad = Get-WebListenerUrl -Test 'StatusCode' -Query @{StatusCode=404}
        $UriRaw = Get-WebListenerUrl -Test 'Echo' -Query @{StatusCode=200; 'Content-Type' = 'text/plain'; Body = 'Hello World'}
        $UriDefaultToken = Get-WebListenerUrl -Test 'Get'
    }
    
    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $ModuleName
        ParameterFilter = {$AccessToken.Notes -notlike 'badupdate'}
        MockWith        = { }
    }
    Mock @Params

    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $ModuleName
        ParameterFilter = {$AccessToken.Notes -like 'badupdate'}
        MockWith        = { Write-Error 'Bad' }
    }
    Mock @Params
    
    $Params = @{
        CommandName = 'Wait-RedditApiRateLimit'
        ModuleName  = $ModuleName 
    }
    Mock @Params -MockWith {   }
    $TestCases = @(
        @{
            Name   = 'Uri Only'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
            }
        }
        @{
            Name   = 'Get'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Method      = 'Get'
            }
        }
        @{
            Name   = 'Post Body'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Method      = 'Post'
                Body        = @{
                    Test = "Testy"
                } | ConvertTo-Json
            }
        }
        @{
            Name   = 'Headers'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Headers     = @{
                    'x-narwhals' = 'bacon'
                }
            }
        }
        @{
            Name   = 'Timeout'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                TimeoutSec  = '2'
            }
        }
    )
    It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
        param ($Name, $Params)
        { Invoke-RedditRequest @Params -ErrorAction Stop } | Should not throw
    }
    
    
    It "Emits a RedditApiResponse Object" {
        (Get-Command Invoke-RedditRequest).OutputType.Name.where( { $_ -eq 'RedditApiResponse' }) | Should be 'RedditApiResponse'
    }
    It "Returns a 'RedditApiResponse' Object" {
        $LocalParams = $TestCases[0].Params
        $Object = Invoke-RedditRequest @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq 'RedditApiResponse' }) | Should be 'RedditApiResponse'
    }
    It "Supports WhatIf" {
        {Invoke-RedditRequest -Uri $Uri -WhatIf -ErrorAction Stop } | should not throw
    }
    It "Has an irr alias" {
        $TokenScript = Get-TokenScript
        { irr -Uri $Uri -AccessToken $TokenScript -ErrorAction Stop } | should not throw
    }
    It "Uses the Default token when one is not supplied" {
        $TokenScript = Get-TokenScript
        Set-RedditDefaultOAuthToken -AccessToken $TokenScript 
        { Invoke-RedditRequest -Uri $UriDefaultToken } | Should Not Throw
    }
    It 'Handles Token Refresh errors gracefully' {
        $LocalParams = @{
            AccessToken = Get-TokenBad
            Uri         = $Uri
        }
        Try { Invoke-RedditRequest @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match 'Unable to refresh Access Token'
    }
    It "Handles Invoke-WebRequest errors gracefully" {
        $LocalParams = @{
            AccessToken = Get-TokenScript
            Uri         = $UriBad
        }
        Try { Invoke-RedditRequest @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match "Unable to query Uri"
    }
    It "Handles Handles non-JSON responses" {
        $LocalParams = @{
            AccessToken = Get-TokenScript
            Uri         = $UriRaw
        }
        { Invoke-RedditRequest @LocalParams -ErrorAction Stop } | Should not Throw
    }
}
