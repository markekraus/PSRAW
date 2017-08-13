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
    [RedditDataObject]$Data
    [string]$Name
    [string]$Id
    [PSObject]$Parent
    RedditThing () {}
    RedditThing ([RedditApiResponse]$Response) {
        $this.Kind = $Response.ContentObject.Kind
        $This.Name = $Response.ContentObject.Name
        $This.Id = $Response.ContentObject.Id
        $This.Parent = $Response
        $This.AccessToken = Get-RedditTokenOrDefault $Response.AccessToken
        $Params = @{
            RedditThing = $this
            AccessToken = $This.AccessToken
        }
        $This.Data = Resolve-RedditDataObject @Params
    }
    RedditThing ([System.Management.Automation.PSCustomObject]$Object) {
        $this.Kind = $Object.Kind
        $This.Name = $Object.Name
        $This.Id = $Object.Id
        $This.AccessToken = Get-RedditTokenOrDefault $Object.AccessToken
        $Params = @{
            RedditThing = $this
            AccessToken = $This.AccessToken
        }
        $This.Data = Resolve-RedditDataObject @Params
    }
}
