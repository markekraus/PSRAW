<#
    .NOTES

     Created with:  VSCode
     Created on:    9/02/2017 11:29 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     013-RedditMore.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditMore Class
#>
Describe "[RedditMore] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    BeforeEach {
        $More = [redditthing][PSCustomObject]@{
            kind = 'more'
            data = [PSCustomObject]@{
                count    = 2
                children = [object[]]@('12345', 'abcde')
                name     = 't1_54321'
                id       = '54321'
            }
        }
    }
    Context "RedditMore () Constructor" {
        It "Has a default constructor" {
            { [RedditMore]::New() } | Should Not Throw
        }
    }
    Context "RedditMore ([RedditThing]`$RedditThing) Constructor" {
        It "Throws if the ReditThing is not a More" {
            $Comment = [RedditThing]@{
                Kind = 't1'
            }
            { [RedditMore]::New($Comment) } | Should Throw 'Unable to convert RedditThing of kind "t1" to "RedditMore"'
        }
        it "Converts a RedditThing to a RedditMore" {
            $Result = @{}
            { $Result['Object'] = [RedditMore]::New($More) } | Should Not Throw
            $Result.Object.Count | Should be $More.data.count
            $Result.Object.id | Should be $More.data.id
            $Result.Object.children[0] | Should be $More.data.children[0]
        }
    }
}
