<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    9/02/2017 9:25 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     011-RedditSubmission.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditSubmission Class
#>
Describe "[RedditSubmission] Build Tests" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TokenScript = Get-TokenScript
        $Uri = Get-WebListenerUrl -Test 'Submission/Nested'
        $Submission1 = Invoke-RedditRequest -Uri $Uri -AccessToken $TokenScript
        $Link1 = $Submission1.ContentObject[0].data.children[0].data
        $Comment1 = $Submission1.ContentObject[1].data.children[0].data
        $Comment2 = $Submission1.ContentObject[1].data.children[1].data
        $Comment3 = $Submission1.ContentObject[1].data.children[2].data
    }
    It "Has a default constructor" {
        { [RedditSubmission]::New() } | Should Not Throw
    }
    It "Converts a RedditApiResponse to RedditSubmission" {
        $Result = @{}
        { $Result['Object'] = [RedditSubmission]::New($Submission1) } | Should Not Throw
        $Result.Object.link.id | should Be $Link1.id
        $Result.Object.Comments.Count | Should Be 7
        $Result.Object.Comments[0].Id | Should Be $Comment1.Id
        $Result.Object.Comments[1].Id | Should Be $Comment2.Id
        $Result.Object.Comments[2].Id | Should Be $Comment3.Id
    }
}
