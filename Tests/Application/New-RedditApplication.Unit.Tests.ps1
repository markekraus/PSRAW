<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/26/2017 04:40 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      New-RedditApplication.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for New-RedditApplication
#>
Describe "New-RedditApplication Build" -Tags Build,Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        $TestCases = @(
            @{
                Name   = 'WebApp'
                Params = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    WebApp           = $True
                }
            }
            @{
                Name   = 'Script'
                Params = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    UserCredential   = Get-UserCredential
                    Script           = $True
                }
            }
            @{
                Name   = 'Installed'
                Params = @{
                    Name             = 'TestApplication'
                    Description      = 'This is only a test'
                    RedirectUri      = 'https://localhost/'
                    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
                    Scope            = 'read'
                    ClientCredential = Get-ClientCredential
                    Installed        = $True
                }
            }
        )
    }
    It "'<Name>' Parameter set does not have errors" -TestCases $TestCases {
        param($Name,$Params)
        { New-RedditApplication @Params -ErrorAction Stop } | Should not throw
    }
    It "Emits a 'RedditApplication' Object" {
        (Get-Command New-RedditApplication).OutputType.Name.where( { $_ -eq 'RedditApplication' }) | Should be 'RedditApplication'
    }
    It "Returns a 'RedditApplication' Object" {
        $LocalParams = $TestCases[0].Params.psobject.Copy()
        $Object = New-RedditApplication @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq 'RedditApplication' }) | Should be 'RedditApplication'
    }
}
