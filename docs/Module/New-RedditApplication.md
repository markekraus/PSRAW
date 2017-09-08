---
external help file: PSRAW-help.xml
Module Name: PSRAW
online version: https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication
schema: 2.0.0
---

# New-RedditApplication

## SYNOPSIS
Creates a `RedditApplication` object

## SYNTAX

### Script (Default)
```
New-RedditApplication [-Script] [-Name <String>] -ClientCredential <PSCredential> -RedirectUri <Uri>
 [-UserAgent <String>] [-Scope <RedditOAuthScope[]>] [-Description <String>] -UserCredential <PSCredential>
 [-GUID <Guid>] [<CommonParameters>]
```

### WebApp
```
New-RedditApplication [-WebApp] [-Name <String>] -ClientCredential <PSCredential> -RedirectUri <Uri>
 [-UserAgent <String>] [-Scope <RedditOAuthScope[]>] [-Description <String>] [-UserCredential <PSCredential>]
 [-GUID <Guid>] [<CommonParameters>]
```

### Installed
```
New-RedditApplication [-Installed] [-Name <String>] -ClientCredential <PSCredential> -RedirectUri <Uri>
 [-UserAgent <String>] [-Scope <RedditOAuthScope[]>] [-Description <String>] [-GUID <Guid>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a [RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication) object containing data used by various cmdlets to define the parameters of the App registered on Reddit. This does not make any calls to Reddit or perform any online lookups.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$ClientCredential = Get-Credential
$Params = @{
    WebApp           = $True
    Name             = 'Connect-Reddit'
    Description      = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    RedirectUri      = 'https://adataum/ouath?'
    UserAgent        = 'windows:connect-reddit:v0.0.0.1 (by /u/markekraus)'
}
$RedditApp = New-RedditApplication @Params
```

### -------------------------- EXAMPLE 2 --------------------------
```
$ClientCredential = Get-Credential
$UserCredential = Get-Credential
$Params = @{
    Script           = $True
    Name             = 'Connect-Reddit'
    Description      = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    UserCredential   = $UserCredential
    RedirectUri      = 'https://adataum/ouath?'
    UserAgent        = 'windows:connect-reddit:v0.0.0.1 (by /u/markekraus)'
}
$RedditApp = New-RedditApplication @Params
```

### -------------------------- EXAMPLE 3 --------------------------
```
$ClientCredential = Get-Credential
$Params = @{
    Installed        = $True
    Name             = 'PSRAW Example App'
    Description      = 'My Reddit Bot!'
    ClientCredential = $ClientCredential
    RedirectUri      = 'https://adataum/ouath?'
    UserAgent        = 'windows:PSRAW:v0.0.0.1 (by /u/markekraus)'
}
$RedditApp = New-RedditApplication @Params
```

## PARAMETERS

### -ClientCredential
A `PScredential` object containing the Client ID as the Username and the Client Secret as the password. For 'Installed' Apps which have no Client Secret, the password will be ignored.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases: ClientInfo

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the Reddit App. This is not required or used for anything. It is provided for convenient identification and documentation purposes only.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GUID
A GUID to identify the application. If one is not provided, a new GUID will be generated.

```yaml
Type: Guid
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: [guid]::NewGuid()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Installed
Use if Reddit App is registered as an Installed App.

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

### -Name
Name of the Reddit App. This does not need to match the name registered on Reddit. It is used for convenient identification and documentation purposes only.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AppName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUri
Redirect URI as registered on Reddit for the App. This must match exactly as entered in the App definition or authentication will fail.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
The `-Scope` parameter has been deprecated as all grant flows supported by this module no longer require a scope when requesting OAuth Access Tokens. teh default scope is `*`.

```yaml
Type: RedditOAuthScope[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Script
Use if the Reddit App is registered as a Script.

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

### -UserAgent
The User-Agent header that will be used for all Calls to Reddit. This should be in the following format:

\<platform\>:\<app ID\>:\<version string\> (by /u/\<reddit username\>)

Example:

windows:PSRAW:v0.0.0.1 (by /u/markekraus)

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserCredential
`PScredential` containing the Reddit Username and Password for the Developer of a Script App.

```yaml
Type: PSCredential
Parameter Sets: Script
Aliases: Credential

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: PSCredential
Parameter Sets: WebApp
Aliases: Credential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebApp
Use if the Reddit App is registered as a WebApp

```yaml
Type: SwitchParameter
Parameter Sets: WebApp
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

## OUTPUTS

### RedditApplication

## NOTES
For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
