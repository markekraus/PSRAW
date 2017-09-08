<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with: 	VSCode
     Created on:   	4/23/2017 04:40 AM
     Edited on:     9/03/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	Get-RedditOAuthScope.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for Get-RedditOAuthScope
#>

Describe "Get-RedditOAuthScope" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        # Tricks Get-RedditOAuthScope into using WebListener
        $OriginalApiEndpointUri = [RedditOAuthScope]::ApiEndpointUri
        [RedditOAuthScope]::ApiEndpointUri = Get-WebListenerUrl -Test 'Scope'
    }
    AfterAll {
        [RedditOAuthScope]::ApiEndpointUri = $OriginalApiEndpointUri
    }
    It 'Does not have errors when passed required parameters' {
        { Get-RedditOAuthScope -ErrorAction Stop } | Should not throw
    }
    It "Emits a 'RedditOAuthScope' Object" {
        (Get-Command Get-RedditOAuthScope).OutputType.Name.where( { $_ -eq 'RedditOAuthScope' }) | Should be 'RedditOAuthScope'
    }
    It "Returns a 'RedditOAuthScope' Object" {
        $Object = Get-RedditOAuthScope | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq 'RedditOAuthScope' }) | Should be 'RedditOAuthScope'
    }
}
