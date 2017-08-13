<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	5/29/2017 9:24 AM
     Edited on:     5/29/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	007-RedditThing.ps1
    
    .DESCRIPTION
        RedditThing Class
#>
Class RedditThing {
    hidden [RedditOAuthToken]$AccessToken
    [RedditThingKind]$Kind
    [PSObject]$Data
    [string]$Name
    [string]$Id
    [PSObject]$Parent
}
