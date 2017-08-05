<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/2/2017 4:31 PM
     Edited on:     8/2/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	003-RedditOAuthResponse.ps1
    
    .DESCRIPTION
        RedditOAuthResponse Class
#>
Class RedditOAuthResponse {
    [hashtable]$Parameters
    [DateTime]$RequestDate
    [Microsoft.PowerShell.Commands.WebResponseObject]$Response
    [PSObject]$Content
    [String]$ContentType
    RedditOAuthResponse () { }
}
