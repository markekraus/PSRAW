---
external help file: PSRAW-help.xml
online version: https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken
schema: 2.0.0
---

# Update-RedditOAuthToken

## SYNOPSIS
Refresh a `RedditOAuthToken`

## SYNTAX

```
Update-RedditOAuthToken -AccessToken <RedditOAuthToken[]> [-Force] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
When a `RedditOAuthToken` Token has expired, `Update-RedditOAuthToken`can be used to refresh the Access Token. Depending on the grant method used to request the `RedditOAuthToken` with `Request-RedditOAuthToken`, either a refresh will be perfomed or a new grant flow will be initiated. 

This function must be run in an interactive session for tokens requested with the `Implicit` grant method. The user will be required to reauhtorize the application with the provided GUI browser. All other grant methods can be refreshed with this function in non-interactive sessions.

> **PowerShell ISE Compatibility Issue**
> 
> There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE when using `Implicit` tokens.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> $Token | Update-RedditOAuthToken
```

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> $Token | Update-RedditOAuthToken -Force
```

This example demonstratees using the `-Force` parameter for initiate a token refresh on a token that has not yet expired.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> $NewEpireDate = $Token | Update-RedditOAuthToken -PassThru | Select-Object -Expand ExpireDate
```

This example demonstrates using the `-PassThru` parameter to send the updated `RedditOAuthToken` to the pipeline. The `ExpireDate` property is then expanded and stored in `$NewExpireDate`.

## PARAMETERS

### -AccessToken
The `RedditOAuthToken` containing the Access Token to refresh. Multiple `RedditOAuthToken` objects can be supplied.

```yaml
Type: RedditOAuthToken[]
Parameter Sets: (All)
Aliases: Token

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Force
By default, this function will ignore any `RedditOAuthToken` which is not yet expired. `-Force` will override that behavior and perform a refresh request.

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

### -PassThru
By default, this function does not return any data. The `-PassThru` parameter will place the uodated `RedditOAuthToken` into the output stream to either be stored in another variable or placed in the pipeline and consumed by other functions.

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

### RedditOAuthToken[]

## OUTPUTS

### RedditOAuthToken

## NOTES
There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE when using `Implicit` tokens.

For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)