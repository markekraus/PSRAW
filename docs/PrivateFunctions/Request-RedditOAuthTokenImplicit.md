---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit
schema: 2.0.0
---

# Request-RedditOAuthTokenImplicit

## SYNOPSIS
Requests an `Implicit` OAuth Access Token from reddit.

## SYNTAX

```
Request-RedditOAuthTokenImplicit [-Application] <RedditApplication> [[-State] <String>]
 [[-AuthBaseUrl] <String>] [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit using the `implicit` grant flow. This method allows `Installed` apps to obtain an OAuth Access token allowing tha pplication to act on behalf of a user. For more information see the `Implicit` parameter description for `Request-RedditOAuthToken`.

This function calls `Show-RedditOAuthWindow` and returns the results as a `System.Uri`

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Params = @{
    Application = $Application
    State       = $State
}  
$Result = Request-RedditOAuthTokenImplicit @Params
```

This example demonstrates how `Request-RedditOAuthToken` calls `Request-RedditOAuthTokenImplicit` to request an OAuth Access Token.

## PARAMETERS

### -Application
The `RedditApplication` Object for the Application that will be used to request the OAuth Access Token. Only `Installed` applications will be allowed.

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
Optional parameter for the Base URL to request the Access OAuth Token from. The default is to use `[RedditApplication]::AuthBaseURL`

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

### -State
Optional parameter for the `state` to use when requesting the OAuth Authorization Code.

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

### System.Uri

## NOTES
This function calls

* [Show-RedditOAuthWindow](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Show-RedditOAuthWindow)

This function is called by

* [Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Show-RedditOAuthWindow](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Show-RedditOAuthWindow)

[https://github.com/reddit/reddit/wiki/OAuth2#token-retrieval-implicit-grant-flow](https://github.com/reddit/reddit/wiki/OAuth2#token-retrieval-implicit-grant-flow)