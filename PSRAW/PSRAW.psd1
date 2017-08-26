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
    ModuleVersion          = '2.0.0.5'
	
    # ID used to uniquely identify this module
    GUID                   = '92c8f916-4890-45eb-a3e7-592f5b5b3f24'
	
    # Author of this module
    Author                 = 'Mark Kraus'
	
    # Company or vendor of this module
    CompanyName            = ''
	
    # Copyright statement for this module
    Copyright              = '(c) 2017. All rights reserved.'
	
    # Description of the functionality provided by this module
    Description            = 'PowerShell Reddit API Wrapper. See the project site at https://github.com/markekraus/PSRAW and the documentation at https://psraw.readthedocs.io/'
	
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
    RequiredAssemblies     = @()
	
    # Script files (.ps1) that are run in the caller's environment prior to
    # importing this module
    ScriptsToProcess       = @('Enums\RedditApplicationType.ps1','Enums\RedditOAuthDuration.ps1','Enums\RedditOAuthGrantType.ps1','Enums\RedditOAuthResponseType.ps1','Enums\RedditThingKind.ps1','Enums\RedditThingPrefix.ps1','Classes\001-RedditOAuthScope.ps1','Classes\002-RedditApplication.ps1','Classes\003-RedditOAuthResponse.ps1','Classes\004-RedditOAuthToken.ps1','Classes\005-RedditApiResponse.ps1','Classes\006-RedditDataObject.ps1','Classes\006-RedditDate.ps1','Classes\007-RedditThing.ps1','Classes\008-RedditHeaderSize.ps1','Classes\008-RedditModReport.ps1','Classes\008-RedditUserReport.ps1','Classes\009-RedditComment.ps1','Classes\009-RedditLink.ps1','Classes\011-RedditSubmission.ps1','Classes\012-RedditSubreddit.ps1','Classes\013-RedditMore.ps1','Classes\014-RedditListing.ps1')
	
    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess         = @()
	
    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @()
	
    # Modules to import as nested modules of the module specified in
    # ModuleToProcess
    NestedModules          = @()
	
    # Functions to export from this module
    FunctionsToExport      = @('Invoke-RedditRequest','Resolve-RedditDataObject','Export-RedditApplication','Import-RedditApplication','New-RedditApplication','Connect-Reddit','Export-RedditOAuthToken','Get-RedditDefaultOAuthToken','Get-RedditOAuthScope','Import-RedditOAuthToken','Request-RedditOAuthToken','Set-RedditDefaultOAuthToken','Update-RedditOAuthToken')
	
    # Cmdlets to export from this module
    CmdletsToExport        = @()
	
    # Variables to export from this module
    VariablesToExport      = @()
	
    # Aliases to export from this module
    AliasesToExport        = @('irr') 
	
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
            IconUri      = 'http://i.imgur.com/4BCLgcx.png'
			
            # ReleaseNotes of this module
            ReleaseNotes = '# Version 2.0.0.1 (2017-08-13)
## Module Manifest

* All `RequiredAssemblies` have been removed

## Root Module

* Added `$PSDefaultParameterValues` for `Invoke-WebRequest` to set `-SkipHeaderValidation` if available (for backwards compatibility with 5.1)
* Added `$PsrawSettings` module scope hashtable variable to house settings such as the session default OAuth token.

## Public Functions

### Connect-Reddit

* Added to Streamline and simplify the initial OAUth process.

### Export-RedditOAuthToken

* All parameters are no longer mandatory to accommodate exporting the default token to its default path

### Get-RedditDefaultOAuthToken

* Added to retrieve the Default token for the session

### Import-RedditOAuthToken

* Now returns nothing by default. Use `-PassThru` to return the imported token
* Sets the imported token as the session default Token.

### Invoke-RedditRequest

* Now has `irr` alias to mimic `iwr` and `irm` aliases.
* `Invoke-WebRequest` error handling logic reworked to support 5.1 and 6.0
* Access token is no longer mandatory and uses the session default AccessToken if one is not supplied

