<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/07/2017 8:30 PM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Get-AuthorizationHeader.Unit.Tests.ps1

    .DESCRIPTION
        Get-AuthorizationHeader Function unit tests
#>
Describe "Get-AuthorizationHeader" -Tag Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    InModuleScope $ModuleName {
        It 'Returns an rfc2617 Authorization header' {
            Get-AuthorizationHeader -Credential (Get-ClientCredential) |
                Should Be 'Basic NTQzMjE6MDgyMzk4NDItYTZmNS00ZmU1LWFiNGMtNDU5MjA4NGFkNDRl'
        }
    }
}
