<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/12/2017 8:01 AM
     Edited on:     8/12/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Get-RedditDefaultOAuthToken.ps1
    
    .DESCRIPTION
        Get-RedditDefaultOAuthToken Function
#>
[CmdletBinding()]
param()

function Get-RedditDefaultOAuthToken {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Get-RedditDefaultOAuthToken',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditOAuthToken])]
    param( )
    Process {
        if (-not $PSCmdlet.ShouldProcess("Getting Default Token")) {
            return
        }
        $Script:PsrawSettings.AccessToken
    }
}
