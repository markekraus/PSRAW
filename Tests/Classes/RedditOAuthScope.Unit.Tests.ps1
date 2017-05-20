<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/30/2017 10:15 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditOAuthScope.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditOAuthScope Class
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Class = 'RedditOAuthScope'


$TestHashes = @(
    @{
        Name = 'read'
        Hash = @{
            Scope       = 'creddits'
            Id          = 'creddits'
            Name        = 'Spend reddit gold creddits'
            Description = 'Spend my reddit gold creddits on giving gold to other users.'
        }
    }
)


Describe "[$Class] Tests" -Tag Unit, Build {
    foreach ($TestHash in $TestHashes) {
        It "Converts the '$($TestHash.Name)' hash" {
            {[RedditOAuthScope]$TestHash.Hash} | should not throw
        }
    }
    It "Has a working Uber Constructor." {
        {
            [RedditOAuthScope]::new(
                <#Scope       #> 'creddits',
                <#Id          #> 'creddits',
                <#Name        #> 'Spend reddit gold creddits',
                <#Description #> 'Spend my reddit gold creddits on giving gold to other users.'
            )
        } | should not throw
    }
    It "Has a working GetApiEndpointUri() static method" {
        [RedditOAuthScope]::GetApiEndpointUri() | should be 'https://www.reddit.com/api/v1/scopes'
    }
    It "Has a working ApiEndpointUri static property" {
        [RedditOAuthScope]::ApiEndpointUri | should be 'https://www.reddit.com/api/v1/scopes'
    }
    It "Has a working default constructor" {
        {[RedditOAuthScope]::new()} | Should not throw
        $EmptyScope = [RedditOAuthScope]::new()
        $EmptyScope.Id | should be ''
        $EmptyScope.Description | Should be ''
        $EmptyScope.Scope | should be ''
        $EmptyScope.Name | should be ''
    }
    It "Converts a [String] to a [$Class]" {
        {[RedditOAuthScope]'read'} | should not throw
        $ReadScope = [RedditOAuthScope]'read'
        $ReadScope.Id | should be 'read'
        $ReadScope.Description | Should be 'read'
        $ReadScope.Scope | should be 'read'
        $ReadScope.Name | should be 'read'
    }
}