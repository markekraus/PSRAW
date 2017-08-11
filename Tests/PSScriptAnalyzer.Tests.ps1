<#	
    .NOTES
    
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.135
     Created on:   	2/28/2017 11:49 AM
     Edited on:     6/05/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	PSScriptAnalyzer.tests.Ps1
    
    .DESCRIPTION
        Runs PSScriptAnalyzer tests for every rule against every file in the module
#>
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

Describe "PSScriptAnalyzer Tests" -Tags Build {
    $Params = @{
        Path          = "$moduleRoot" 
        Severity      = @('Error', 'Warning') 
        Recurse       = $true
        Verbose       = $false 
        ErrorVariable = 'ErrorVariable' 
        ErrorAction   = 'SilentlyContinue'
    }
    $ScriptWarnings = Invoke-ScriptAnalyzer @Params
    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1 -Recurse
    foreach ($Script in $scripts) {
        $RelPath = $Script.FullName.Replace($moduleRoot, '') -replace '^\\', ''
        Context "$RelPath" {
            $Rules = $ScriptWarnings | Where-Object {$_.ScriptPath -like $Script.FullName} | Select-Object -ExpandProperty RuleName -Unique
            foreach ($rule in $Rules) {
                It "Passes $rule" {
                    $BadLines = $ScriptWarnings | Where-Object {$_.ScriptPath -like $Script.FullName -and $_.RuleName -like $rule} | Select-Object -ExpandProperty Line 
                    $BadLines | should be $null
                }
            }
            $Exceptions = $ErrorVariable.Exception.Message | Where-Object {$_ -match [regex]::Escape($Script.FullName)}
            foreach ($Exception in $Exceptions) {
                it 'Has no parse errors' {
                    $Exception | should be $null
                }
                break
            }            
        }
    }
}