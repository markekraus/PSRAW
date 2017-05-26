<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/05/2017 11:27 AM
     Edited on:     5/14/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthTokenInstalled.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenInstalled Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthTokenInstalled {
    [CmdletBinding(
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled'
    )]
    [OutputType([Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject])]
    param (
        [Parameter( 
            mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true
        )]
        [RedditApplication]$Application,

        [Parameter( 
            mandatory = $false, 
            ValueFromPipeline = $false, 
            ValueFromPipelineByPropertyName = $true
        )]
        [String]$DeviceID = [guid]::NewGuid().tostring(),

        [Parameter( 
            mandatory = $false, 
            ValueFromPipeline = $false, 
            ValueFromPipelineByPropertyName = $false
        )]
        [String]$AuthBaseUrl = [RedditOAuthToken]::AuthBaseURL
    )
    process {
        $Params = @{
            Uri             = $AuthBaseUrl
            Body            = @{
                grant_type = 'https://oauth.reddit.com/grants/installed_client'
                device_id  = $DeviceID
            }
            UserAgent       = $Application.UserAgent
            Headers         = @{
                Authorization = $Application.ClientCredential | Get-AuthorizationHeader 
            }
            Method          = 'POST'
            UseBasicParsing = $true
        }
        Invoke-WebRequest @Params 
    }
}