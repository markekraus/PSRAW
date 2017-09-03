<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/29/2017 9:26 PM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditThing.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditThing Class
#>

Describe "[RedditThing] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath

        $Uri = Get-WebListenerUrl -Test 'Submission'
        $TokenScript = Get-TokenScript
        $Response = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Comment = $Response.ContentObject[1].data.children[0]

        $TestCases = @(
            @{
                Name = 'TestHash'
                Hash = @{
                    Kind         = 't1'
                    Name         = 'test'
                    Id           = 'test'
                    Data         = [pscustomobject]@{ test = 'test' }
                    ParentObject = [pscustomobject]@{ test = 'test' }
                    RedditData   = [RedditComment]::New()
                }
            }
        )
    }
    It "Converts the '<Name>' hash" -TestCases $TestCases {
        param($Name, $Hash)
        { [RedditThing]$Hash } | should not throw
    }
    It "Has a working default constructor" {
        { [RedditThing]::New() } | Should not throw
    }
    It "Has a working ([PSObject]`$Object) Constructor" {
        {[RedditThing]::new($Comment)} | Should Not Throw
    }
    It "CreateFrom() converts a [RedditApiResponse] to [RedditThing[]]" {
        {[RedditThing]::CreateFrom($Response)} | Should Not Throw
    }
}
