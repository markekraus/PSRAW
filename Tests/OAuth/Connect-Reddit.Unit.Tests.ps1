<#
    .NOTES
     Test must be run with Start-PSRAWPester

     Created with:  VSCode
     Created on:    5/18/2017 4:31 AM
     Edited on:     9/02/2017
     Created by:    Mark Kraus
     Organization:
     Filename:    Connect-Reddit.Unit.Tests.ps1

    .DESCRIPTION
       Connect-Reddit Function unit tests
#>
Describe "Connect-Reddit" -Tags Build, Unit {
    BeforeAll {
        Initialize-PSRAWTest
        Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
        Import-Module -force $ModulePath
        # Tricks Request-RedditOAuthToken into using WebListener
        [RedditOAuthToken]::AuthBaseURL = Get-WebListenerUrl -Test 'Token'
    }
    Mock -CommandName Read-Host -ModuleName $ModuleName -MockWith {
        $ClientId = '54321'
        $ClientSecret = '12345'
        $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
        $UserId = 'reddituser'
        $UserSecret = 'password'
        $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force
        $RedirectUri = 'https://localhost/'
        Switch -Regex ($Prompt) {
            'Client ID' {
                $Output = $ClientId; break
            }
            'Client Secret' {
                $Output = $SecClientSecret; break
            }
            'User ID' {
                $Output = $UserId; break
            }
            'Password' {
                $Output = $SecUserSecret; break
            }
            'Redirect' {
                $Output = $RedirectUri; break
            }
            Default {
                Throw "Unknown Prompt: $_"
            }
        }
        return $Output
    }
    It "Runs without error" {
        { Connect-Reddit } | Should Not Throw
    }
}