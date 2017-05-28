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
    ModuleVersion          = '1.0.15.0'
	
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
    RequiredAssemblies     = @('System.Web', 'System.Windows.Forms')
	
    # Script files (.ps1) that are run in the caller's environment prior to
    # importing this module
    ScriptsToProcess       = @('Enums\RedditApplicationType.ps1', 'Enums\RedditOAuthDuration.ps1', 'Enums\RedditOAuthGrantType.ps1', 'Enums\RedditOAuthResponseType.ps1', 'Classes\001-RedditOAuthScope.ps1', 'Classes\002-RedditApplication.ps1', 'Classes\003-RedditOAuthCode.ps1', 'Classes\004-RedditOAuthToken.ps1', 'Classes\005-RedditApiResponse.ps1')
	
    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess         = @()
	
    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @()
	
    # Modules to import as nested modules of the module specified in
    # ModuleToProcess
    NestedModules          = @()
	
    # Functions to export from this module
    FunctionsToExport      = @('Invoke-RedditRequest', 'Export-RedditApplication', 'Import-RedditApplication', 'New-RedditApplication', 'Export-RedditOAuthToken', 'Get-RedditOAuthScope', 'Import-RedditOAuthToken', 'Request-RedditOAuthToken', 'Update-RedditOAuthToken')
	
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
            IconUri      = 'http://i.imgur.com/4BCLgcx.png'
			
            # ReleaseNotes of this module
            ReleaseNotes = '# Version 1.1.0.7 (2017-05-27)
## Module Manifest
* Cleaned up PSMSGraph Reference
* Added PSRAW Icon'
			
        } # End of PSData hashtable
		
    } # End of PrivateData hashtable
}















