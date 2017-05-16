<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/01/2017 11:38 AM
     Editied on:    5/14/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Request-RedditOAuthCode.ps1
    
    .DESCRIPTION
        Request-RedditOAuthCode Function
#>
[CmdletBinding()]
param()

function Request-RedditOAuthCode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditOAuthCode])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('App')]
        [RedditApplication]$Application,

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$State = [guid]::newguid().tostring(),

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $true
        )]
        [RedditOAuthDuration]$Duration = [RedditOAuthDuration]::Permanent,

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $true
        )]
        [String]$AuthBaseUrl = [RedditApplication]::AuthBaseURL

    )
    Process {
        if (-not $pscmdlet.ShouldProcess($Application.ClientID)) {
            return
        }
        $Url = $Application.GetAuthorzationUrl(
            [RedditOAuthResponseType]::Code,
            $Duration,
            $State,
            $AuthBaseUrl
        )
        $Params = @{
            Url         = $Url
            RedirectUri = $Application.RedirectUri
        }
        $Result = Show-RedditOAuthWindow @Params
        $Issued = Get-Date
        $QueryOutput = [System.Web.HttpUtility]::ParseQueryString($Result.Query)
        $Response = @{ }
        foreach ($key in $queryOutput.Keys) {
            $Response["$key"] = $QueryOutput[$key]
        }
        $SecAuthCode = 'NOAUTHCODE' | ConvertTo-SecureString -AsPlainText -Force
        $AuthCodeCredential = [pscredential]::new('NOAUTHCODE', $SecAuthCode)
        if ($Response.Code) {
            $SecAuthCode = $Response.Code | ConvertTo-SecureString -AsPlainText -Force
            $AuthCodeCredential = [pscredential]::new('AuthCode', $SecAuthCode)
            $Response.Remove('Code')
        }
        [RedditOAuthCode]@{
            Application        = $Application
            AuthBaseURL        = $AuthBaseUrl            
            IssueDate          = $Issued
            StateSent          = $State
            StateReceived      = $Response.State
            Duration           = $Duration
            ResponseType       = [RedditOAuthResponseType]::Code
            AuthCodeCredential = $AuthCodeCredential
        }
    }
}