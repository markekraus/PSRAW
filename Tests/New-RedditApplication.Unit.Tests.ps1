<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    4/26/2017 04:40 AM
     Edited on:     4/28/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      New-RedditApplication.Unit.Tests.ps1
    ===========================================================================
    .DESCRIPTION
        Unit Tests for New-RedditApplication
#>

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'New-RedditApplication'
$TypeName = 'RedditApplication'
$RequiredParams = @(
    'ClientCredential'
    'UserCredential'
    'ReditectUri'
    'UserAgent'
    'Scope'
)

$ClientId = '54321'
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId,$SecClientSecret)

$UserId = 'reddituser'
$UserSceret = 'password'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId,$SecUserSecret)

$ParamterSets = @(
    @{
        Name = 'WebApp'
        Params =@{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            WebApp = $True
        }
    }
    @{
        Name = 'Script'
        Params =@{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
            Script = $True
        }
    }
    @{
        Name = 'Installed'
        Params =@{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            Installed = $True
        }
    }
)


function MyTest {
    foreach($ParamterSet in $ParamterSets){

        It "'$($ParamterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParamterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    It "Emits a $TypeName Object" {
        (Get-Command $Command).OutputType.Name.where({ $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns a $TypeName Object" {
        $LocalParams = $ParamterSets[0].Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where({ $_ -eq $TypeName }) | Should be $TypeName
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
