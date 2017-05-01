<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    05/01/2017 4:43 PM
     Edited on:     05/01/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Import-RedditApplication.Unit.Tests.ps1
    ===========================================================================
    .DESCRIPTION
        Import-RedditApplication Function unit tests
#>
Using Module '..\PSRAW\Enums\RedditApplicationType.psm1'
Using Module '..\PSRAW\Classes\RedditScope.psm1'
Using Module '..\PSRAW\Classes\RedditApplication.psm1'

$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

$Command = 'Import-RedditApplication'
$TypeName = 'RedditApplication'

$ClientId = '54321'
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId,$SecClientSecret)

$UserId = 'reddituser'
$UserSceret = 'password12345'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId,$SecUserSecret)

$ExportFile = '{0}\ReditApplicationExport-{1}.xml' -f $env:TEMP, [guid]::NewGuid().toString()

$Application = [RedditApplication]@{
    Name = 'TestApplication'
    Description = 'This is only a test'
    RedirectUri = 'https://localhost/'
    UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope = 'read'
    ClientCredential = $ClientCredential
    UserCredential = $UserCredential
    Type = 'Script'
    ExportPath = $ExportFile 
}

$Application | Export-RedditApplication

$ParamterSets = @(
    @{
        Name = 'Path'
        Params =@{
            Path = $ExportFile
        }
    }
    @{
        Name = 'LiteralPath'
        Params =@{
            LiteralPath = $ExportFile
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

Remove-Item -Force -Path $ExportFile -ErrorAction SilentlyContinue