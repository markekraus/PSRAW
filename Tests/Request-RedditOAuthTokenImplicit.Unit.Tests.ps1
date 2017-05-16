<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 1:15 PM
     Edited on:     5/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthTokenImplicit.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenImplicit Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope $moduleName {
    $projectRoot = Resolve-Path "$PSScriptRoot\.."
    $moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
    $moduleName = Split-Path $moduleRoot -Leaf
    
    $Command = 'Request-RedditOAuthTokenImplicit'
    $TypeName = 'System.Uri'
    
    $ClientId = '54321'
    $ClientSceret = '12345'
    $SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId,$SecClientSecret)

    $InstalledId = '54321'
    $InstalledSceret = ''
    $SecInstalledSecret =  [System.Security.SecureString]::new()
    $InstalledCredential = [pscredential]::new($InstalledId,$SecInstalledSecret)

    $UserId = 'reddituser'
    $UserSceret = 'password'
    $SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId,$SecUserSecret)

    $ApplicationWebApp = [RedditApplication]@{
        Name = 'TestApplication'
        Description = 'This is only a test'
        RedirectUri = 'https://localhost/'
        UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope = 'read'
        ClientCredential = $ClientCredential
        Type = 'WebApp'
    }

    $ApplicationScript = [RedditApplication]@{
        Name = 'TestApplication'
        Description = 'This is only a test'
        RedirectUri = 'https://localhost/'
        UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope = 'read'
        ClientCredential = $ClientCredential
        UserCredential = $UserCredential
        Type = 'Script'
    }

    $ApplicationInstalled = [RedditApplication]@{
        Name = 'TestApplication'
        Description = 'This is only a test'
        RedirectUri = 'https://localhost/'
        UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope = 'read'
        ClientCredential = $InstalledCredential
        Type = 'Installed'
    }

    $ParameterSets = @(
        @{
            Name = 'Installed'
            Params = @{
                Application = $ApplicationInstalled
            }
        }
    )


    Function MyTest {
        Mock -ModuleName $moduleName -CommandName Show-RedditOAuthWindow {
            $State = ([System.Web.HttpUtility]::ParseQueryString($uri.Query))['State']
            $Scope = ([System.Web.HttpUtility]::ParseQueryString($uri.Query))['Scope']
            return [system.uri](
                '{0}#access_token=34567&token_type=bearer&state={1}&expires_in=3600&scope={2}' -f (
                    $RedirectUri, 
                    $State,
                    $Scope -replace ',', '+'
                )
            )
        }
        foreach($ParameterSet in $ParameterSets){
            It "'$($ParameterSet.Name)' Parameter set does not have errors" {
                $LocalParams = $ParameterSet.Params
                { & $Command @LocalParams -ErrorAction Stop } | Should not throw
            }
        }
        It "Emits a $TypeName Object" {
            (Get-Command $Command).OutputType.Name.where({ $_ -eq $TypeName }) | Should be $TypeName
        }
        It "Returns a $TypeName Object" {
            $LocalParams = $ParameterSets[0].Params.psobject.Copy()
            $Object = & $Command @LocalParams | Select-Object -First 1
            $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
        }
        It "Does not support 'Script' apps" {
            $LocalParams = @{
                Application = $ApplicationScript
            }
            { & $Command @LocalParams -ErrorAction Stop } | Should throw "RedditApplicationType must be 'Installed'"
        }
        It "Does not support 'webApp' apps" {
            $LocalParams = @{
                Application = $ApplicationWebApp
            }
            { & $Command @LocalParams -ErrorAction Stop } | Should throw "RedditApplicationType must be 'Installed'"
        }
    }
    Describe "$command Unit" -Tags Unit {
        $commandpresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
        if(-not $commandpresent){
            Write-Warning "'$command' was not found in '$moduleName' during prebuild tests. It may not yet have been added the module. Unit tests will be skipped until after build."
            return
        }
        MyTest
    }
    Describe "$command Build" -Tags Build {
        MyTest
    }
}