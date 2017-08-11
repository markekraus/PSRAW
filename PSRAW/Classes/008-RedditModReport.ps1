<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	6/1/2017 1:44 PM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	008-RedditModReport.ps1
    
    .DESCRIPTION
        RedditModReport Class
#>
Class RedditModReport {
    [String]$Reason
    [String]$Moderator
    RedditModReport ([Object[]]$InputObjects) {
        $This.Reason = $InputObjects[0]
        $This.Moderator = $InputObjects[1]
    }
}
