<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/16/2017 4:09 AM
     Edited on:     8/16/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	008-RedditHeaderSize.ps1
    
    .DESCRIPTION
        RedditHeaderSize Class
#>
Class RedditHeaderSize {
    [long]$Width
    [long]$Height
    RedditHeaderSize ([Object[]]$InputObjects) {
        $This.Width = $InputObjects[0]
        $This.Height = $InputObjects[1]
    }
}
