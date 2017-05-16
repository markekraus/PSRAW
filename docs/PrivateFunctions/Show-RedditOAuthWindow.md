---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/Module/Show-RedditOAuthWindow
schema: 2.0.0
---

# Show-RedditOAuthWindow

## SYNOPSIS
Displays a window to login and authorize a reddit Application

## SYNTAX

```
Show-RedditOAuthWindow [-Url] <String> [-RedirectUri] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This provides a GUI Web Browser for users to login to Reddit and Authorize applications in `authorization_code` and `implicit`

In order to request an OAuth Access Token through the `code` grant flow, an OAuth Authorization code must first be requested by the user. The Authorization code request must include the Application Client ID, Redirect URI, The requested access scops, a duration and a response type of `code`. 

`Reqeust-RedditOAuthCode` creates an OAuth Authorization Code request URL and then calls `Show-RedditOAuthWindow` where the user is prompted to authorozie the application. Once the authorization is complete `Show-RedditOAuthWindow` retruns the resulting URL to `Reqeust-RedditOAuthCode` which then parses the response and creates a `RedditOAuthCode` object.

`Request-RedditOAuthTokenImplicit` request authorization of new tokens every hour. 

Since this function displays a GUI, this command cannot be run in a non-interactive mode. This process should only need to be done when first requesting an OAuth Access Token, when an OAuth Refresh Token has expired or invalidated, or when a Temporary OAuth Access Token has expired.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

> **PowerShell ISE Compatibility Issue**
> 
> There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$URL = 'https://www.reddit.com/api/v1/authorize?client_id=AbCDef123&response_type=code&state=MyState&redirect_uri=https%3a%2f%2f127.0.0.1%2&duration=permanent&scope=read'
$RedirectUri = 'https://127.0.0.1/'
$Result = Show-RedditOAuthWindow -Url $URL -RedirectUri $RedirectUri
```

This is an example of what `Reqeust-RedditOAuthCode` calls to `Show-RedditOAuthWindow`.

## PARAMETERS

### -RedirectUri
The Redirect Uri expected. This is tested for in the curent URL of the window and when it is detected it closes the windows and returns the resulting URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
This is the URL to disaplay

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
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

### None

## OUTPUTS

### System.Uri

## NOTES
There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, run this command from the PowerShell Console only and not from the ISE.

This Function is called by 

* [Request-RedditOAuthTokenImplicit](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit)
* [Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions//Show-RedditOAuthWindow](https://psraw.readthedocs.io/en/latest/PrivateFunctions//Show-RedditOAuthWindow)

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenImplicit)

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

[PowerShell ISE Issue](https://windowsserver.uservoice.com/forums/301869-powershell/suggestions/11733891-powershell-ise-crashes-after-loading-winforms)