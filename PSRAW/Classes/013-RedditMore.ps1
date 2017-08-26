<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/17/2017 4:24 AM
     Edited on:     8/17/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	010-RedditMore.ps1
    
    .DESCRIPTION
        RedditMore Class
#>
Class RedditMore : RedditDataObject {
    [string[]]$Children
    [long]$Count
    [string]$Id
    [string]$Name
    [string]$Parent_Id
    [PSObject]$ParentObject
    [RedditThingKind]$Kind = 'More'
    Static [RedditThingKind]$RedditThingKind = 'More'
    RedditMore () { }
    RedditMore ([RedditThing]$RedditThing){
        if($RedditThing.Kind -ne $This::RedditThingKind){
            $Message = 'Unable to convert RedditThing of kind "{0}" to "{1}"' -f
                $RedditThing.Kind,
                $This.GetType().Name
            $Exception = [System.InvalidCastException]::new($Message)
            Throw $Exception
        }
        $This.Children     = $RedditThing.Data.Children
        $This.Count        = $RedditThing.Data.Count
        $This.Name         = $RedditThing.Data.Name
        $This.Parent_Id    = $RedditThing.Data.parent_id
        $This.ParentObject = $RedditThing
    }
    # TODO Add GetMoreItems() to retrieve the More's items
}
