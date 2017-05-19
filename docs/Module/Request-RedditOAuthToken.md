---
external help file: PSRAW-help.xml
online version: https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken
schema: 2.0.0
---

# Request-RedditOAuthToken

## SYNOPSIS
Requests a OAuth Access Token from Reddit

## SYNTAX

### Script (Default)
```
Request-RedditOAuthToken [-Script] [-Application] <RedditApplication> [<CommonParameters>]
```

### Installed
```
Request-RedditOAuthToken [-Installed] [-Application] <RedditApplication> [[-DeviceID] <String>]
 [<CommonParameters>]
```

### Client
```
Request-RedditOAuthToken [-Client] [-Application] <RedditApplication> [<CommonParameters>]
```

### Code
```
Request-RedditOAuthToken [-Code] [-Application] <RedditApplication> [[-State] <String>] [<CommonParameters>]
```

### Implicit
```
Request-RedditOAuthToken [-Implicit] [-Application] <RedditApplication> [[-State] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Requests an OAuth Access Token from Reddit and returns a `RedditOAuthToken` object for the given `RedditApplication`. The OAuth Access Token is used by other functions in this module to make authenticated calls tot he Reddit API. For more information on Reddit's OAuth impliementation, see https://github.com/reddit/reddit/wiki/OAuth2

A `RedditApplication` object is required to request a `RedditOAutToken`. Once the token has been issued the `RedditApplication` will be added to the `RedditOAuthToken` object as the `Application` property. for mor information see the `about_RedditOAuthToken` help topic.

Reddit provides several different methods for obtaining Access Tokens depending on your needs and required level of access to the API. For more information on each, see the `Client`,`Code`, `Implicit`, `Installed` and `Script` parameter descriptions. For most uses, either `Code` or `Script` will provide the most benefit.

`Code` and `Implicit` methods cannot be run in non-interactive sessions as they require logging into reddit through a GUI (provided by thsi module). For `Code` Access Tokens this only needs to be pereformed once for more info see the `Code` parameter description. For `Implicit` Access Tokens, this must be done at least once an hour.

All `RedditOAuthToken` types will automatically refresh when they expire when consumed by functions in this module. `Implicit` tokens will prompt for credentials through a GUI on every renewal. You can also manually refresh them using `Update-RedditOauthToken`.

> **PowerShell ISE Compatibility Issue**
> 
> There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE when using any of the grant methods which require and intercative session.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> $Token = $RedditApp | Request-RedditOAuthToken -Script
```

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> $Token = $RedditApp | Request-RedditOAuthToken -Code
```

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> $Token = $RedditApp | Request-RedditOAuthToken -Installed -DeviceId 'db470a80-da50-4ae1-9bba-24a1a3454392'
```

### -------------------------- EXAMPLE 4 --------------------------
```
PS C:\> $Token = $RedditApp | Request-RedditOAuthToken -Client
```

### -------------------------- EXAMPLE 5 --------------------------
```
PS C:\> $Token = $RedditApp | Request-RedditOAuthToken -Implicit
```

### -------------------------- EXAMPLE 6 --------------------------
```
$ClientCredential = Get-Credential
$Scope = Get-RedditOAuthScope | Where-Object {$_.Scope -like '*wiki*'} 
$Params = @{
    WebApp = $True
    Name = 'Connect-Reddit'
    Description = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    RedirectUri = 'https://adataum/ouath?'
    UserAgent = 'windows:connect-reddit:v0.0.0.1 (by /u/makrkeraus)'
    Scope = $Scope
    OutVariable = 'RedditApp'
}
$Token = New-RedditApplication @Params | Request-RedditOAuthToken -Code
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

The `Client` switch will initiate a `Client_Credentials` grant flow. This Grant type uses only the application's Client ID and Client Secret to request an OAuth Token. This will enable the use of OAuth Based APIs, but since the OAuth Token will not be associated with any user context it will only have "anonymous" access. This is similar to browsing reddit without having a login. You will not be able to send user messages, post comments or sumissions, or do anything else that would require an active login session on the web site.

`Client` access tokens expire after 60 minutes. When they are "renewed" a new token is requested from scratch. This can be used in automation as it does not require user input. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

`Client` OAuth Access Tokens can only be issued to `Script` and `WebApp` applications as it requires Client Secret.

For more information on Reddit's OAuth impliementation, see https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

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

### -Code
Best used for: Automation, bots and long running unattended process when a single application may act on behalf of one or more users or when you do not wish to store or continually transmit reddit user crednetials. 

Offers the best security and flexibility.

The `Code` switch will initiate a `Authorization_Code` grant flow. This grant type uses the Client ID and Redirect URI to direct a user to log in on reddit and authorize the application via GUI web browser. Once the user has logged in and authorized the application, reddit will return an authorization code to the Redirct URI. The GUI browser will close and the  authorization code is then used along with the client ID and Client Secret to request an Access Token and Refresh Token. The Access Token is valid for 60 minutes and is used to authenticate with the Reddit API. Once the Access Token expires the Refresh Token, Client ID, and Client Secret are used to request a new Access Token. The Refresh Token is valid until the user or application revokes it.

This process requires a interactive powershell session. It only needs to be done once. For automation purposes, the initial `Request-RedditOAuthToken` needs to be done from a normal PowerShell console. Once the token has been issued, export it with `Export-RedditOAuthAToken`. The exported token can then be imported in other scripts with `Import-RedditOAuthToken`. The token will automatically update on the next call the API made by functions in this module.

`Code` OAuth Access Tokens can only be issued to `Script` and `WebApp` applications as it requires Client Secret.

For more information see https://github.com/reddit/reddit/wiki/OAuth2#authorization

> **REQUIRES INTERACTIVE SESSION**

```yaml
Type: SwitchParameter
Parameter Sets: Code
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

