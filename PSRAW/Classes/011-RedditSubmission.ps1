<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/15/2017 4:53 AM
     Edited on:     8/15/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	011-RedditSubmission.ps1
    
    .DESCRIPTION
        RedditSubmission Class
#>
Class RedditSubmission : RedditDataObject {
    [RedditLink]$Link
    [RedditComment[]]$Comments
    RedditSubmission () { }
    RedditSubmission ([RedditApiResponse]$ApiResponse) {
        $Things = [RedditThing]::CreateFrom($ApiResponse)
        $This.Link = $Things[0].RedditData.Items[0]
        $This.Comments = $Things[1].RedditData.Items
     }
}
