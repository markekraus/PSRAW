---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode
schema: 2.0.0
---

# Request-RedditOAuthCode

## SYNOPSIS
Requests an OAuth Authorization Code from Reddit

## SYNTAX

```
Request-RedditOAuthCode [-Application] <RedditApplication> [[-State] <String>]
 [[-Duration] <RedditOAuthDuration>] [[-AuthBaseUrl] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
In order to request an OAuth Access Token through the `code` grant flow, an OAuth Authorization code must first be requested by the user. The Authorization code request must include the Application Client ID, Redirect URI, The requested access scope, a duration and a response type of `code`. 

`Request-RedditOAuthCode` creates an OAuth Authorization Code request URL and then calls `Show-RedditOAuthWindow` where the user is prompted to authorize the application. Once the authorization is complete `Show-RedditOAuthWindow` returns the resulting URL to `Request-RedditOAuthCode` which then parses the response and creates a `RedditOAuthCode` object.

Since this function calls `Show-RedditOAuthWindow` and a GUI is created, this command cannot be run in a non-interactive mode. This process should only need to be done when first requesting an OAuth Access Token, when an OAuth Refresh Token has expired or invalidated, or when a Temporary OAuth Access Token has expired.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.


> **PowerShell ISE Compatibility Issue**
> 
> There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, when running any exported functions which call this command do so from a PowerShell console and not from ISE.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Params = @{
    Application = $Application
    State       = $State
    Duration    = [RedditOAuthDuration]::Permanent
    AuthBaseUrl = $AuthCodeBaseUrl
}
$AuthCode = Request-RedditOAuthCode @Params
```

This example shows how the `Request-RedditOAuthTokenCode` function calls `Request-RedditOAuthCode` to retrieve a `RedditOAuthCode` object.

## PARAMETERS

### -Application
A `RedditApplication` object for the Application requesting the OAuth Authorization Code. See `New-RedditApplication` of `about_RedditApplication` for more details.

```yaml
Type: RedditApplication
Parameter Sets: (All)
Aliases: App

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AuthBaseUrl
The base URL of the the Reddit OAuth Authorization endpoint. This is option and the default will use `[RedditApplication]::AuthBaseURL`. See `about_RedditApplication` for more details.

Examples:

 https://www.reddit.com/api/v1/authorize
 https://www.reddit.com/api/v1/authorize.compact

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Duration
`RedditOAuthDuration` option for determining the validity period of the Access Token. the default is `Permanent` which will issue an OAuth Refresh Token along with the OAuth Access Token which can be used to request subsequent Access Tokens without the user needing to authorize the application.

`Temporary` will allow for requesting OAuth Access Tokens that will expire in 1 hour and will not be renewable.

```yaml
Type: RedditOAuthDuration
Parameter Sets: (All)
Aliases: 
Accepted values: Permanent, Temporary

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -State
This is a string that will be sent along with the OAuth Authorization Code request which will be returned by the Reddit API to verify the response. This is optional and the fault is to generate a new `Guid`. This will be visible as the `StateSent` property on the resulting `RedditOAuthCode` object and can be compared to the `StateReceived` property which contains the state response from reddit.

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

### RedditApplication

## OUTPUTS

### RedditOAuthCode

## NOTES
There is currently a bug in some versions of PowerShell ISE that result in the ISE becoming unresponsive when `WinForms` elements are used. This is an upstream bug and cannot be fixed within this module. To work around this, when running any exported functions which call this command do so from a PowerShell console and not from ISE.

This function is called by

* [Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)

This function calls

* [Show-RedditOAuthWindow](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Show-RedditOAuthWindow)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthCode](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthCode)

[about_RedditOAuthDuration](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthDuration)

[about_RedditOAuthResponseType](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthResponseType)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)

[Show-RedditOAuthWindow](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Show-RedditOAuthWindow)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[PowerShell ISE Issue](https://windowsserver.uservoice.com/forums/301869-powershell/suggestions/11733891-powershell-ise-crashes-after-loading-winforms)