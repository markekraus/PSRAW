<#	
    .NOTES
    
     Created with: 	VSCode
     Created on:   	5/03/2017 04:16 AM
     Edited on:     5/14/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	Show-RedditOAuthWindow.ps1
    
    .DESCRIPTION
        Show-RedditOAuthWindow Function
#>
[CmdletBinding()]
param()

function Show-RedditOAuthWindow {
    [CmdletBinding(
        ConfirmImpact = 'Low',
        HelpUri = 'https://psraw.readthedocs.io/en/latest/PrivateFunctions/Show-RedditOAuthWindow',
        SupportsShouldProcess = $true
    )]
    [OutputType([System.Uri])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$RedirectUri
    )
    
    process {
        If (-not $PSCmdlet.ShouldProcess($Url)) {
            return
        }
        $Params = @{
            TypeName = 'System.Windows.Forms.Form'
            Property = @{
                Width  = 440
                Height = 640
            }
        }
        $Form = New-Object @Params
        $Params = @{
            TypeName = 'System.Windows.Forms.WebBrowser'
            Property = @{
                Width  = 420
                Height = 600
                Url    = $Url
            }
        }
        $Web = New-Object @Params
        # Close the form when the returned to the RedirectURI
        $DocumentCompleted_Script = {
            if ($web.Url.AbsoluteUri -like "$RedirectUri*") {
                $form.Close()
            }
        }
        $web.ScriptErrorsSuppressed = $false
        $web.Add_DocumentCompleted($DocumentCompleted_Script)
        $form.Controls.Add($web)
        $form.Add_Shown( { $form.Activate() })
        [void]$form.ShowDialog()
        # Return a copy of the resulting URL
        $web.Url.psobject.copy()
        [void]$form.Close()
        [void]$Web.Dispose()
        [void]$Form.Dispose()
    }
}
    