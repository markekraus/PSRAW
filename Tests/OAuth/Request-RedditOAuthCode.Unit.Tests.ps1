<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/04/2017 03:45 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Request-RedditOAuthCode.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for Request-RedditOAuthCode  Function
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

InModuleScope PSRAW {
    $Command = 'Request-RedditOAuthCode'
    $TypeName = 'RedditOAuthCode'
    
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)
    
    $UserId = 'reddituser'
    $UserSecret = 'password12345'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)
    
    $ExportFile = '{0}\RedditApplicationExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()
    
    $Application = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $ClientCredential
        UserCredential   = $UserCredential
        Type             = 'Script'
        ExportPath       = $ExportFile 
    }
    
    $ParameterSets = @(
        @{
            Name   = 'Application'
            Params = @{
                Application = $Application
            }
        }
        @{
            Name   = 'Application And State'
            Params = @{
                Application = $Application
                State       = 'testytesttest'
            }
        }
        @{
            Name   = 'Application, State, Duration'
            Params = @{
                Application = $Application
                State       = 'testytesttest'
                Duration    = 'Temporary'
            }
        }
        @{
            Name   = 'Application, State, Duration, AuthBaseUrl'
            Params = @{
                Application = $Application
                State       = 'testytesttest'
                Duration    = 'Temporary'
                AuthBaseUrl = 'https://redditclone.com'
            }
        }
    )
    
    function MyTest {
        Mock -ModuleName $moduleName -CommandName Show-RedditOAuthWindow {
            $state = ([System.Web.HttpUtility]::ParseQueryString($uri.Query))['State']
            return [system.uri]('{0}?state={1}&code=98765' -f $RedirectUri, $State)
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
