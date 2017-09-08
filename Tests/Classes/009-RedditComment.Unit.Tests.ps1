<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    6/02/2017 4:50 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     009-RedditComment.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditComment Class
#>
Describe "[RedditComment] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TokenScript = Get-TokenScript
        $Uri = Get-WebListenerUrl -Test 'Submission/Nested'
        $Submission = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        # Single comment with no replies
        $Comment1 = [RedditThing]$Submission.ContentObject[1].data.children[1]
        # Single comment with a complex reply hierarchy
        $Comment2 = [RedditThing]$Submission.ContentObject[1].data.children[0]
        # Single Comment with Single Reply
        $Comment3 = [RedditThing]$Submission.ContentObject[1].data.children[2]
        # Listing of single comment
        $Listing = [PSCustomObject]@{
            kind = 'Listing'
            data = [PSCustomObject]@{
                children = [object[]]@($Submission.ContentObject[1].data.children[1])
                after    = ''
                before   = ''
            }
        }
        $EmptyMore = [PSCustomObject]@{
            kind = 'more'
            data = [PSCustomObject]@{
                count = 0
            }
        }
        $More = [PSCustomObject]@{
            kind = 'more'
            data = [PSCustomObject]@{
                count    = 1
                children = @('12345')
            }
        }
        $MoreListing = [PSCustomObject]@{
            kind = 'Listing'
            data = [PSCustomObject]@{
                children = [object[]]@($More)
                after    = ''
                before   = ''
            }
        }
    }
    Context "RedditComment () constructor" {
        it "Has a default Constructor" {
            { [RedditComment]::New() } | Should Not Throw
        }
    }
    Context "RedditComment ([RedditThing]`$RedditThing) constructor" {
        It "Throws when a RedditThing is not a Comment" {
            $Listing = [RedditThing]@{ Kind = 'listing'}
            { [RedditComment]::New($Listing) } | Should Throw 'Unable to convert RedditThing of kind "listing" to "RedditComment"'
        }
        It "Converts a RedditThing to a RedditComment" {
            $Result = @{}
            { $Result['Object'] = [RedditComment]::New($Comment1) } | Should Not Throw
            $Result.Object.id | should be $Comment1.Data.Id
        }
        It "Automatically converts replies to RedditComments" {
            $Result = @{}
            { $Result['Object'] = [RedditComment]::New($Comment3) } | Should Not Throw
            $Result.Object.Replies.Count | Should Be 1
            $Result.Object.Replies[0].GetType().Name | Should Be 'RedditComment'
        }
        It "Converts a complex nested comment hierarchy" {
            { [RedditComment]::New($Comment2) } | Should Not Throw
        }
        It "Automatically adds properties the class does not contain" {
            $Comment = $Comment1.Psobject.Copy()
            $Params = @{
                MemberType = 'NoteProperty'
                Name       = 'NewProperty'
                Value      = 'TestValue'
            }
            $Comment.Data | Add-Member @Params
            $Result = @{}
            { $Result['Object'] = [RedditComment]::New($Comment) } | Should Not Throw
            $Result.Object.NewProperty | Should be 'TestValue'
        }
    }
    Context "Methods" {
        It "Has a GetApiEndpointUri() Method" {
            $Comment = [RedditComment]::New($Comment1)
            $result = 'https://oauth.reddit.com/api/info?id=t1_{0}' -f $Comment1.Data.id
            $Comment.GetApiEndpointUri() | Should Be $Result
        }
        It 'Has a GetFullName() method' {
            $Comment = [RedditComment]::New($Comment1)
            $Comment.GetFullName() | Should Be $Comment1.Data.name
        }
        It 'Has a ToString() method' {
            $Comment = [RedditComment]::New($Comment1)
            $Comment.ToString() | Should Be $Comment1.Data.body
        }
        It "Has a HasMoreReplies() method" {
            $Comment = [RedditComment]::New($Comment1)
            $Comment.HasMoreReplies() | Should Be $False
            $Comment.MoreObject = ([RedditThing]$EmptyMore).RedditData
            $Comment.HasMoreReplies() | Should Be $True
        }
    }
    context "_initReplies Method" {
        It "Does nothing when supplied an empty string" {
            $Comment = [RedditComment]::New($Comment1)
            $Count = $Comment.replies.Count
            { $Comment._initReplies('') } | Should Not Throw
            $Comment.replies.count | Should be $Count
        }
        It "Adds a listing of replies" {
            $Comment = [RedditComment]::New($Comment1)
            $Count = $Comment.replies.Count
            { $Comment._initReplies($Listing) } | Should Not Throw
            $Comment.replies.Count | Should BeGreaterThan $Count
        }
        It "Adds a listing of Mores" {
            $Comment = [RedditComment]::New($Comment1)
            $Count = $Comment.replies.Count
            { $Comment._initReplies($MoreListing) } | Should Not Throw
            $Comment.replies.Count | Should BeGreaterThan $Count
            $Comment.replies[0].id | Should Be $More.data.children[0]
        }
        It "Adds empty Mores" {
            $Comment = [RedditComment]::New($Comment1)
            { $Comment._initReplies($EmptyMore) } | Should Not Throw
            $Comment.HasMoreReplies() | Should Be $True
        }
        It "Adds Mores" {
            $Comment = [RedditComment]::New($Comment1)
            $Count = $Comment.replies.Count
            { $Comment._initReplies($More) } | Should Not Throw
            $Comment.replies.Count | Should BeGreaterThan $Count
            $Comment.replies[0].id | Should Be $More.data.children[0]
        }
        It "Sets the ParentObject of replies to the current instance" {
            $Comment = [RedditComment]::New($Comment1)
            $Comment._initReplies($Listing)
            $Comment.replies[0].ParentObject.Id | Should Be $Comment.Id
        }
    }
}
