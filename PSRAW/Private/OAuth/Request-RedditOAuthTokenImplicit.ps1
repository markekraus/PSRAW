<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/06/2017 02:27 PM
     Editied on:    5/14/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthTokenImplicit.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenImplicit Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthTokenImplicit {
    [CmdletBinding(
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit'
    )]
    [OutputType([System.Uri])]
    param (
        [Parameter( 
            mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( 
            {
                If (-not ($_.Type -eq [RedditApplicationType]::Installed)) {
                    $Exception = [System.Management.Automation.ValidationMetadataException]::new(
                        "RedditApplicationType must be 'Installed'"
                    )
                    Throw $Exception
                }
                $true
            }
        )]
        [RedditApplication]$Application,

        [Parameter( 
            mandatory = $false, 
            ValueFromPipeline = $false, 
            ValueFromPipelineByPropertyName = $True
        )]
        [String]$State = [guid]::newguid().tostring(),

        [Parameter( 
            mandatory = $false, 
            ValueFromPipeline = $false, 
            ValueFromPipelineByPropertyName = $false
        )]
        [String]$AuthBaseUrl = [RedditApplication]::AuthBaseURL
    )
    process {
        $Url = $Application.GetAuthorzationUrl(
            [RedditOAuthResponseType]::Token,
            [RedditOAuthDuration]::Temporary,
            $State,
            $AuthBaseUrl
        )
        $Params = @{
            Url         = $Url
            RedirectUri = $Application.RedirectUri
        }
        Show-RedditOAuthWindow @Params
    }
}