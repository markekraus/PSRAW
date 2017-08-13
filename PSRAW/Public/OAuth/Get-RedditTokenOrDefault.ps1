<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/13/2017 11:11 AM
     Edited on:     8/13/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Get-RedditTokenOrDefault.ps1
    
    .DESCRIPTION
        Get-RedditTokenOrDefault Function
#>
[CmdletBinding()]
param()

function Get-RedditTokenOrDefault {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Get-RedditTokenOrDefault',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditOAuthToken])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [Alias('Token')]
        [AllowNull()]
        [RedditOAuthToken]$AccessToken
    )
    Process {
        if (-not $PSCmdlet.ShouldProcess($AccessToken.GUID)) {
            return
        }
        $Default = Get-RedditDefaultOAuthToken
        if(
            $Default.GUID -ne $AccessToken.GUID -and
            (
                $null -eq $AccessToken -or
                $AccessToken.GUID -eq [GUID]::Empty
            )
        ){
            return $Default
        }
        return $AccessToken
    }
}
