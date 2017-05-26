<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 8:30 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Get-AuthorizationHeader.Unit.Tests.ps1
    
    .DESCRIPTION
        Get-AuthorizationHeader Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope $moduleName {
    $Command = 'Get-AuthorizationHeader'
    $TypeName = 'System.String'
    
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)
    $Expected = 'Basic NTQzMjE6MTIzNDU='

    $ParameterSets = @(
        @{
            Name   = 'Credential'
            Params = @{
                Credential = $ClientCredential
            }
        }
    )


    Function MyTest {
        foreach ($ParameterSet in $ParameterSets) {
            It "'$($ParameterSet.Name)' Parameter set does not have errors" {
                $LocalParams = $ParameterSet.Params
                { & $Command @LocalParams -ErrorAction Stop } | Should not throw
            }
        }
        It "Emits a $TypeName Object" {
            (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
        }
        It "Returns a $TypeName Object" {
            $LocalParams = $ParameterSets[0].Params.psobject.Copy()
            $Object = & $Command @LocalParams | Select-Object -First 1
            $Object.psobject.typenames.where( { $_ -eq $TypeName }) | Should be $TypeName
        }
        It 'Returns an rfc2617 Authorization header' {
            $LocalParams = $ParameterSets[0].Params
            & $Command @LocalParams | Should Be 'Basic NTQzMjE6MTIzNDU='
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