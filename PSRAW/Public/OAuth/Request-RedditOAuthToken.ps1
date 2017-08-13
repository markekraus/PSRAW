<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/01/2017 11:38 AM
     Edited on:    5/13/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthToken.ps1
    
    .DESCRIPTION
        Request-RedditOAuthToken Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthToken {
    [CmdletBinding(
        DefaultParameterSetName = 'Script',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken'
    )]
    [OutputType([RedditOAuthToken])]
    param
    (
        [Parameter(
            ParameterSetName = 'Installed',
            Mandatory = $true
        )]
        [switch]$Installed,

        [Parameter(
            ParameterSetName = 'Client',
            Mandatory = $true
        )]
        [switch]$Client,
        
        [Parameter(
            ParameterSetName = 'Script',
            Mandatory = $true
        )]
        [switch]$Script,
        
        [Parameter(
            ParameterSetName = 'Installed',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Parameter(
            ParameterSetName = 'Script',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [Parameter(
            ParameterSetName = 'Client',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0
        )]
        [RedditApplication]$Application,
        
        
        [Parameter(
            ParameterSetName = 'Installed',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            Position = 1
        )]
        [string]$DeviceID = [guid]::NewGuid().toString(),

        [switch]$PassThru
    )
    
    process {

        switch ($PSCmdlet.ParameterSetName) {
            'Installed' {
                $GrantType = [RedditOAuthGrantType]::Installed_Client
                $Params = @{
                    Application = $Application
                    DeviceID    = $DeviceID
                }  
                $Result = Request-RedditOAuthTokenInstalled @Params
                Break
            }
            'Script' { 
                $GrantType = [RedditOAuthGrantType]::Password
                $Params = @{
                    Application = $Application
                }  
                $Result = Request-RedditOAuthTokenPassword @Params
                Break
            }
            'Client' { 
                $GrantType = [RedditOAuthGrantType]::Client_Credentials
                $Params = @{
                    Application = $Application
                }  
                $Result = Request-RedditOAuthTokenClient @Params
                Break
            }
        }
        $Token = [RedditOAuthToken]::New($GrantType, $Application, $Result)
        $Token | Set-RedditDefaultOAuthToken
        if ($PassThru) {
            $Token
        }
    }
}