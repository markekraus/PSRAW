<#	
    .NOTES
    ===========================================================================
     Created with:  VSCode
     Created on:    4/26/2017 04:40 AM
     Edited on:     4/28/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      New-RedditApplication.ps1
    ===========================================================================
    .DESCRIPTION
        New-RedditApplication Function
#>
Using Module '..\..\Enums\RedditApplicationType.psm1'
Using Module '..\..\Classes\RedditScope.psm1'
Using Module '..\..\Classes\RedditApplication.psm1'
<#
    .SYNOPSIS
        Creates a RedditApplication object
    
    .DESCRIPTION
        Creates a RedditApplication object containing data used by various cmdltes to define the parameters 
        of the App registered on Reddit. This does not make any calls to Reddit or perform any online lookups. 
    
    .PARAMETER Script
        Use if the Reddit App is registered as a Script.
    
    .PARAMETER WebApp
        Use if the Reddit App is registered as a WebApp
    
    .PARAMETER Installed
        Use if Reddit App is registered as an Installed App.
    
    .PARAMETER Name
        Name of the Reddit App. This does not need to match the name registered on Reddit. It is used for 
        convenient identification and ducomentation purposes only.
    
    .PARAMETER ClientCredential
        A PScredential object containging the Client ID as the Username and the Client Secret as the password. 
        For 'Installed' Apps which have no Client Secret, the password will be ignored.
    
    .PARAMETER RedirectUri
        Redirect URI as registered on Reddit for the App. This must match exactly as entered in the App definition 
        or authentication will fail.
    
    .PARAMETER UserAgent
        The User-Agent header that will be used for all Calls to Reddit. This should be in the following format:
        
        <platform>:<app ID>:<version string> (by /u/<reddit username>)
        
        Example:
        
        windows:PSRAW:v0.0.0.1 (by /u/makrkeraus)
    
    .PARAMETER Scope
        Array of ReditScopes that this Reddit App requires. You can see the available scopes with Get-ReddOauthScope
    
    .PARAMETER Description
        Description of the Reddit App. This is not required or used for anything. It is provided for convenient 
        identification and documentation purposes only.
    
    .PARAMETER UserCredential
        PScredential containing the Reddit Username and Password for the Developer of a Script App.
    
    .PARAMETER GUID
        A GUID to identify the application. If one is not perovided, a new GUID will be generated.
    
    .EXAMPLE
        PS C:\> $ClientCredential = Get-Credential
        PS C:\> $Scope = Get-RedditOAuthScope | Where-Object {$_.Scope -like '*wiki*'} 
        PS C:\> $Params = @{
            WebApp = $True
            Name = 'Connect-Reddit'
            Description = 'My Reddit Bot!'
            ClientCredential = $ClientCredential
            RedirectUri = 'https://adataum/ouath?'
            UserAgent = 'windows:connect-reddit:v0.0.0.1 (by /u/makrkeraus)'
            Scope = $Scope
        }
        PS C:\> $RedditApp = New-RedditApplication @Params

    .EXAMPLE
        PS C:\> $ClientCredential = Get-Credential
        PS C:\> $UserCredential = Get-Credential
        PS C:\> $Scope = Get-RedditOAuthScope | Where-Object {$_.Scope -like '*wiki*'} 
        PS C:\> $Params = @{
            Script = $True
            Name = 'Connect-Reddit'
            Description = 'My Reddit Bot!'
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
            RedirectUri = 'https://adataum/ouath?'
            UserAgent = 'windows:connect-reddit:v0.0.0.1 (by /u/makrkeraus)'
            Scope = $Scope
        }
        PS C:\> $RedditApp = New-RedditApplication @Params

        .EXAMPLE
        PS C:\> $ClientCredential = Get-Credential
        PS C:\> $Scope = Get-RedditOAuthScope | Where-Object {$_.Scope -like '*wiki*'} 
        PS C:\> $Params = @{
            Installed = $True
            Name = 'Connect-Reddit'
            Description = 'My Reddit Bot!'
            ClientCredential = $ClientCredential
            RedirectUri = 'https://adataum/ouath?'
            UserAgent = 'windows:connect-reddit:v0.0.0.1 (by /u/makrkeraus)'
            Scope = $Scope
        }
        PS C:\> $RedditApp = New-RedditApplication @Params

    .OUTPUTS
        RedditApplication
    
    .NOTES
        For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:
            https://github.com/reddit/reddit/wiki/API
            https://github.com/reddit/reddit/wiki/OAuth2
            https://www.reddit.com/prefs/apps
            https://www.reddit.com/wiki/api

    .LINK
        https://psraw.readthedocs.io/en/latest/functions/New-RedditApplication
    
    .LINK
        https://psraw.readthedocs.io/en/latest/functions/Get-ReddOauthScope

    .LINK
        https://github.com/reddit/reddit/wiki/API
    
    .LINK
        https://github.com/reddit/reddit/wiki/OAuth2
        
    .LINK
        https://www.reddit.com/prefs/apps
        
    .LINK
        https://www.reddit.com/wiki/api
#>
function New-RedditApplication {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSUseShouldProcessForStateChangingFunctions", "", Justification = "Creates in-memory object only.")]
    [CmdletBinding(DefaultParameterSetName = 'WebApp',
                   ConfirmImpact = 'None',
                   HelpUri = 'https://psraw.readthedocs.io/en/latest/functions/New-RedditApplication')]
    [OutputType([RedditApplication])]
    param
    (
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [switch]$Script,
        
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [switch]$WebApp,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [switch]$Installed,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('AppName')]
        [string]$Name,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [Alias('ClientInfo')]
        [System.Management.Automation.PSCredential]$ClientCredential,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [uri]$RedirectUri,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserAgent,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [RedditScope[]]$Scope,
        
        [Parameter(ParameterSetName = 'Installed',
                   Mandatory = $false)]
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $false)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $false)]
        [string]$Description,
        
        [Parameter(ParameterSetName = 'Script',
                   Mandatory = $true)]
        [Parameter(ParameterSetName = 'WebApp',
                   Mandatory = $false)]
        [Alias('Credential')]
        [System.Management.Automation.PSCredential]$UserCredential,
        
        [Parameter(ParameterSetName = 'Installed')]
        [Parameter(ParameterSetName = 'Script')]
        [Parameter(ParameterSetName = 'WebApp')]
        [System.Guid]$GUID = [guid]::NewGuid()
    )
    
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'Installed' {
                $AppType = [RedditApplicationType]::Installed
                $UserCredential = [System.Management.Automation.PSCredential]::Empty
                break
            }
            'WebApp' {
                $AppType = [RedditApplicationType]::WebApp
                $UserCredential = [System.Management.Automation.PSCredential]::Empty
                break
            }
            'Script' {
                $AppType = [RedditApplicationType]::Script
                break
            }
        }
       
        [RedditApplication]@{
            Name = $Name
            Description = $Description
            Type = $AppType
            UserAgent = $UserAgent
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
            RedirectUri = $RedirectUri
            Scope = $Scope
            GUID = $GUID
        }
    }
}