### -Implicit
Best used for: `Installed` applicatiosn that need to act on behalf of the user.

The `Implicit` grant flow provides `Installled` applications the ability act in a user context. `Installed` applications do not have Client Secrets so this method allows for requesting an access token from a device that is not under the develoepr's direct control. The token will be valid for 1 hour and then a new token will need to be authorized.

This grant flow requires an Interactive session and cannot be run in non-interactive scripts. The user will be provided a GUI Web Browser to log in to Reddit and authorize the application. The user will need to authorize the application on the next request made to the API after the token expires.

The method is provided in the module for completeness, it is not recommended unless you are prepakaging an application that needs to access the Reddit API as a logged in user and the other methods are unavailable.

For more information see https://github.com/reddit/reddit/wiki/OAuth2#authorization-implicit-grant-flow

> **REQUIRES INTERACTIVE SESSION**

```yaml
Type: SwitchParameter
Parameter Sets: Implicit
Aliases: 

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Installed
Best Used for: Anonymous API access for `Installed` applications.

The `Installed` option will initiate a `installed_client` grant flow. This will enable the use of OAuth Based APIs, but since the OAuth Token will not be associated with any user context it will only have "anonymous" access. This is similar to browsing reddit without having a login. You will not be able to send user messages, post comments or sumissions, or do anything else that would require an active login session on the web site.

The token will only be valid for 1 hour and then a new token will be requested. This can be placed in automation as it does not require the user to log in. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

The `Installed` grant flow requires that a Device ID be sent. The `DeviceID` parameter can be used to supply one. the defualt is to generate a new GUID. That Device ID used should be unique to the device and should be used for all subsequent Access Token requests via the `Installed` method on the same device. This will be set on the `DeviceID` of the returned `RedditOAuthToken` object.

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

### -Script
Best used for: Automation, bots and long running unattended process when a single application may act on behalf of one or more users or when the Application will only act on behalf of the Application Developer and not on behalf of others.

The `Script` method can only be used by `Script` applications and can only act on behalf of the Reddit user who registered the application. This method will initiate a `password` grant flow. The user's crednetials along with the Client ID and Client Secret are used to request an Access token. The token is valid for 1 hour and then a new token will need to be requested. A new token will automatically be requested on the next API call made by functions in this module after the token has expired.

The `Script` method can be used in automation, but, it requires that the reddit username and password be stored in the `RedditApplication` object. The user password is stored in a secure string and when a `RedditApplication` or `RedditOAuthToken` is exported, the assword is stored in encryoted form that can only be retrieved by te sam user on the same computer where the objectw as exported.

In contrast to the `Code` method, the `Script` method does not reauire an interactive session at any point provided you have a way to import a `PSCrwedential` object. The down side is that the developers Client ID, Client Secret, Username, and Password all need to be used and stored.

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

### -State
The `State` parameter is used by the `Code` and `Implicit` methods for validation. It is optional as the module will varify the state. The default will create a new GUID.

```yaml
Type: String
Parameter Sets: Code, Implicit
Aliases: 

Required: False
Position: 2
Default value: [guid]::NewGuid().toString()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditApplication

## OUTPUTS

### RedditOAuthToken

## NOTES
There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE when using any of the grant methods which require and intercative session.

For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

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