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
    [PSObject]$ParentObject
    [RedditDataObject]$RedditData
    RedditThing () {}
    RedditThing ([PSObject]$Object) {
        $this.Kind = $Object.Kind
        $This.Name = $Object.Name
        $This.Id = $Object.Id
        $This.Data = $Object.Data
        $This.AccessToken = Get-RedditTokenOrDefault $Object.AccessToken
        $Params = @{
            RedditThing = $this
            AccessToken = $This.AccessToken
        }
        $This.RedditData = Resolve-RedditDataObject @Params
        $This.RedditData.ParentObject = $This
    }
    static [RedditThing[]] CreateFrom([RedditApiResponse]$Response) {
        $RedditThings = foreach($Object in $Response.ContentObject){
            $RedditThing = [RedditThing]::New($Object)
            $RedditThing.AccessToken = Get-RedditTokenOrDefault $Response.AccessToken
            $RedditThing.ParentObject = $Response
            $RedditThing
        }
        Return $RedditThings
    }
}
