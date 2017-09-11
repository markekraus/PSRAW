<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/2/2017 8:37 AM
     Edited on:     8/2/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	Get-HttpResponseContentType.ps1
    
    .DESCRIPTION
        Get-HttpResponseContentType Function
#>
[CmdletBinding()]
param()

function Get-HttpResponseContentType {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-HttpResponseContentType',
        SupportsShouldProcess = $false
    )]
    [OutputType([String])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]    
        [Microsoft.PowerShell.Commands.WebResponseObject]
        $Response
    )
    Process {
        @(
            $Response.BaseResponse.Content.Headers.ContentType.MediaType
            $Response.BaseResponse.ContentType
        ) | 
            Where-Object {-not [string]::IsNullOrEmpty($_)} |
            Select-Object -First 1
    }
}
