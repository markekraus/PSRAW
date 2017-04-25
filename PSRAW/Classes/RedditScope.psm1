<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	4/24/2017 3:37 PM
     Editied on:    4/24/2017
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	RedditScope.ps1
	===========================================================================
	.DESCRIPTION
		RedditScope Class
#>
Class RedditScope {
    [String]$Scope
    [String]$Id
    [String]$Name    
    [String]$Description

    Static [String]$ApiEndpointUri = 'https://www.reddit.com/api/v1/scopes'

    Static [String] GetApiEndpointUri (){
        return [RedditScope]::ApiEndpointUri
    }

    RedditScope () {
        $This._init('','','','')
    }
    
    RedditScope ([String]$Scope) {
        $This._init($Scope,$Scope,$Scope,$Scope)
    }

    RedditScope ([String]$Scope, [String]$Id, [String]$Name, [String]$Description){
        $This._init($Scope, $Id, $Name, $Description)
    }

    hidden [void] _init ([String]$Scope, [String]$Id, [String]$Name, [String]$Description){
        $This.Scope = $Scope
        $This.Id = $Id
        $This.Name = $Name
        $This.Description = $Description
    }
}