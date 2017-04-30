<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    4/30/2017 1:09 PM
     Edited on:     4/30/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Export-RedditApplication.ps1
    ===========================================================================
    .DESCRIPTION
        Export-RedditApplication Function
#>
Using Module '..\..\Enums\RedditApplicationType.psm1'
Using Module '..\..\Classes\RedditScope.psm1'
Using Module '..\..\Classes\RedditApplication.psm1'


function Export-RedditApplication {
    [CmdletBinding(DefaultParameterSetName = 'ExportPath',
                   ConfirmImpact = 'Low',
                   HelpUri = 'https://github.com/markekraus/ConnectReddit/wiki/Export%E2%80%90RedditApplication',
                   SupportsShouldProcess = $true)]
    [OutputType([System.IO.FileInfo])]
    param
    (
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LiterlPath,
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ExportPath',
                   Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('ASCII', 'UTF8', 'UTF7', 'UTF32', 'Unicode', 'BigEndianUnicode', 'Default', 'OEM')]
        [string]$Encoding = 'Unicode',
        
        [Parameter(ParameterSetName = 'LiteralPath',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'Path',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ExportPath',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Alias('App', 'RedditApplication')]
        [RedditApplication]$Application
    )
    
    Process {
        $Params = @{
            Depth = [int32]::MaxValue - 1
            Encoding = $Encoding
            InputObject = $Application
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
                $Params['Path'] = $Application.ExportPath
                $Target = $LiteralPath
                break
            }
        }
        if ($pscmdlet.ShouldProcess("Target")) {
            Export-Clixml @Params
        }
    }
}
