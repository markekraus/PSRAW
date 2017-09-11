<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/11/2017 6:00 PM
     Edited on:     8/11/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Connect-Reddit.ps1
    
    .DESCRIPTION
        Connect-Reddit Function
#>
[CmdletBinding()]
param()

function Connect-Reddit {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Connect-Reddit'
    )]
    [OutputType([Void])]
    param
    (
        [pscredential]$ClientCredential,
        [pscredential]$UserCredential,
        [uri]$RedirectUri
    )
    Process {
        $ClientID = $ClientCredential.UserName
        if ([string]::IsNullOrEmpty($ClientID)) {
            $ClientID = Read-Host 'Enter your Reddit Script Application Client ID'
        }
        $ClientSecret = $ClientCredential.Password
        if(
            $null -eq $ClientSecret -or
            $ClientSecret.Length -eq 0
        ) {
            $ClientSecret = Read-Host 'Enter your Reddit Script Application Client Secret' -AsSecureString
        }
        if([string]::IsNullOrEmpty($RedirectUri.AbsoluteUri)){
            [uri]$RedirectUri = Read-Host 'Enter your Reddit Application Redirect URI'
        }
        $Username = $UserCredential.UserName
        if (
            $Null -eq $Username -or 
            $Username -eq [string]::Empty
        ) {
            $Username = Read-Host 'Enter your Reddit User ID'
        }
        $Password = $UserCredential.Password
        if(
            $null -eq $Password -or
            $Password.Length -eq 0
        ) {
            $Password = Read-Host 'Enter your Reddit Password' -AsSecureString
        }
        $AppParams = @{
            Script = $True
            ClientCredential = [pscredential]::New($ClientID,$ClientSecret)
            UserCredential = [pscredential]::New($Username,$Password)
            RedirectUri = $RedirectUri
        }
        $Application = New-RedditApplication @AppParams 
        Request-RedditOAuthToken -Script -Application $Application
    }
}