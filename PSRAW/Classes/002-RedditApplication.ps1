<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    4/26/2017 3:37 PM
     Edited on:     5/10/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      002-RedditApplication.ps1
    
    .DESCRIPTION
        RedditApplication Class
#>

Class RedditApplication {
    [String]$Name
    [String]$Description
    [uri]$RedirectUri
    [String]$UserAgent
    [RedditApplicationType]$Type
    [String]$ClientID
    [guid]$GUID = [guid]::NewGuid()
    [string]$ExportPath
    [String]$ScriptUser
    [RedditOAuthScope[]]$Scope
    hidden [System.Management.Automation.PSCredential]$ClientCredential
    hidden [System.Management.Automation.PSCredential]$UserCredential
    static [string]$AuthBaseURL = 'https://www.reddit.com/api/v1/authorize.compact'
    
    #Default constructor provided for compatibility only
    RedditApplication () {
        throw [System.NotImplementedException]::New()
    }

    #Hashtable Coverter
    RedditApplication ([System.Collections.Hashtable]$InitHash) {
        $This._init($InitHash)
    }

    #PSObject Converter
    RedditApplication ([PSObject] $PSObject){
        $InitHash = @{}
        Foreach($Property in $PSObject.PSObject.properties.Name){
            $InitHash[$Property] = $PSObject.$Property
        }
        $This._init($InitHash)
    }

    RedditApplication ([Object] $Object){
        $InitHash = @{}
        Foreach($Property in $Object.PSObject.properties.Name){
            $InitHash[$Property] = $Object.$Property
        }
        $This._init($InitHash)
    }

    RedditApplication (
        [String]$Name,
        [String]$Description,
        [uri]$RedirectUri,
        [String]$UserAgent,
        [RedditApplicationType]$Type,
        [guid]$GUID,
        [string]$ExportPath,
        [RedditOAuthScope[]]$Scope,
        [System.Management.Automation.PSCredential]$ClientCredential,
        [System.Management.Automation.PSCredential]$UserCredential
    ) {
        $This._init(@{
            Name = $Name
            Description = $Description
            RedirectUri = $RedirectUri
            UserAgent = $UserAgent
            Type = $Type
            GUID = $GUID
            ExportPath = $ExportPath
            Scope = $Scope
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
        })
    }

    hidden [void] _init ([System.Collections.Hashtable]$InitHash){
        if(-not (
                $InitHash.Type.toString() -and $InitHash.ClientCredential -and 
                $InitHash.RedirectUri -and $InitHash.UserAgent -and $InitHash.Scope
            )){
            throw [System.ArgumentException]::New(
                "'Type', 'ClientCredential', 'UserAgent', 'Scope', and 'RedirectUri' are required."
            )
        }
        if($InitHash.Type -like 'Script' -and -not $InitHash.UserCredential){
            throw [System.ArgumentException]::New(
                "'UserCredential' required for 'Script' type"
            )
        }
        foreach($Item in $InitHash.GetEnumerator()){
            $This.$($Item.name) = $Item.Value
        }
        $This.ClientID = $This.ClientCredential.UserName
        if($This.Type -eq [RedditApplicationType]::Script){
            $This.ScriptUser = $This.UserCredential.UserName
        }
        else{
            $This.ScriptUser = $This.ClientID
        }
    }

    [string] GetClientSecret () {
        Return $This.ClientCredential.GetNetworkCredential().Password
    }

    [string] GetUserPassword () {
        Return $This.UserCredential.GetNetworkCredential().Password
    }

    [string] GetAuthorzationUrl(){
        Return $This._GetAuthorzationUrl(
            [RedditOAuthResponseType]::Code,
            [RedditOAuthDuration]::Permanent,
            [guid]::NewGuid().toString(),
            [RedditApplication]::AuthBaseURL
        )
    }

    [string] GetAuthorzationUrl(
        [RedditOAuthResponseType]$ResponseType, 
        [RedditOAuthDuration]$Duration
    ){
        Return $This._GetAuthorzationUrl(
            $ResponseType,
            $Duration,
            [guid]::NewGuid().toString(),
            [RedditApplication]::AuthBaseURL
        )
    }

    [string] GetAuthorzationUrl(
        [RedditOAuthResponseType]$ResponseType, 
        [RedditOAuthDuration]$Duration,
        [String]$State
    ){
            Return $This._GetAuthorzationUrl(
                $ResponseType,
                $Duration,
                $State,
                [RedditApplication]::AuthBaseURL
            )
    }

    [string] GetAuthorzationUrl(
        [RedditOAuthResponseType]$ResponseType, 
        [RedditOAuthDuration]$Duration,
        [String]$State,
        [String]$AuthBaseURL
    ){
            Return $This._GetAuthorzationUrl(
                $ResponseType,
                $Duration,
                $State,
                $AuthBaseURL
            )
    }

    hidden [string] _GetAuthorzationUrl(
        [RedditOAuthResponseType]$ResponseType, 
        [RedditOAuthDuration]$Duration, 
        [string]$State, 
        [string]$AuthBaseUrl
    ){
        $Query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $Query['client_id'] = $This.ClientId
        $Query['response_type'] = $ResponseType.ToString().ToLower()
        $Query['state'] = $State
        $Query['redirect_uri'] = $This.RedirectUri
        $Query['duration'] = $Duration.ToString().ToLower()
        $Query['scope'] = $This.Scope.Scope -Join ','
        $UrlObj = [System.Uri]$AuthBaseUrl
        $URLBuilder = New-Object -TypeName System.UriBuilder
        $UrlBuilder.Host = $UrlObj.Host
        $UrlBuilder.Scheme = $UrlObj.Scheme
        $UrlBuilder.Port = $UrlObj.Port
        $UrlBuilder.UserName = $($UrlObj.UserInfo -split ':')[0]
        $UrlBuilder.Password = $($UrlObj.UserInfo -split ':')[1]
        $UrlBuilder.Path = $UrlObj.AbsolutePath
        $URLBuilder.Query = $Query.ToString()
        Return $URLBuilder.ToString()
    }
}