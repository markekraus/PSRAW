<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/12/2017 8:00 AM
     Edited on:     8/12/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Set-RedditDefaultOAuthToken.ps1
    
    .DESCRIPTION
        Set-RedditDefaultOAuthToken Function
#>
[CmdletBinding()]
param()

function Set-RedditDefaultOAuthToken {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Set-RedditDefaultOAuthToken',
        SupportsShouldProcess = $true
    )]
    [OutputType([Void])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Alias('Token')]
        [RedditOAuthToken]
        $AccessToken
    )
    Process {
        if (-not $PSCmdlet.ShouldProcess("Setting default Access Token")) {
            return
        }
        $Script:PsrawSettings.AccessToken = $AccessToken
    }
}
