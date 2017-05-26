<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/05/2017 02:00 PM
     Edited on:     5/05/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	RedditOAuthGrantType.psm1
    
    .DESCRIPTION
        RedditOAuthGrantType Enum
#>
Enum RedditOAuthGrantType {
    Authorization_Code
    Client_Credentials
    Installed_Client
    Password
    Refresh_Token
    Implicit
}