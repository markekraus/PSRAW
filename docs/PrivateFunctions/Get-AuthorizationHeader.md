---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-AuthorizationHeader
schema: 2.0.0
---

# Get-AuthorizationHeader

## SYNOPSIS
Returns an rfc2617 Authorization header

## SYNTAX

```
Get-AuthorizationHeader [-Credential] <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
Private Function that converts the provided `PSCredential` in to a rfc2617 Authorization header. Reddit's API requires `Basic` `Authorization` when requesting certain Access Token types. PowerShell does not support this method directly via `Invoke-WebRequest` or `Invoke-RestMethod`, therefore this function provides that missing functionality. This is not the same header sent when using the `Credential` parameter on either command.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> $AuthHeader = $Application.ClientCredential | Get-AuthorizationHeader
```

This example demonstrates how the `Request-RedditOAuthTokenCode` function uses `Get-AuthorizationHeader` to generate an authorization header to send in the Access Token request.

## PARAMETERS

### -Credential
The `PSCredential` object from which to create the Authorization header.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PSCredential

## OUTPUTS

### System.String

## NOTES
This function is used in the following functions:

* [Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)
* [Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)
* [Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)
* [Request-RedditOAuthTokenPassword](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenPassword)

## RELATED LINKS

[Get-AuthorizationHeader](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-AuthorizationHeader)

[Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)

[Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)

[Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)

[Request-RedditOAuthTokenPassword](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenPassword)

[https://tools.ietf.org/html/rfc2617#section-2](https://tools.ietf.org/html/rfc2617#section-2)

[https://github.com/reddit/reddit/wiki/OAuth2#retrieving-the-access-token](https://github.com/reddit/reddit/wiki/OAuth2#retrieving-the-access-token)