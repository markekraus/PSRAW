<#	
	
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.139
	 Created on:   	4/23/2017 9:22 AM
	 Created by:   	Mark Kraus
	 Organization: 	
	 Filename:     	PSRAW.psd1
	 -------------------------------------------------------------------------
	 Module Manifest
	-------------------------------------------------------------------------
	 Module Name: PSRAW
	
#>


@{
	
    # Script module or binary module file associated with this manifest
    RootModule             = 'PSRAW.psm1'
	
    # Version number of this module.
    ModuleVersion          = '1.0.14.1'
	
    # ID used to uniquely identify this module
    GUID                   = '92c8f916-4890-45eb-a3e7-592f5b5b3f24'
	
    # Author of this module
    Author                 = 'Mark Kraus'
	
    # Company or vendor of this module
    CompanyName            = ''
	
    # Copyright statement for this module
    Copyright              = '(c) 2017. All rights reserved.'
	
    # Description of the functionality provided by this module
    Description            = 'PowerShell Reddit API Wrapper. See the project site at https://github.com/markekraus/PSRAW and the documentation at https://psmsgraph.readthedocs.io/'
	
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.0'
	
    # Name of the Windows PowerShell host required by this module
    PowerShellHostName     = ''
	
    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion  = ''
	
    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = '2.0'
	
    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion             = '2.0.50727'
	
    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture  = 'None'
	
    # Modules that must be imported into the global environment prior to importing
    # this module
    RequiredModules        = @()
	
    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies     = @('System.Web', 'System.Windows.Forms')
	
    # Script files (.ps1) that are run in the caller's environment prior to
    # importing this module
    ScriptsToProcess       = @('Enums\RedditApplicationType.ps1','Enums\RedditOAuthDuration.ps1','Enums\RedditOAuthGrantType.ps1','Enums\RedditOAuthResponseType.ps1','Classes\001-RedditOAuthScope.ps1','Classes\002-RedditApplication.ps1','Classes\003-RedditOAuthCode.ps1','Classes\004-RedditOAuthToken.ps1','Classes\005-RedditApiResponse.ps1')
	
    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess         = @()
	
    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @()
	
    # Modules to import as nested modules of the module specified in
    # ModuleToProcess
    NestedModules          = @()
	
    # Functions to export from this module
    FunctionsToExport      = @('Invoke-RedditRequest','Export-RedditApplication','Import-RedditApplication','New-RedditApplication','Export-RedditOAuthToken','Get-RedditOAuthScope','Import-RedditOAuthToken','Request-RedditOAuthToken','Update-RedditOAuthToken')
	
    # Cmdlets to export from this module
    CmdletsToExport        = @()
	
    # Variables to export from this module
    VariablesToExport      = @()
	
    # Aliases to export from this module
    AliasesToExport        = @() 
	
    # List of all modules packaged with this module
    ModuleList             = @()
	
    # List of all files packaged with this module
    FileList               = @()
	
    # Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData            = @{
		
        #Support for PowerShellGet galleries.
        PSData = @{
			
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Reddit', 'API', 'OAuth', 'REST', 'SocialMedia', "Forum", 'Messaging', 'Module', 'PSRAW', 'Class')
			
            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/markekraus/PSRAW/blob/master/LICENSE'
			
            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/markekraus/PSRAW/'
			
            # A URL to an icon representing this module.
            # IconUri = ''
			
            # ReleaseNotes of this module
            ReleaseNotes = '# Version 1.1.0.6 (2017-05-26)
## What''s new?

Everything! This is the initial release of PSRAW so everything is a new feature! Check out the project at https://github.com/markekraus/PSRAW/ and the documentation at https://psraw.readthedocs.io/

This is a "Core Functionality" release. It provides all the components needed to build the rest of the functionality this module will provide. It does not include any of the wrapper functionality, but it is capable of making authenticated API calls in a manner similar to `Invoke-WebRequest`

## Public Functions

### API

#### Invoke-RedditRequest
* Provides authenticated access to the Reddit API in a `Invoke-WebRequest` style.

### Application

#### Export-RedditApplication
* Provides the ability to export `RedditApplication` objects so they can be imported later by `Import-RedditApplication`

#### Import-RedditApplication
* Provides the ability import `RedditApplication` objects previously exported by `Export-RedditApplication`

#### New-RedditApplication
* Creates new `RedditApplication` objects that can be used to request OAuth access to the API.

### OAuth

#### Export-RedditOAuthToken
* Provides the ability to export `RedditOAuthToken` objects so they can be imported later by `Import-RedditPAuthToken`

#### Get-RedditOAuthScope
* Retrieves all valid OAuth Scopes from reddit as `RedditOAuthScope` objects.

#### Import-RedditOAuthToken
* Provides the ability import `RedditOAuthToken` objects previously exported by `Export-RedditOAuthToken`

#### Request-RedditOAuthToken
* Provides the ability to request OAuth Authorization and Access Tokens for all Grant Flows supported by reddit. Creates new `RedditOAuthToken` objects.

#### Update-RedditOAuthToken
* Provides lifecycle management of OAuth Access Tokens stored in `RedditOAuthToken` objects and perms refresh or re-grant operations when they expire.

## Classes

PSRAW Classes automatically become available in the calling scope when the module is Imported!

### Api

#### RedditApiResponse
* Used for API responses from `Invoke-RedditRequest`

### Application

### RedditApplication
* Models an Application as it is registered on Reddit and used to request `RedditOAuthToken` objects

### OAuth

### RedditOAuthCode
* Returned by the `Request-RedditOAuthCode` private function used in `Code` grant flows for OAuth. Provides a secure means of temporarily storing the Authentication Code.

### RedditOAuthScope
* Models the Reddit OAuth Scopes available for the Reddit API.

### RedditOAuthToken
* Houses the authorized `RedditApplication`, the OAuth Access Token and Refresh Token (if present) and used to authenticated to the Reddit API.

## Enums

PSRAW Enums automatically become available in the calling scope when the module is Imported!

### Application

### RedditApplicationType
* provides the available types for `RedditApplication` objects

### OAuth

### RedditOAuthDuration
* provides the available OAuth Duration types.

### RedditOAuthGrantType
* Provides the available OAuth Grant Flow Types.

### RedditOAuthResponseType
* Provides the available OAuth Response Types to request.

## Help

Help topics are available for all public functions, classes and Enums! Examples:

`Get-Help Invoke-RedditRequest`

`Get-Help about_RedditOAuthToken`

`Get-Help about_RedditApplicationType`

All functions (public and private) and all classes and enums are also documented online at https://psraw.readthedocs.io/

## Private Functions

### API

`Wait-RedditApiRateLimit` provides Rate Limit cooldown.

### OAuth

The following functions have been added to deal with OAuth Grant flow in the function name

* `Request-RedditOAuthTokenClient`
* `Request-RedditOAuthTokenCode`
* `Request-RedditOAuthTokenImplicit`
* `Request-RedditOAuthTokenInstalled`
* `Request-RedditOAuthTokenPassword`
* `Request-RedditOAuthTokenRefresh`

`Get-AuthorizationHeader` provides the rfc2617 Authorization header required by Reddit for OAuth Access Token requests.

`Request-RedditOAuthCode` is used to request Authorization codes in `Code grant flows.

`Show-RedditOAuthWindows` provides a `WinForms` GUI browser for the Grant Flows that require the user to log i to the site and authorize the application.'
			
        } # End of PSData hashtable
		
    } # End of PrivateData hashtable
}















