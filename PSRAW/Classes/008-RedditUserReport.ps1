<#
    .NOTES

     Created with: 	Plaster
     Created on:   	6/1/2017 1:47 PM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	008-RedditUserReport.ps1

    .DESCRIPTION
        RedditUserReport Class
#>
Class RedditUserReport {
    [String]$Reason
    [long]$Count
    RedditUserReport () {
    }
    RedditUserReport ([Object[]]$InputObjects) {
        $This.Reason = $InputObjects[0]
        $This.Count = $InputObjects[1]
    }
}
