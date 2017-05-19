<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/17/2017 03:58 PM
     Editied on:    5/18/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthTokenRefresh.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenRefresh Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthTokenRefresh {
    [CmdletBinding(
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenRefresh'
    )]
    [OutputType([Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject])]
    param (
        [Parameter( 
            mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( 
            {
                If (-not ($_.GrantType -eq [RedditOAuthGrantType]::Authorization_Code )) {
                    $Exception = [System.Management.Automation.ValidationMetadataException]::new(
                        "RedditOAuthToken must be of RedditOAuthGrantType 'Authorization_Code'"
                    )
                    Throw $Exception
                }
                $true
            }
        )]
        [Alias('Token')]
        [RedditOAuthToken]$AccessToken,

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
                grant_type    = 'refresh_token'
                refresh_token = $AccessToken.GetRefreshToken()
            }
            UserAgent       = $AccessToken.Application.UserAgent
            Headers         = @{
                Authorization = $AccessToken.Application.ClientCredential | Get-AuthorizationHeader 
            }
            Method          = 'POST'
            UseBasicParsing = $true
        }
        Invoke-WebRequest @Params 
    }
}