<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/28/2017 11:49 AM
     Edited on:     9/03/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	PSScriptAnalyzer.tests.Ps1

    .DESCRIPTION
        Runs PSScriptAnalyzer tests for every rule against every file in the module
#>
Describe "PSScriptAnalyzer Tests" -Tags Build {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $Params = @{
            Path          = $ModuleRoot
            Severity      = @('Error', 'Warning')
            Recurse       = $true
            Verbose       = $false
            ErrorVariable = 'ErrorVariable'
            ErrorAction   = 'SilentlyContinue'
        }
        $ScriptWarnings = Invoke-ScriptAnalyzer @Params
        $scripts = Get-ChildItem $ModuleRoot -Include *.ps1, *.psm1 -Recurse
    }
    foreach ($Script in $scripts) {
        $RelPath = $Script.FullName.Replace($ModuleRoot, '') -replace '^\\', ''
        Context "$RelPath" {
            $Rules = $ScriptWarnings |
                Where-Object {$_.ScriptPath -like $Script.FullName} |
                Select-Object -ExpandProperty RuleName -Unique
            foreach ($rule in $Rules) {
                It "Passes $rule" {
                    $BadLines = $ScriptWarnings |
                        Where-Object {$_.ScriptPath -like $Script.FullName -and $_.RuleName -like $rule} |
                        Select-Object -ExpandProperty Line
                    $BadLines | should be $null
                }
            }
            $Exceptions = $ErrorVariable.Exception.Message |
                Where-Object {$_ -match [regex]::Escape($Script.FullName)}
            foreach ($Exception in $Exceptions) {
                it 'Has no parse errors' {
                    $Exception | should be $null
                }
                break
            }
        }
    }
}
