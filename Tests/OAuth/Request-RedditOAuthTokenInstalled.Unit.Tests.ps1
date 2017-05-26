<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 12:45 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthTokenInstalled.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenInstalled Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope $moduleName {
    $Command = 'Request-RedditOAuthTokenInstalled'
    $TypeName = 'Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject'
    
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
            Name   = 'Script with DeviceID'
            Params = @{
                Application = $ApplicationScript
                DeviceID    = 'MyDeviceID'
            }
        }
        @{
            Name   = 'WebApp'
            Params = @{
                Application = $ApplicationWebApp
            }
        }
        @{
            Name   = 'WebApp with DeviceID'
            Params = @{
                Application = $ApplicationWebApp
                DeviceID    = 'MyDeviceID'
            }
        }
        @{
            Name   = 'Installed'
            Params = @{
                Application = $ApplicationInstalled
            }
        }
        @{
            Name   = 'Installed with DeviceID'
            Params = @{
                Application = $ApplicationInstalled
                DeviceID    = 'MyDeviceID'
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