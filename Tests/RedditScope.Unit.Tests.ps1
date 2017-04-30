<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    4/30/2017 10:15 AM
     Edited on:     4/30/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditScope.Unit.Tests.ps1
    ===========================================================================
    .DESCRIPTION
        Unit Tests for RedditScope Class
#>
Using module '..\PSRAW\Classes\RedditScope.psm1'

$Class = 'RedditScope'


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
    foreach($TestHash in $TestHashes){
        It "Converts the '$($TestHash.Name)' hash"{
            {[RedditScope]$TestHash.Hash} | should not throw
        }
    }
     It "Has a working Uber Constructor." {
        {
            [RedditScope]::new(
                <#Scope       #> 'creddits',
                <#Id          #> 'creddits',
                <#Name        #> 'Spend reddit gold creddits',
                <#Description #> 'Spend my reddit gold creddits on giving gold to other users.'
            )
        } | should not throw
    }
    It "Has a working GetApiEndpointUri() static method" {
        [RedditScope]::GetApiEndpointUri() | should be 'https://www.reddit.com/api/v1/scopes'
    }
    It "Has a working ApiEndpointUri static property" {
        [RedditScope]::ApiEndpointUri | should be 'https://www.reddit.com/api/v1/scopes'
    }
    It "Has a working default constructor" {
        {[RedditScope]::new()} | Should not throw
        $EmptyScope = [RedditScope]::new()
        $EmptyScope.Id | should be ''
        $EmptyScope.Description | Should be ''
        $EmptyScope.Scope | should be ''
        $EmptyScope.Name | should be ''
    }
    It "Converts a [String] to a [$Class]" {
        {[RedditScope]'read'} | should not throw
        $ReadScope = [RedditScope]'read'
        $ReadScope.Id | should be 'read'
        $ReadScope.Description | Should be 'read'
        $ReadScope.Scope | should be 'read'
        $ReadScope.Name | should be 'read'
    }
}