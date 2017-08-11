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

$Global:InvokeWebRequest = Get-Command 'Invoke-WebRequest'
<#
{
    "access_token": "c17a386d-9768-4f1d-a290-b357663de722",
    "token_type": "bearer",
    "expires_in": 900,
    "scope": "read",
}
#>
$Global:EchoUri = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%0A%20%20%20%20%22access_token%22%3A%20%22c17a386d-9768-4f1d-a290-b357663de722%22%2C%0A%20%20%20%20%22token_type%22%3A%20%22bearer%22%2C%0A%20%20%20%20%22expires_in%22%3A%20900%2C%0A%20%20%20%20%22scope%22%3A%20%22read%22%2C%0A%7D'

InModuleScope $moduleName {    
    $Command = 'Request-RedditOAuthTokenClient'
    $TypeName = 'RedditOAuthResponse'
    
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $InstalledId = '54321'
    $SecInstalledSecret = [System.Security.SecureString]::new()
    $InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

    $UserId = 'reddituser'
    $UserSecret = 'password'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
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
            $Result = & $Global:InvokeWebRequest -UseBasicParsing -Uri $Global:EchoUri 
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