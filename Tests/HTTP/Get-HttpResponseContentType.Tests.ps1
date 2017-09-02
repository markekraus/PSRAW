<#
    .NOTES

     Created with:  VSCode
     Created on:    8/01/2017 3:37 PM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:      Get-HttpResponseContentType.Tests.ps1

    .DESCRIPTION
         Get-HttpResponseContentType Function unit tests
#>

Describe 'Get-HttpResponseContentType' -Tag Unit, Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
    }
    InModuleScope $ModuleName {
        It 'Returns a valid content-type string for a provided WebResponse' {
            $uri = Get-WebListenerUrl -Test 'Get'
            $Response = Invoke-WebRequest -Uri $uri
            $Response | Get-HttpResponseContentType |
                Should Match 'application/json'
        }
    }
}
