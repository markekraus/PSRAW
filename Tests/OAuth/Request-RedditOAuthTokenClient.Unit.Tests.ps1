<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 8:50 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthTokenClient.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenClient Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope $moduleName {    
    $Command = 'Request-RedditOAuthTokenClient'
    $TypeName = 'Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject'
    
    $ClientId = '54321'
    $ClientSceret = '12345'
    $SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $InstalledId = '54321'
    $SecInstalledSecret = [System.Security.SecureString]::new()
    $InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

    $UserId = 'reddituser'
    $UserSceret = 'password'
    $SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)

    $ApplicationWebApp = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $ClientCredential
        Type             = 'WebApp'
    }

    $ApplicationScript = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $ClientCredential
        UserCredential   = $UserCredential
        Type             = 'Script'
    }

    $ApplicationInstalled = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $InstalledCredential
        Type             = 'Installed'
    }

    $ParameterSets = @(
        @{
            Name   = 'Script'
            Params = @{
                Application = $ApplicationScript
            }
        }
        @{
            Name   = 'WebApp'
            Params = @{
                Application = $ApplicationWebApp
            }
        }
    )


    Function MyTest {
        Mock -CommandName Invoke-WebRequest -ModuleName $moduleName -MockWith {
            $TempHtml = "{0}\{1}-empty.html" -f $env:TEMP, [guid]::NewGuid()
            '' | Set-Content $TempHtml
            $Request = [System.Net.WebRequest]::Create("file://$TempHtml")
            $Response = $Request.GetResponse()
            $Response.Headers['Content-Type'] = 'application/json'
            $Result = [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]::new($Response)
            Remove-Item -Force -Confirm:$false -Path $TempHtml -ErrorAction SilentlyContinue
            return $Result
        }
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
        It "Does not support 'Installed' apps" {
            $LocalParams = @{
                Application = $ApplicationInstalled
            }
            { & $Command @LocalParams -ErrorAction Stop } | Should throw "RedditApplicationType must be 'Script' or 'WebApp"
        }
    }
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