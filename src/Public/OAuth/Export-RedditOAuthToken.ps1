<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/11/2017 3:47 AM
     Edited on:     5/11/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Export-RedditOAuthToken.ps1
    
    .DESCRIPTION
        Export-RedditOAuthToken Function
#>
[CmdletBinding()]
param()

function Export-RedditOAuthToken {
    [CmdletBinding(
        DefaultParameterSetName = 'ExportPath',
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Export-RedditOAuthToken',
        SupportsShouldProcess = $true
    )]
    [OutputType([System.IO.FileInfo])]
    param
    (
        [Parameter(
            ParameterSetName = 'Path',
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(
            ParameterSetName = 'LiteralPath',
            Mandatory = $true,
            ValueFromRemainingArguments = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$LiteralPath,
        
        [Parameter(
            ParameterSetName = 'LiteralPath',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Path',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'ExportPath',
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet(
            'ASCII', 
            'UTF8', 
            'UTF7', 
            'UTF32', 
            'Unicode', 
            'BigEndianUnicode', 
            'Default', 
            'OEM'
        )]
        [string]$Encoding = 'Unicode',
        
        [Parameter(
            ParameterSetName = 'LiteralPath',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'Path',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Parameter(
            ParameterSetName = 'ExportPath',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Token')]
        [RedditOAuthToken]$AccessToken = (Get-RedditDefaultOAuthToken)
    )
    
    Process {
        #if (-not $AccessToken) {
        #    $AccessToken = Get-RedditDefaultOAuthToken
        #}
        $Params = @{
            Depth       = [int32]::MaxValue - 1
            Encoding    = $Encoding
            InputObject = $AccessToken
        }
        switch ($PsCmdlet.ParameterSetName) {
            'Path' {
                $Params['Path'] = $Path
                $Target = $Path
                break
            }
            'LiteralPath' {
                $Params['LiteralPath'] = $LiteralPath
                $Target = $LiteralPath
                break
            }
            'ExportPath' {
                $Params['Path'] = $AccessToken.ExportPath
                $Target = $LiteralPath
                break
            }
        }
        if ($pscmdlet.ShouldProcess("Target")) {
            Export-Clixml @Params
        }
    }
}
