<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    8/01/2017 3:37 PM
     Edited on:     8/01/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Get-HttpResponseContentType.Tests.ps1
    
    .DESCRIPTION
         Get-HttpResponseContentType Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Global:Command = 'Get-HttpResponseContentType'

InModuleScope $moduleName {
    $Command = $Global:Command
    $ModuleName = $Global:ModuleName
    Function MyTest {
        $Uri = 'http://httpbin.org/headers'
        $Response = Invoke-WebRequest -Uri $Uri
        It 'Returns a valid content-type string for a provided WebResponse' {
            $Response | Get-HttpResponseContentType |
                Should Match 'application/json'
        }
    }
    Describe "$command Unit" -Tags Unit {
        $CommandPresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
        if (-not $CommandPresent) {
            Write-Warning "'$command' was not found in '$moduleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
            return
        }
        MyTest
    }
    Describe "$command Build" -Tags Build {
        MyTest
    }
}