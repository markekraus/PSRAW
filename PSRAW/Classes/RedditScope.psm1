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

    RedditScope () {
        $This._init('','','','')
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