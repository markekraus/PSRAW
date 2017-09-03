<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    9/02/2017 11:29 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     012-RedditSubreddit.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditSubreddit Class
#>
Describe "[RedditSubreddit] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TokenScript = Get-TokenScript
        $Uri = Get-WebListenerUrl -Test 'Subreddit'
        $Response = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Subreddit1 = [RedditThing]$Response.ContentObject.data.children[0]
        $Response = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Subreddit2 = [RedditThing]$Response.ContentObject.data.children[0]
    }
    Context 'RedditSubreddit () Constructor' {
        It "Has a default constructor" {
            { [RedditSubreddit]::New() } | Should Not Throw
        }
    }
    Context 'RedditSubreddit ([RedditThing]$RedditThing) Constructor' {
        It "Throws when a RedditThing is not a Subreddit" {
            $Comment = [RedditThing]@{ Kind = 't1'}
            { [RedditSubreddit]::New($Comment) } | Should Throw 'Unable to convert RedditThing of kind "t1" to "RedditSubreddit"'
        }
        It "Converts a RedditApiResponse to RedditSubreddit" {
            $Result = @{}
            { $Result['Object'] = [RedditSubreddit]::New($Subreddit1) } | Should Not Throw
            $Result.Object.id | should Be $Subreddit1.Data.id
        }
        It "Automatically adds properties the class does not contain" {
            $Params = @{
                MemberType = 'NoteProperty'
                Name       = 'NewProperty'
                Value      = 'TestValue'
            }
            $Subreddit2.Data | Add-Member @Params
            $Result = @{}
            { $Result['Object'] = [RedditSubreddit]::New($Subreddit2) } | Should Not Throw
            $Result.Object.NewProperty | Should be 'TestValue'
        }
    }
    Context "Methods" {
        It "Has a GetApiEndpointUri() method" {
            $Subreddit = [RedditSubreddit]::New($Subreddit1)
            $result = 'https://oauth.reddit.com/api/info?id=t5_{0}' -f $Subreddit1.data.id
            $Subreddit.GetApiEndpointUri() | Should Be $result
        }
        It "Has a GetFullName() method" {
            $Subreddit = [RedditSubreddit]::New($Subreddit1)
            $Subreddit.GetFullName() | Should Be $Subreddit1.data.name
        }
        It "Has a ToString() method" {
            $Subreddit = [RedditSubreddit]::New($Subreddit1)
            $Subreddit.ToString() | Should Match $Subreddit1.Data.url
            $Subreddit.ToString() | Should Match $Subreddit1.Data.title
        }
    }
}
