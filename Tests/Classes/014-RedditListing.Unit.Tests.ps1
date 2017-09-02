<#
    .NOTES

     Created with:  VSCode
     Created on:    6/02/2017 4:50 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     014-RedditListing.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditListing Class
#>
Describe "[RedditSubreddit] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TokenScript = Get-TokenScript
        $Uri = Get-WebListenerUrl -Test 'Submission/Nested'
        $Response = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Link = [RedditThing]$Response.ContentObject[0]
        $Comments = [RedditThing]$Response.ContentObject[1]
    }
    Context "RedditListing () Constructor" {
        It "Has a Default Constructor" {
            { [RedditListing]::New() } | Should Not Throw
        }
    }
    Context 'RedditListing ([RedditThing]$RedditThing)' {
        It "Throws when a RedditThing is not a Listing" {
            $Comment = [RedditThing]@{ Kind = 't1'}
            { [RedditListing]::New($Comment) } | Should Throw 'Unable to convert RedditThing of kind "t1" to "RedditListing"'
        }
        It "Converts a RedditThing to a RedditListing" {
            $Result = @{}
            { $Result['Object'] = [RedditListing]::New()}
        }
    }
    Context "Methods" {
        It "Has a GetComments() Method" {
            $Listing = [RedditListing]::New($Comments)
            $Result = @{}
            { $Result["Object"] = $Listing.GetComments() } | Should Not Throw
            $Result.Object.Count | Should Be 3
        }
        It "Has a GetMores() Method" {
            $Listing = [RedditListing]::New($Comments)
            $Result = @{}
            { $Result["Object"] = $Listing.GetMores() } | Should Not Throw
            $Result.Object.Count | Should Be 1
        }
        It "Has a GetLinks() Method" {
            $Listing = [RedditListing]::New($Link)
            $Result = @{}
            { $Result["Object"] = $Listing.GetLinks() } | Should Not Throw
            $Result.Object.Count | Should Be 1
        }
    }
}
