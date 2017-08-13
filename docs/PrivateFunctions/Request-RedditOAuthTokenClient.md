---
external help file: 
Module Name: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient
schema: 2.0.0
---

# Request-RedditOAuthTokenClient

## SYNOPSIS
Requests a `Client` OAuth Access Token from reddit.

## SYNTAX

```
Request-RedditOAuthTokenClient [-Application] <RedditApplication> [[-AuthBaseUrl] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit using the `client_credentials` grant flow. This method allows `Script` and `WebApp` applications to gain anonymous unprivileged access to the OAuth APIs using only the application's Client ID and Client Secret. For more information on this grant method see the `Client` parameter description for `Request-RedditOAuthToken`.

This function is essentially a convenience wrapper for `Invoke-WebRequest` and returns a `RedditOAuthResponse` that results from the Auth Token Request.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Result = Request-RedditOAuthTokenClient -Application $Application
```

This example demonstrates how `Request-RedditOAuthToken` calls `Request-RedditOAuthTokenClient` to request an OAuth Access Token.

## PARAMETERS

### -Application
The `RedditApplication` Object for the Application that will be used to request the OAuth Access Token. Only `Script` and `WebApp` applications will be allowed.

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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditApplication

## OUTPUTS

### RedditOAuthResponse

## NOTES
This function is called by

* [Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)
* [Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

This Function calls 

* [Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)
* [Get-HttpResponseContentType](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-HttpResponseContentType)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)

[RedditOAuthResponse](https://psraw.readthedocs.io/en/latest/Module/RedditOAuthResponse)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth](https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth)