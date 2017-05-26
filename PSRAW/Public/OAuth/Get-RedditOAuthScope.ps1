<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	4/23/2017 1:42 PM
     Edited on:    5/13/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Get-RedditOAuthScope.ps1
    
    .DESCRIPTION
        Get-RedditOAuthScope Function
#>
[CmdletBinding()]
param()

function Get-RedditOAuthScope {
    [CmdletBinding(
        ConfirmImpact = 'None',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope'
    )]
    [OutputType([RedditOAuthScope])]
    param
    (
        [Parameter(Mandatory = $false)]
        [string]$ApiEndpointUri = [RedditOAuthScope]::GetApiEndpointUri()
    )
    
    Write-Verbose "Retrieving Scopes from '$ApiEndpointUri'"
    $ResultObj = Invoke-RestMethod -Uri $ApiEndpointUri

    Write-Verbose "Looping through each scope and creating [RedditOAuthScope] Objects"
    foreach ($Property in $ResultObj.psobject.Properties.Name) {
        Write-Verbose "Processing '$Property'"
        [RedditOAuthScope]@{
            Scope       = $Property
            Id          = $ResultObj.$Property.id
            Name        = $ResultObj.$Property.Name
            Description = $ResultObj.$Property.Description
        }
    }
}