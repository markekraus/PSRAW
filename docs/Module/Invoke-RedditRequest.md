---
external help file: PSRAW-help.xml
Module Name: PSRAW
online version: https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest
schema: 2.0.0
---

# Invoke-RedditRequest

## SYNOPSIS
Performs an authenticated API request against the Reddit API.

## SYNTAX

```
Invoke-RedditRequest [-Uri] <Uri> [[-AccessToken] <RedditOAuthToken>] [[-Method] <WebRequestMethod>]
 [[-Body] <Object>] [[-Headers] <IDictionary>] [[-TimeoutSec] <Int32>] [[-ContentType] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
`Invoke-RedditRequest` is the core function of this module. All API requests made to Reddit are done so by calls to `Invoke-RedditRequest`. It can also be used directly in order to obtain raw API responses or to access API functionality that has not yet been provided by this module's wrapper functions.

`Invoke-RedditRequest` Requires a `RedditOAuthToken` in order to perform the authenticated API request. To create `RedditOAuthToken` see the help info for `Request-RedditOAuthToken`.

`Invoke-RedditRequest` is essentially a wrapper for `Invoke-WebRequest` to ease the burden of authentication, Rate Limit monitoring, and Access Token renewal.

`Invoke-RedditRequest` returns a `RedditApiResponse` which contains the `RedditOAuthToken`, The response from the API, and a converted Content Object. The `RedditApiResponse` can then be used to create other module objects or consumed directly.

`irr` is an alias imported for this command.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Connect-Reddit
irr https://oauth.reddit.com/api/v1/me
```

This example shows the quickest way to get up and running on the Reddit API. `irr` is an alias for `Invoke-RedditRequest` similar to `iwr` for `Invoke-WebRequest`.

### -------------------------- EXAMPLE 2 --------------------------
```
Import-RedditOAuthToken 'C:\PSRAW\AccessToken.xml'
$Uri = 'https://oauth.reddit.com/api/v1/me'
$Response = Invoke-RedditRequest -Uri $Uri
```

This example demonstrates how to import a `RedditOAuthToken` that was previously exported with `Export-RedditOAuthToken` and then using that token to make an authenticated API request to `https://oauth.reddit.com/api/v1/me` with `Invoke-RedditRequest`.

The `RedditOAuthToken` does not need to be refreshed before calling `Invoke-RedditRequest`. `Invoke-RedditRequest` will attempt to refresh expired Access Tokens before making any API calls.

This method is similar to what can be done within automation scripts.

### -------------------------- EXAMPLE 3 --------------------------
```
$ClientCredential = Get-Credential
$UserCredential = Get-Credential
$Params = @{
    Script           = $True
    Name             = 'PSRAW Example App'
    Description      = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    UserCredential   = $UserCredential
    RedirectUri      = 'https://adataum/ouath?'
    UserAgent        = 'windows:PSRAW:v0.0.0.1 (by /u/markekraus)'
}
$RedditApp = New-RedditApplication @Params
$RedditApp | Request-RedditOAuthToken -Script
$Uri = 'https://oauth.reddit.com/message/inbox'
$Response = Invoke-RedditRequest -Uri $Uri
$Messages = $response.ContentObject.data.children.data
```

This example demonstrates the entire process from scratch to retrieve messages from the Reddit user's inbox. First a `RedditApplication` is created. The `RedditApplication` is the authorized and a `RedditOAuthToken` is created. `Invoke-RedditRequest` is then used to make an authenticated query to `https://oauth.reddit.com/message/inbox`. The resulting response is then parsed into the `$Messages` variable.

For automation, the creation of the `RedditApplication` and `RedditOAuthToken` are one time actions done in an interactive shell. The `RedditOAuthToken` is then exported once and then re-imported in the actual automation scripts. But this example is provided to show the entire process un broken.

## PARAMETERS

### -AccessToken
The `RedditOAuthToken` created by `Request-RedditOAuthToken` used to make OAuth authenticated calls to Reddit's API and track API Rate Limiting.

```yaml
Type: RedditOAuthToken
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Body
Specifies the body of the API request. The body is the content of the request that follows the headers.

The Body parameter can be used to specify a list of query parameters or specify the content of the response.

When the input is a `GET` request and the body is an `IDictionary` (typically, a hash table), the body is added to the URI as query parameters. For other `GET` requests, the body is set as the value of the request body in the standard `name=value` format.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ContentType
Specifies the content type of the web request. The default is `application/json`.


```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Headers
Specifies the headers of the web request. Enter a hash table or dictionary.

`UserAgent` and `Authorization` will be overwritten.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Method
Specifies the method used for the web request. Valid values are `Default`, `Delete`, `Get`, `Head`, `Merge`, `Options`, `Patch`, `Post`, `Put`, and `Trace`.

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases: 
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TimeoutSec
Specifies how long the request can be pending before it times out. Enter a value in seconds. The default value, 0, specifies an indefinite time-out.

A Domain Name System (DNS) query can take up to 15 seconds to return or time out. If your request contains a host name that requires resolution, and you set TimeoutSec to a value greater than zero, but less than 15 seconds, it can take 15 seconds or more before a WebException is thrown, and your request times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Uri
Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent. This is the reddit API endpoint against which to make the authenticated API request.

This parameter is required.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditOAuthToken

## OUTPUTS

### RedditApiResponse

## NOTES
`Invoke-RedditRequest` uses `Invoke-WebRequest` instead of `Invoke-RestMethod` because Reddit returns Rate Limiting data via response headers. `Invoke-RedditRequest` uses the `UseBasicParsing` parameter when calling `Invoke-WebRequest` so the full DOM will not be available on the `RedditApiResponse` object.

`Invoke-RedditRequest` will automatically wait for Rate Limiting to pass. If a Rate Limit is in effect, a warning will be issued by `Invoke-RedditRequest`. Rate Limit periods vary but are generally 8 minutes. If you are suppressing warnings and `Invoke-RedditRequest` takes several minutes to complete, you may be making too many calls to the API in too short a time. You can check the status of your rate limit with the `IsRateLimited()` method on the `RedditOAuthToken` before making calls to `Invoke-RedditRequest`.

`Invoke-RedditRequest` will attempt to refresh all expired Access Tokens.

Errors encountered when making the API request will be available in the `Response` property on the the exception object.

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)

[about_RedditApiResponse](https://psraw.readthedocs.io/en/latest/Module/about_RedditApiResponse)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthScope)

[Export-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Export-RedditOAuthToken)

[Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
