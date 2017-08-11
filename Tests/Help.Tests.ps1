<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    04/23/2017 12:06 PM
     Edited on:     05/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Help.Tests.ps1
    
    .DESCRIPTION
        Pester Test for proper help elements on module functions
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$ModuleHelpPath = "$projectRoot\docs\Module"
$PrivateFunctionHelpPath = "$projectRoot\docs\PrivateFunctions"
$BaseURL = 'https://psraw.readthedocs.io/en/latest'
$PrivateFunctionBaseURL = "$BaseURL/PrivateFunctions"
$ModuleBaseURL = "$BaseURL/Module"

. "$projectRoot\BuildTools\ModuleData-Helper.ps1"
. "$projectRoot\BuildTools\BuildDocs-Helper.ps1"


$DefaultParams = @(
    'Verbose'
    'Debug'
    'ErrorAction'
    'WarningAction'
    'InformationAction'
    'ErrorVariable'
    'WarningVariable'
    'InformationVariable'
    'OutVariable'
    'OutBuffer'
    'PipelineVariable'
)


Describe "Help tests for $moduleName" -Tags Documentation {
    $functions = Get-Command -Module $moduleName -CommandType Function
    foreach ($Function in $Functions) {
        $help = Get-Help $Function.name -Full -ErrorAction SilentlyContinue
        $helpText = $help | Out-String
        Context "$($Function.name) Public Function" {
            it "Has a Valid HelpUri" {
                $Function.HelpUri | Should Not BeNullOrEmpty
                $Pattern = [regex]::Escape("$ModuleBaseURL/$($Function.name)")
                $Function.HelpUri | should Match $Pattern
            }
            It "Has related Links" {
                $help.relatedLinks.navigationLink.uri.count | Should BeGreaterThan 0
            }
            it "Has a description" {
                $help.description | Should Not BeNullOrEmpty
            }
            it "Has an example" {
                $help.examples | Should Not BeNullOrEmpty
            }
            foreach ($parameter in $help.parameters.parameter) {
                if ($parameter -notmatch 'whatif|confirm') {
                    it "Has a Parameter description for '$($parameter.name)'" {
                        $parameter.Description.text -join '' | Should Not BeNullOrEmpty
                    }
                }
            }
            it "Does not have Template artifacts" {
                $Matches = $null
                $null = $helpText -match '{{.*}}'
                $Matches.count | should Be 0
            }
        }
    }# End foreach
    $PrivateFunctions = Get-ModulePrivateFunction -ModuleName $moduleName
    $PrivateHelpFiles = Get-ChildItem -Path $PrivateFunctionHelpPath -Filter '*.md' -ErrorAction SilentlyContinue
    foreach ($Function in $PrivateFunctions) {
        Context "$($Function.name) Private Function" {
            it "Has a HelpUri" {
                $Function.HelpUri | Should Not BeNullOrEmpty
                $Pattern = [regex]::Escape("$PrivateFunctionBaseURL/$($Function.name)")
                $Function.HelpUri | should Match $Pattern
            }
            $helpDoc = $PrivateHelpFiles | Where-Object { $_.BaseName -eq $Function.name}
            it "Has a help document" {
                $helpDoc | should not BeNullOrEmpty
            }

            it "Does not have Template artifacts" {
                $helpDoc.FullName | should not Contain '{{.*}}'
            }
            $Parameters = $Function.Parameters.Values.Name | Where-Object {$_ -notin $DefaultParams}
            foreach ($Parameter in $Parameters) {
                it "Has a Parameter description for '$parameter'" {
                    $helpDoc.FullName | Should Contain ([regex]::Escape("### -$Parameter"))
                }
            }         
        }
    }
    $PublicHelpFiles = Get-ChildItem -Path $ModuleHelpPath -Filter '*.md' -ErrorAction SilentlyContinue
    $ClassesAndEnums = Get-ModuleClass -ModuleName $moduleName
    $Classes = $ClassesAndEnums.where( {$_.IsClass})
    foreach ($Class in $Classes) {
        $helpDoc = $PublicHelpFiles | Where-Object { $_.BaseName -eq "about_$($Class.Name)"}
        $help = get-help "about_$($Class.Name)"  -ErrorAction SilentlyContinue | Where-Object {$_.name -eq "about_$($Class.Name)"}
        Context "$($Class.name) Class" {
            it "Has an about_ Topic" {
                $help | Should Not BeNullOrEmpty
            }
            it "Has a help document" {
                $helpDoc | should not BeNullOrEmpty
            }
            $Properties = $Class.DeclaredMembers.where( {$_.MemberType -eq 'Property'}).name
            foreach ($Property in $Properties) {
                It "Has '$Property' property documentation" {
                    $helpDoc.FullName | should Contain ([regex]::Escape("## $Property"))
                }
            }
            $Methods = $class.DeclaredMembers.where( {$_.MemberType -eq 'Method' -and -not $_.IsSpecialname}) |
                MethodHeading
            foreach ($Method in $Methods) {
                It "Has '$Method' method documentation" {
                    $helpDoc.FullName | should Contain ([regex]::Escape("## $Method"))
                }
            }
            $Constructors = $Class.GetConstructors() |  ConstructorHeading
            foreach ($Constructor in $Constructors) {
                it "Has Constructor '$Constructor'" {
                    $helpDoc.FullName | should Contain ([regex]::Escape("## $Constructor"))
                }                
            }
            it "Does not have Template artifacts" {
                $helpDoc.FullName | should not Contain '{{.*}}'
            }
        }
    }
    $Enums = $ClassesAndEnums.where( {$_.IsEnum})
    foreach ($Enum in $Enums) {
        $helpDoc = $PublicHelpFiles | Where-Object { $_.BaseName -eq "about_$($Enum.Name)"}
        $help = get-help "about_$($Enum.Name)" -ErrorAction SilentlyContinue | Where-Object {$_.name -eq "about_$($Enum.Name)"}
        Context "$($Enum.name) Enum" {
            it "Has an about_ Topic" {
                $help | Should Not BeNullOrEmpty
            }
            it "Has a help document" {
                $helpDoc | should not BeNullOrEmpty
            }
            $Fields = $Enum.GetFields().where( {-not $_.IsSpecialName}).name
            foreach ($Field in $Fields) {
                It "Has '$Field' field documentation" {
                    $helpDoc.FullName | should Contain ([regex]::Escape("## $Field"))
                }
            }
            it "Does not have Template artifacts" {
                $helpDoc.FullName | should not Contain '{{.*}}'
            }
        }
    }

}
