<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	5/20/2017 10:01 AM
     Edited on:     5/20/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	005-RedditApiResponse.ps1
    
    .DESCRIPTION
        RedditApiResponse Class
#>
Class RedditApiResponse {
    [RedditOAuthToken]$AccessToken
    [hashtable]$Parameters
    [DateTime]$RequestDate
    [Object]$Response
    [Object]$ContentObject
    RedditApiResponse () { }
}
