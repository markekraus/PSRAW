<#
    .NOTES

     Created with:  VSCode
     Created on:    9/02/2017 8:42 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     009-RedditLink.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditLink Class
#>
Describe "[RedditLink] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TokenScript = Get-TokenScript
        $Uri = Get-WebListenerUrl -Test 'Submission'
        $Submission = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Submission2 = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Link1 = [RedditThing]$Submission.ContentObject[0].data.children[0]
        $Link2 = [RedditThing]$Submission2.ContentObject[0].data.children[0]
    }
    Context "RedditLink ([RedditThing]`$RedditThing) Constructor" {
        It "Converts a RedditThing to a RedditLink" {
            $Result = @{}
            { $Result['Object'] = [RedditLink]::New($Link1) } | Should Not Throw
            $Result.Object.id | should be $Link1.Data.Id
        }
        It "Automatically adds properties the class does not contain" {
            $Params = @{
                MemberType = 'NoteProperty'
                Name       = 'NewProperty'
                Value      = 'TestValue'
            }
            $Link2.Data | Add-Member @Params
            $Result = @{}
            { $Result['Object'] = [RedditLink]::New($Link2) } | Should Not Throw
            $Result.Object.NewProperty | Should be 'TestValue'
        }
    }
    Context "Methods" {
        It "Has a GetApiEndpointUri() Method" {
            $Link = [RedditLink]::New($Link1)
            $result = 'https://oauth.reddit.com/api/info?id=t3_{0}' -f $Link1.Data.id
            $Link.GetApiEndpointUri() | Should Be $Result
        }
        It 'Has a GetFullName() method' {
            $Link = [RedditLink]::New($Link1)
            $Link.GetFullName() | Should Be $Link1.Data.name
        }
        It 'Has a ToString() method' {
            $Link = [RedditLink]::New($Link1)
            $Link.ToString() | Should Match $Link1.Data.Title
            $Link.ToString() | Should Match $Link1.Data.subreddit_name_prefixed
            $Link.ToString() | Should Match $Link1.Data.author
        }
    }

}
