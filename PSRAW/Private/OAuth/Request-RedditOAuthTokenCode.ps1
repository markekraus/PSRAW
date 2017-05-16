<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/05/2017 02:27 PM
     Editied on:    5/14/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthTokenCode.ps1
    
    .DESCRIPTION
        Request-RedditOAuthTokenCode Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthTokenCode {
    [CmdletBinding(
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode'
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
                If (-not ($_.Type -eq [RedditApplicationType]::Script -or $_.Type -eq [RedditApplicationType]::WebApp)) {
                    $Exception = [System.Management.Automation.ValidationMetadataException]::new(
                        "RedditApplicationType must be 'Script' or 'WebApp"
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
        [String]$AuthBaseUrl = [RedditOAuthToken]::AuthBaseURL,

        [Parameter( 
            mandatory = $false, 
            ValueFromPipeline = $false, 
            ValueFromPipelineByPropertyName = $false
        )]
        [String]$AuthCodeBaseUrl = [RedditApplication]::AuthBaseURL
    )
    process {
        $Params = @{
            Application = $Application
            State       = $State
            Duration    = [RedditOAuthDuration]::Permanent
            AuthBaseUrl = $AuthCodeBaseUrl
        }
        $AuthCode = Request-RedditOAuthCode @Params
        $Params = @{
            Uri             = $AuthBaseUrl
            Body            = @{
                grant_type   = 'authorization_code'
                code         = $AuthCode.GetAuthorizationCode()
                redirect_uri = $Application.RedirectUri
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