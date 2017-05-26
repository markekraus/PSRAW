<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/17/2017 04:07 AM
     Edited on:    5/18/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Update-RedditOAuthToken.ps1
    
    .DESCRIPTION
        Update-RedditOAuthToken Function
#>
[CmdletBinding()]
param()

function Update-RedditOAuthToken {
    [CmdletBinding(
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditOAuthToken])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Alias('Token')]
        [RedditOAuthToken[]]$AccessToken,
        
        [switch]$Force,
        
        [switch]$PassThru
        
    )
    
    process {
        foreach ($Token in $AccessToken) {
            if (-not $PSCmdlet.ShouldProcess($Token.GUID)) {
                continue
            }
            if (-not $Token.IsExpired() -and -not $Force) {
                continue
            }
            switch ($Token.GrantType) {
                'Installed_Client' {
                    $Params = @{
                        Application = $Token.Application
                        DeviceID    = $Token.DeviceID
                    }  
                    $Result = Request-RedditOAuthTokenInstalled @Params
                    Break
                }
                'Authorization_Code' { 
                    $Params = @{
                        AccessToken = $Token
                    }  
                    $Result = Request-RedditOAuthTokenRefresh @Params
                    Break
                }
                'Password' { 
                    $Params = @{
                        Application = $Token.Application
                    }  
                    $Result = Request-RedditOAuthTokenPassword @Params
                    Break
                }
                'Client_Credentials' { 
                    $Params = @{
                        Application = $Token.Application
                    }  
                    $Result = Request-RedditOAuthTokenClient @Params
                    Break
                }
                'Implicit' { 
                    $Params = @{
                        Application = $Token.Application
                    }  
                    $Result = Request-RedditOAuthTokenImplicit @Params
                    Break
                }
            }
            $Token.Refresh($Result)
            if ($PassThru.IsPresent) {
                $Token
            }
        }        
    }
}