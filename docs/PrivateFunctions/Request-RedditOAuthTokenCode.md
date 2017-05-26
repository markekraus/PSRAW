---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode
schema: 2.0.0
---

# Request-RedditOAuthTokenCode

## SYNOPSIS
Requests a `Code` OAuth Access Token from reddit.

## SYNTAX

```
Request-RedditOAuthTokenCode [-Application] <RedditApplication> [[-State] <String>] [[-AuthBaseUrl] <String>]
 [[-AuthCodeBaseUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit using the `code` grant flow. This function will first call `Request-RedditOAuthCode` to retrieve `RedditOAuthCode` object. This code is then used to request an OAuth Access Token. For more information see the `Code` parameter description for `Request-RedditOAuthToken`.

This function is essentially a convenience wrapper for `Invoke-WebRequest` and returns a `Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject` that results from the Auth Token Request.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Params = @{
    Application = $Application
    State       = $State
}  
$Result = Request-RedditOAuthTokenCode @Params
```

This example demonstrates how `Request-RedditOAuthToken` calls `Request-RedditOAuthTokenCode` to request an OAuth Access Token.

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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthCodeBaseUrl
Optional parameter for the base URL to use for requesting the OAuth Authorization Code. This is passed to `Request-RedditOAuthCode` as the `AuthBaseUrl` parameter. The default is `[RedditApplication]::AuthBaseURL`

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Optional parameter for the `state` to use when requesting the OAuth Authorization Code. This will be passed to as the `State` parameter to `Request-RedditOAuthCode`. The default is to generate a new `Guid`.

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

### RedditOAuthCode

## OUTPUTS

### Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject

## NOTES
This function calls

* [Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)
* [Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)

This function is called by

* [Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthCode](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthCode)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[https://github.com/reddit/reddit/wiki/OAuth2#authorization](https://github.com/reddit/reddit/wiki/OAuth2#authorization)