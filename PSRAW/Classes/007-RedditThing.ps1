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
    [RedditOAuthToken]$AccessToken
    [RedditThingPrefix]$Prefix
    [string]$UID
    Static [String]$ApiEndpointUri
    RedditThing () {
        $Type = $This.GetType()
        if ($Type -eq [RedditThing]) {
            throw("Class $type must be inherited")
        }
    }
    [String] GetApiEndpointUri () {
        throw("Must Override Method")
    }
    [String] GetFullName () {
        throw("Must Override Method")
    }
}
