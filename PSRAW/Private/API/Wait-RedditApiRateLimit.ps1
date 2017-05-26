<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	5/20/2017 6:18 AM
     Edited on:     5/20/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Wait-RedditApiRateLimit.ps1
    
    .DESCRIPTION
        Wait-RedditApiRateLimit Function
#>
[CmdletBinding()]
param()

function Wait-RedditApiRateLimit {
    [CmdletBinding(
        ConfirmImpact = 'None',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Wait-RedditApiRateLimit',
        SupportsShouldProcess = $true
    )]
    [OutputType([Void])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Token')]
        [RedditOAuthToken]
        $AccessToken,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true
        )]
        [int]
        $MaxSleepSeconds = 300
    )
    Begin {
        $MaxSleepDate = (Get-date).AddSeconds($MaxSleepSeconds)
    }
    Process {
        if (-not $PSCmdlet.ShouldProcess($AccessToken.GUID)) {
            return
        }
        if (-not $AccessToken.IsRateLimited()) {
            Write-Verbose 'Token has not exceeded ratelimit.'
            return
        }
        $Message = 'Rate limit in effect until {0}. Sleeping.' -f $AccessToken.GetRateLimitReset()
        Write-Warning $Message
        while (
            $AccessToken.IsRateLimited() -and 
            (Get-Date) -lt $MaxSleepDate
        ) {
            Start-Sleep -Seconds 1
        }
    }
}
