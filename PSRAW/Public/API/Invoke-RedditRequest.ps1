<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	5/20/2017 8:32 AM
     Edited on:     5/20/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Invoke-RedditRequest.ps1
    
    .DESCRIPTION
        Invoke-RedditRequest Function
#>
[CmdletBinding()]
param()

function Invoke-RedditRequest {
    [CmdletBinding(
        ConfirmImpact = 'Medium',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditApiResponse])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [RedditOAuthToken]
        $AccessToken,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]$Uri,
        
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'Default',
        
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [Object]$Body,
        
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,
        
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(0, 2147483647)]
        [System.Int32]$TimeoutSec,
        
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true)]
        [System.String]$ContentType = 'application/json'
    )
    Process {
        if (-not $PSCmdlet.ShouldProcess("$Uri")) {
            return
        }
        $AccessToken | Wait-RedditApiRateLimit
        try {
            Write-Verbose "Performing token refresh"
            $AccessToken | Update-RedditOAuthToken -ErrorAction Stop
        }
        Catch {
            $ErrorMessage = "Unable to refresh Access Token '{0}'" -f $AccessToken.GUID
            Write-Error -Exception $_.Exception -Message $ErrorMessage
            return
        }
        Write-Verbose "Set base parameters"
        $Params = @{
            ContentType     = $ContentType
            Uri             = $Uri
            Method          = $Method
            ErrorAction     = 'Stop'
            UserAgent       = $AccessToken.Application.UserAgent
            WebSession      = $AccessToken.Session
            UseBasicParsing = $true
        }
        if ($Body) {
            Write-Verbose "Setting Body Parameter"
            $Params['Body'] = $Body
        }
        if ($TimeoutSec) {
            Write-Verbose "Setting TimeoutSec Parameter"
            $Params['TimeoutSec'] = $TimeoutSec
        }
        Write-Verbose "Setting Headers Parameter"
        $Params['Headers'] = @{ }
        if ($Headers) {
            Write-Verbose "Setting user supplied headers"
            $Params['Headers'] = $Headers
        }
        Write-Verbose "Setting Authorization header"
        $Params['Headers']['Authorization'] = 'Bearer {0}' -f $AccessToken.GetAccessToken()
        try {
            $Result = Invoke-WebRequest @Params
        }
        catch {
            $response = $_.Exception.Response
            $ResponseBody = $_.ErrorDetails.Message
            if ($Response.GetType().FullName -like 'System.Net.HttpWebResponse') {
                $Stream = $response.GetResponseStream()
                $Stream.Position = 0
                $StreamReader = New-Object System.IO.StreamReader $Stream
                $ResponseBody = $StreamReader.ReadToEnd()
            }
            $ErrorMessage = "Unable to query Uri '{0}': {1}: {2}" -f (
                $Uri, 
                $_.Exception.Message, 
                $ResponseBody
            )
            Write-Error -Exception $_.Exception -message $ErrorMessage 
            return
        }
        Write-Verbose "Truncating Authorization headers"
        $null = $AccessToken.Session.Headers.Remove('Authorization')
        $Params.Headers.Authorization = '{0}...<truncated>' -f (
            $Params.Headers.Authorization.Substring(0, 3)
        )
        $ContentType = $Result | Get-HttpResponseContentType
        switch ($ContentType) {
            { $_ -match 'application/json' } {
                Write-Verbose "Converting result from JSON to PSObject"
                $ContentObject = $Result.Content | ConvertFrom-Json -ErrorAction SilentlyContinue
                break
            }
            default {
                Write-Verbose "Unhandled Content-Type. ContentObject will be raw."
                $ContentObject = $Result.Content
                break
            }
        }
        $AccessToken.UpdateRateLimit($Result)
        [RedditApiResponse]@{
            AccessToken   = $AccessToken
            Parameters    = $Params
            RequestDate   = $Result.Headers.Date[0]
            Response      = $Result
            ContentObject = $ContentObject
            ContentType   = $ContentType
        }
    }
}
