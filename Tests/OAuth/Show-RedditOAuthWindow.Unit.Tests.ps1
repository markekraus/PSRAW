<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/04/2017 03:45 PM
     Edited on:     5/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Show-RedditOAuthWindow.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for Show-RedditOAuthWindow  Function
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force


InModuleScope PSRAW {
    $Command = 'Show-RedditOAuthWindow'
    $TypeName = 'System.Uri'

    function MyTest {
        It "Emits a $TypeName Object" {
            (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
        }
    }

    "'$command' is a GUI function. Limited testing available"
    Describe "$command Unit" -Tags Unit {
        $commandpresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
        if (-not $commandpresent) {
            Write-Warning "'$command' was not found in '$moduleName' during prebuild tests. It may not yet have been added the module. Unit tests will be skipped until after build."
            return
        }
        MyTest
    }


    Describe "$command Build" -Tags Build {
        MyTest
    }
}
