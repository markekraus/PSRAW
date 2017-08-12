<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/11/2017 4:39 AM
     Edited on:     5/11/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Import-RedditOAuthToken.ps1
    
    .DESCRIPTION
        Import-RedditOAuthToken Function
#>
[CmdletBinding()]
param()

function Import-RedditOAuthToken {
    [CmdletBinding(
        DefaultParameterSetName = 'Path',
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Import-RedditOAuthToken',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditOAuthToken])]
    param
    (
        [Parameter(
            ParameterSetName = 'Path',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,
        
        [Parameter(
            ParameterSetName = 'LiteralPath',
            Mandatory = $true,
            ValueFromRemainingArguments = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath,

        [switch]
        $PassThru
    )
    
    Process {
        Switch ($PsCmdlet.ParameterSetName) {
            'Path' {
                $ImportFiles = $Path
                $ImportParam = 'Path'
                Break
            }
            'LiteralPath' {
                $ImportFiles = $LiteralPath
                $ImportParam = 'LiteralPath'
                Break
            }
        }
        foreach ($ImportFile in $ImportFiles) {
            if (-not $pscmdlet.ShouldProcess($ImportFile)) {
                Continue
            }
            $Params = @{
                "$ImportParam" = $ImportFile
            }
            $InObject = Import-Clixml @Params 
            $AccessToken = [RedditOAuthToken]::Reserialize($InObject)
            $AccessToken.ExportPath = (Resolve-Path $ImportFile).Path
            $AccessToken | Set-RedditDefaultOAuthToken
            If ($PassThru) {
                $AccessToken
            }
        } #End Foreach
    } #End Process
} #End Function