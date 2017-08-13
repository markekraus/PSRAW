<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 11:50 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthTokenPassword.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenPassword Function unit tests
#>

$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Global:InvokeWebRequest = Get-Command 'Invoke-WebRequest'
<#
{
    "access_token": "71f213d6-5dc8-43df-b459-47fed22813dd", 
    "expires_in": 3600, 
    "scope": "*", 
    "token_type": "bearer"
}
#>
$Global:EchoUri = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%0A%20%20%20%20%22access_token%22%3A%20%2271f213d6-5dc8-43df-b459-47fed22813dd%22%2C%20%0A%20%20%20%20%22expires_in%22%3A%203600%2C%20%0A%20%20%20%20%22scope%22%3A%20%22*%22%2C%20%0A%20%20%20%20%22token_type%22%3A%20%22bearer%22%0A%7D'

InModuleScope $ModuleName {
    $Command = 'Request-RedditOAuthTokenPassword'
    $TypeName = 'RedditOAUthResponse'
    
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $InstalledId = '54321'
    $InstalledSecret = ''
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
    )


    Function MyTest {
        Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
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
            { & $Command @LocalParams -ErrorAction Stop } | Should throw "RedditApplicationType must be 'Script'"
        }
        It "Does not support 'WebApp' apps" {
            $LocalParams = @{
                Application = $ApplicationWebApp
            }
            { & $Command @LocalParams -ErrorAction Stop } | Should throw "RedditApplicationType must be 'Script'"
        }
    }
    Describe "$command Unit" -Tags Unit {
        $CommandPresent = Get-Command -Name $Command -Module $ModuleName -ErrorAction SilentlyContinue
        if (-not $CommandPresent) {
            Write-Warning "'$command' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
            return
        }
        MyTest
    }
    Describe "$command Build" -Tags Build {
        MyTest
    }
}