<#
    .NOTES

     Created with: 	Plaster
     Created on:   	8/13/2017 12:55 PM
     Edited on:     8/13/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	Resolve-RedditDataObject.ps1

    .DESCRIPTION
        Resolve-RedditDataObject Function
#>
[CmdletBinding()]
param()

function Resolve-RedditDataObject {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/Module/Resolve-RedditdataObject',
        SupportsShouldProcess = $true
    )]
    [OutputType([RedditDataObject])]
    param
    (
        [parameter(
            ParameterSetName = 'RedditAPIResponse',
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        [RedditApiResponse]$RedditApiResponse,

        [parameter(
            ParameterSetName = 'RedditThing',
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        [RedditThing]$RedditThing,

        [parameter(
            ParameterSetName = 'PSObject',
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        [PSObject]$PSObject

    )
    Begin {
        $DataObjectKindMap = @{
            t1      = 'RedditComment'
            t2      = 'RedditAccount'
            t3      = 'RedditLink'
            t4      = 'RedditMessage'
            t5      = 'RedditSubreddit'
            t6      = 'RedditAward'
            t8      = 'RedditPromoCampaign'
            Listing = 'RedditListing'
            More    = 'RedditMore'
        }
    }
    Process {
        if (-not $PSCmdlet.ShouldProcess("RedditDataObject")) {
            return
        }
        switch ($PSCmdlet.ParameterSetName) {
            'RedditAPIResponse' {
                $RedditThing = [RedditThing]$RedditApiResponse.ContentObject
                $DataObjectKind = $RedditApiResponse.ContentObject.Kind
                Break
            }
            'RedditThing' {
                $DataObjectKind = $RedditThing.Kind
                Break
            }
            'PSObject' {
                $RedditThing = [RedditThing]$PSObject
                $DataObjectKind = $RedditThing.Kind
                Break
            }
        }
        $Class = $DataObjectKindMap["$DataObjectKind"]
        New-Object -TypeName $Class -ArgumentList $RedditThing
    }
}