### New-RedditApplication

* Default Parameter Set changed to `Script`
* `Name` parameter is no longer Mandatory to simplify connecting
* `Scope` parameter  has been deprecated and is no longer Mandatory
* `UserAgent` no longer mandatory. default is now `PowerShell:PSRAW:2.0 (by /u/markekraus)`


### Request-RedditOAuthToken

* Now returns nothing by default. Use `-PassThru` to return the token
* Sets the retrieved token as the session default token.
* `Code` and `Implicit` parameter sets have been removed.
* `Code` and `Implicit` parameters have been removed
* `Code` and `Implicit` grants flows have been removed
* `State` parameter has been removed (was only required for Implicit grants)

### Set-RedditDefaultOAuthToken

* Added to set the session default token

### Update-RedditOAuthToken

* `-AccessToken` is no longer mandatory and the default is the session default token
* `Code` and `Implicit` grants flows have been removed
* `-SetDefault` switch added to set the updated token as the session default token.

## Private Functions

### Get-HttpResponseContentType

* Added `Get-HttpResponseContentType` to get API response `Content-Type` as 6.0 and 5.1 currently house this in different locations.

### Request-RedditOAuthCode

* Removed `Request-RedditOAuthCode` as it is no needed without Code grant flow

### Request-RedditOAuthTokenClient

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenCode

* Removed `Request-RedditOAuthTokenCode` as it is not needed without Code grant flow

### Request-RedditOAuthTokenImplicit

* Removed `Request-RedditOAuthTokenImplicit` as it is not needed without Implicit grant flow

### Request-RedditOAuthTokenInstalled

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenPassword

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenRefresh

* Removed `Request-RedditOAuthTokenRefresh` as it is no longer needed without Code grant flow

### Show-RedditOAuthWindow

* Removed `Show-RedditOAuthWindow` as it is not compatible with Core (this is why Code and Implicit grant flows are no longer available)

## Classes

### RedditApplication

* `Scope` is now hidden as it serves no purpose without Code grant flows.
* Removed `GetAuthorizationUrl()` and `_GetAuthorizationUrl()` as they depended on `System.Web` (not available in Core) and are not needed without the Code or Implicit grant flows.

### ReditOAuthCode

* This class has been deleted as it is not needed without the Code grant flow.

### RedditOAuthResponse

* Created `RedditOAuthResponse` class to abstract the OAuth response from Reddit.

### RedditOAuthToken

* Removed RefreshCredential (not needed without Code grant flow)
* Constructors now take a `RedditOAuthResponse` instead of a `PSobject` and the code adjusted to use its properties
* `GetRefreshToken()` Removed (not needed without Code grant flow)
* `Refresh()` now takes a `RedditOAuthResponse`
* `UpdateRateLimit()` adjusted to support both 5.1 and 6.0 style headers dictionaries.
* Default constructor now sets the GUID to `[GUID]:Empty`

### RedditApiResponse

* `Response` and `ContentObject` are now appropriately typed
* Added `ContentType`property to hold the `Content-Type` information

### RedditDate

* Added `RedditDate` class to handle unix-to-date and date-to-unix translations for dates returned from the API.

### RedditThing

* Added `RedditThing` class to work with "Reddit Things" returned from the Reddit API

### RedditModReport

* Added `RedditModReport` to house moderator reports

### RedditUserReport

* Added `RedditUserReport` to house user reports

### RedditComment

* Added `RedditComment` to house comments.

## Enums

### RedditOAuthGrantType

* Removed `Authorization_Code`, `Refresh_Token`, and `Implicit` which are not needed without Code and Implicit grant flows

### RedditThingKind

* Added `RedditThingKind` to Define "Reddit Thing" "Kind" (their terms, not mine)

### RedditThingPrefix

* Added `RedditThingPrefix` to define valid prefixes for "Reddit Things"'
			
        } # End of PSData hashtable
		
    } # End of PrivateData hashtable
}















