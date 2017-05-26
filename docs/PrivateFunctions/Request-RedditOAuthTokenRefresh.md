---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenRefresh
schema: 2.0.0
---

# Request-RedditOAuthTokenRefresh

## SYNOPSIS
Request a new Access Token using a Refresh Token

## SYNTAX

```
Request-RedditOAuthTokenRefresh [-AccessToken] <RedditOAuthToken> [[-AuthBaseUrl] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit using the `refresh_token` grant flow. Only `RedditOAuthToken` Access Tokens requested using the `code` grant flow can use this method. This works be sending the `refresh_token` stored in the `RefreshCredential` property of the `RedditOAuthToken` object to request a new Access token.

This function is essentially a convenience wrapper for `Invoke-WebRequest` and returns a `Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject` that results from the Auth Token Request.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Params = @{
    AccessToken = $Token
}  
$Result = Request-RedditOAuthTokenRefresh @Params
```

This example demonstrates how `Update-RedditOAuthToken` calls `Request-RedditOAuthTokenRefresh` to request an OAuth Access Token.

## PARAMETERS

### -AccessToken
The `RedditOAuthToken` to to refresh. Must have a `GrantType` of `Authorization_Code`

```yaml
Type: RedditOAuthToken
Parameter Sets: (All)
Aliases: Token

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

### RedditOAuthToken

## OUTPUTS

### Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject

## NOTES
This function calls

* [Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/Module/Get-AuthorizationHeader)

This function is called by

* [Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenRefresh](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenRefresh)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthCode](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthCode)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://github.com/reddit/reddit/wiki/OAuth2#authorization](https://github.com/reddit/reddit/wiki/OAuth2#authorization)