---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled
schema: 2.0.0
---

# Request-RedditOAuthTokenInstalled

## SYNOPSIS
Requests an `Installed` OAuth Access Token from reddit.

## SYNTAX

```
Request-RedditOAuthTokenInstalled [-Application] <RedditApplication> [[-DeviceID] <String>]
 [[-AuthBaseUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit using the `installed_client` grant flow. This method allows `Installed` applications to gain anonymous unprivileged access to the OAuth APIs using only the application's Client ID and a Device ID. For more information on this grant method see the `Installed` parameter description for `Request-RedditOAuthToken`.

This function is essentially a convenience wrapper for `Invoke-WebRequest` and returns a `Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject` that results from the Auth Token Request.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Params = @{
    Application = $Application
    DeviceID    = $DeviceID
}  
$Result = Request-RedditOAuthTokenInstalled @Params
```

This example demonstrates how `Request-RedditOAuthToken` calls `Request-RedditOAuthTokenInstalled` to request an OAuth Access Token.

## PARAMETERS

### -Application
The `RedditApplication` Object for the Application that will be used to request the OAuth Access Token. Any application type can use this method.

```yaml
Type: RedditApplication
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AuthBaseUrl
Optional parameter for the Base URL to request the Access OAuth Token from. The default is to use `[RedditOAuthToken]::AuthBaseURL`

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceID
Optional Device ID parameter to use in the request. The default is to generate a new `Guid`. For more details see the `DeviceID` parameter description on `Request-RedditOAuthToken`

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditApplication

## OUTPUTS

### Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject

## NOTES
This function is called by

* [Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)
* [Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

This Function calls 

* [Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth](https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth)