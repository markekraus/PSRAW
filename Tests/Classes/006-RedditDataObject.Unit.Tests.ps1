<#
    .NOTES

     Created with:  VSCode
     Created on:    8/30/2017 3:54 AM
     Edited on:     8/30/2017
     Created by:    Mark Kraus
     Organization:
     Filename:     RedditDataObject.Unit.Tests.ps1

    .DESCRIPTION
        Unit Tests for RedditDataObject Class
#>

Describe "[RedditDataObject] Tests" -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    It "Has a working default constructor" {
        {[RedditDataObject]::new()} | Should not throw
    }
}
