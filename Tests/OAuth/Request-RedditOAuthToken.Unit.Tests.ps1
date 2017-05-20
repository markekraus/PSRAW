<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 8:50 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthToken Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force -Scope Global

$Command = 'Request-RedditOAuthToken'
$TypeName = 'RedditOAuthToken'

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
        Name   = 'Code/Script'
        Params = @{
            Application = $ApplicationScript
            Code        = $True
        }
    }
    @{
        Name   = 'Code/Script/State'
        Params = @{
            Application = $ApplicationScript
            Code        = $True
            State       = 'MyState'
        }
    }
    @{
        Name   = 'Code/WebApp'
        Params = @{
            Application = $ApplicationWebApp
            Code        = $True
        }
    }
    @{
        Name   = 'Code/WebApp/State'
        Params = @{
            Application = $ApplicationWebApp
            Code        = $True
            State       = 'MyState'
        }
    }
    @{
        Name   = 'Script/Script'
        Params = @{
            Application = $ApplicationScript
            Script      = $True
        }
    }
    @{
        Name   = 'Client/Script'
        Params = @{
            Application = $ApplicationScript
            Client      = $True
        }
    }
    @{
        Name   = 'Client/WebApp'
        Params = @{
            Application = $ApplicationWebApp
            Client      = $True
        }
    }
    @{
        Name   = 'Installed/Installed'
        Params = @{
            Application = $ApplicationInstalled
            Installed   = $True
        }
    }
    @{
        Name   = 'Installed/Installed/DeviceID'
        Params = @{
            Application = $ApplicationInstalled
            Installed   = $True
            DeviceID    = 'MyDeviceID'
        }
    }
    @{
        Name   = 'Implicit/Installed'
        Params = @{
            Application = $ApplicationInstalled
            Implicit    = $True
        }
    }
    @{
        Name   = 'Implicit/Installed/State'
        Params = @{
            Application = $ApplicationInstalled
            Implicit    = $True
            State       = 'MyState'
        }
    }
)
Function MyTest {
    Mock -CommandName Request-RedditOAuthTokenInstalled -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "34567", "token_type": "bearer", "device_id": "MyDeviceID", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenCode -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "refresh_token": "76543", "scope": "read"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenPassword -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenClient -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenImplicit -ModuleName $moduleName -MockWith {
        $Result = [System.Uri]('{0}#access_token=34567&token_type=bearer&state={1}&expires_in=3600&scope=read' -f $Application.RedirectUri, $State)
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
