---
external help file: PSRAW-help.xml
Module Name: PSRAW
online version: https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken
schema: 2.0.0
---

# Request-RedditOAuthToken

## SYNOPSIS
Requests a OAuth Access Token from Reddit and sets it as the session default OAuth Token

## SYNTAX

### Script (Default)
```
Request-RedditOAuthToken [-Script] [-Application] <RedditApplication> [-PassThru] [<CommonParameters>]
```

### Installed
```
Request-RedditOAuthToken [-Installed] [-Application] <RedditApplication> [[-DeviceID] <String>] [-PassThru]
 [<CommonParameters>]
```

### Client
```
Request-RedditOAuthToken [-Client] [-Application] <RedditApplication> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit for the given `RedditApplication` and sets it as the session default OAuth Token. The OAuth Access Token is used by other functions in this module to make authenticated calls tot he Reddit API. For more information on Reddit's OAuth implementation, see https://github.com/reddit/reddit/wiki/OAuth2

A `RedditApplication` object is required to request a `RedditOAutToken`. Once the token has been issued the `RedditApplication` will be added to the `RedditOAuthToken` object as the `Application` property. for mor information see the `about_RedditOAuthToken` help topic.

Reddit provides several different methods for obtaining Access Tokens depending on your needs and required level of access to the API. For more information on each, see the `Client`, `Installed` and `Script` parameter descriptions. For most uses, `Script` will provide the most benefit.

All `RedditOAuthToken` types will automatically refresh when they expire when consumed by functions in this module. You can also manually refresh them using `Update-RedditOAuthToken`.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$RedditApp | Request-RedditOAuthToken -Script
```

### -------------------------- EXAMPLE 3 --------------------------
```
$RedditApp | Request-RedditOAuthToken -Installed -DeviceId 'db470a80-da50-4ae1-9bba-24a1a3454392'
```

### -------------------------- EXAMPLE 4 --------------------------
```
$RedditApp | Request-RedditOAuthToken -Client
```

### -------------------------- EXAMPLE 5 --------------------------
```
$Token = $RedditApp | Request-RedditOAuthToken -Script -PassThru
```

### -------------------------- EXAMPLE 6 --------------------------
```
$ClientCredential = Get-Credential
$UserCredential =  Get-Credential
$Params = @{
    Script           = $True
    Name             = 'Connect-Reddit'
    Description      = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    RedirectUri      = 'https://adataum/ouath?'
    UserAgent        = 'windows:connect-reddit:v0.0.0.1 (by /u/markekraus)'
    UserCredential   = $UserCredential
    OutVariable      = 'RedditApp'
}
$Token = New-RedditApplication @Params | Request-RedditOAuthToken -Script -PassThru
```

This example demonstrates how to create a `RedditApplication` with `New-RedditApplication` and pass it to `Request-RedditOAuthToken` to obtain a `RedditOAuthToken`. The token will be stored in `$Token` and the application will be stored in `RedditApp`.

## PARAMETERS

### -Application
`RedditApplication` object created with either `New-RedditApplication` or `Import-RedditApplication`.

```yaml
Type: RedditApplication
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Client
Best Used for: Anonymous API access for `WebApp` and `Script` applications

The `Client` switch will initiate a `Client_Credentials` grant flow. This Grant type uses only the application's Client ID and Client Secret to request an OAuth Token. This will enable the use of OAuth Based APIs, but since the OAuth Token will not be associated with any user context it will only have "anonymous" access. This is similar to browsing reddit without having a login. You will not be able to send user messages, post comments or submissions, or do anything else that would require an active login session on the web site.

`Client` access tokens expire after 60 minutes. When they are "renewed" a new token is requested from scratch. This can be used in automation as it does not require user input. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

`Client` OAuth Access Tokens can only be issued to `Script` and `WebApp` applications as it requires Client Secret.

For more information on Reddit's OAuth implementation, see https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

```yaml
Type: SwitchParameter
Parameter Sets: Client
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceID
DeviceID is an optional parameter for `Installed` token requests. This is intended to be an semi-permanent ID for the device that is requesting a token. When this is not supplied, a new GUID will be generated. Fore more information see the `Installed` parameter description and  https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

```yaml
Type: String
Parameter Sets: Installed
Aliases:

Required: False
Position: 2
Default value: [guid]::NewGuid().toString()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Installed
Best Used for: Anonymous API access for `Installed` applications.

The `Installed` option will initiate a `installed_client` grant flow. This will enable the use of OAuth Based APIs, but since the OAuth Token will not be associated with any user context it will only have "anonymous" access. This is similar to browsing reddit without having a login. You will not be able to send user messages, post comments or submissions, or do anything else that would require an active login session on the web site.

The token will only be valid for 1 hour and then a new token will be requested. This can be placed in automation as it does not require the user to log in. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

The `Installed` grant flow requires that a Device ID be sent. The `DeviceID` parameter can be used to supply one. the default is to generate a new GUID. That Device ID used should be unique to the device and should be used for all subsequent Access Token requests via the `Installed` method on the same device. This will be set on the `DeviceID` of the returned `RedditOAuthToken` object.

For more information see https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

```yaml
Type: SwitchParameter
Parameter Sets: Installed
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
By default this command does not return any data. When `-PassThru` is used, the `RedditOAuthToken` that is imported is passed to the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Script
Best used for: Automation, bots and long running unattended process when a single application may act on behalf of one or more users or when the Application will only act on behalf of the Application Developer and not on behalf of others.

The `Script` method can only be used by `Script` applications and can only act on behalf of the Reddit user who registered the application. This method will initiate a `password` grant flow. The user's credentials along with the Client ID and Client Secret are used to request an Access token. The token is valid for 1 hour and then a new token will need to be requested. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

The `Script` method can be used in automation, but, it requires that the reddit username and password be stored in the `RedditApplication` object. The user password is stored in a secure string and when a `RedditApplication` or `RedditOAuthToken` is exported, the password is stored in encrypted form that can only be retrieved by the same user on the same computer where the object was exported.

For more information see https://github.com/reddit/reddit/wiki/OAuth2#retrieving-the-access-token

```yaml
Type: SwitchParameter
Parameter Sets: Script
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditApplication

## OUTPUTS

### RedditOAuthToken

## NOTES
For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
