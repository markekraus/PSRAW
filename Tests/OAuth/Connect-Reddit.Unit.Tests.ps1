<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/18/2017 4:31 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Update-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
       Update-RedditOAuthToken Function unit tests
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$Global:moduleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Global:Command = 'Connect-Reddit'


#region insanity
# For whatever reason, pester chokes trying to mock 
# Request-RedditOAuthToken
# So, we remove them from the module and replace it with a script scope function
# We later mock that function too because it wont work without the mock either
$module = Get-Module $ModuleName
& $module {
    $Commands = @(
        'Request-RedditOAuthToken'
    )
    foreach ($RemoveCom in $Commands) {
        Get-ChildItem function:\ | 
            Where-Object {$_.name -like $RemoveCom} | 
            Remove-Item -Force -Confirm:$false
        Get-ChildItem function:\ | 
            Where-Object {$_.name -like $RemoveCom} | 
            Remove-Item -Force -Confirm:$false
    }
}
function Request-RedditOAuthToken {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [Object[]]
        $Params
    )
    process { }
}


Function MyTest {
    
    $Command = $Global:Command
    $ModuleName = $Global:moduleName

    Mock -CommandName Read-Host -ModuleName $ModuleName -MockWith {
        $ClientId = '54321'
        $ClientSecret = '12345'
        $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
        $UserId = 'reddituser'
        $UserSecret = 'password'
        $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
        $RedirectUri = 'https://localhost/'
        Switch -Regex ($Prompt) {
            'Client ID'     { $Output = $ClientId;        break }
            'Client Secret' { $Output = $SecClientSecret; break }
            'User ID'       { $Output = $UserId;          break }
            'Password'      { $Output = $SecUserSecret;   break }
            'Redirect'      { $Output = $RedirectUri;     break }
            Default         { Throw "Unknown Prompt: $_"            }
        }
        return $Output
    }
    Mock -CommandName Request-RedditOAuthToken -ModuleName $ModuleName -MockWith {  }
    Connect-Reddit
    It "Runs without error" {
        {& $Command} | Should Not Throw
    }
        
}
Describe "$Command Unit" -Tags Unit {
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