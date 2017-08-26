<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/13/2017 10:10 AM
     Edited on:     8/17/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	014-RedditListing.ps1
    
    .DESCRIPTION
        RedditListing Class
#>
Class RedditListing : RedditDataObject {
    [string]$Before
    [string]$After
    [string]$Modhash
    [RedditThing[]]$Children
    [RedditThingKind[]]$ChildKinds
    [PSObject]$ParentObject
    [RedditDataObject[]]$Items
    [RedditThingKind]$Kind = 'Listing'
    Static [RedditThingKind]$RedditThingKind = 'Listing'
    RedditListing () { }
    RedditListing ([RedditThing]$RedditThing){
        if($RedditThing.Kind -ne $This::RedditThingKind){
            $Message = 'Unable to convert RedditThing of kind "{0}" to "{1}"' -f
                $RedditThing.Kind,
                $This.GetType().Name
            $Exception = [System.InvalidCastException]::new($Message)
            Throw $Exception
        }
        $This.Before = $RedditThing.Data.before
        $This.After = $RedditThing.Data.After
        $This.Modhash = $RedditThing.Data.Modhash
        $This.Children = [RedditThing[]]$RedditThing.Data.children
        $This.ParentObject = $RedditThing
        $This.ChildKinds = $This.Children.Kind | Select-Object -Unique
        $This.Items = $This.Children.RedditData
    }

    [RedditComment[]] GetComments() {
        return ($This.Items | Where-Object {$_ -is 'RedditComment'})
    }

    [RedditMore[]] GetMores() {
        return ($This.Items | Where-Object {$_ -is 'RedditMore'})
    }

    [RedditLink[]] GetLinks() {
        return ($This.Items | Where-Object {$_ -is 'RedditLink'})
    }
}
