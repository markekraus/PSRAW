---
external help file:
Module Name:
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-HttpResponseContentType
schema: 2.0.0
---

# Get-HttpResponseContentType

## SYNOPSIS
Retrieves the `Content-Type` header from a `WebResponseObject`.

## SYNTAX

```
Get-HttpResponseContentType [-Response] <WebResponseObject> [<CommonParameters>]
```

## DESCRIPTION
Retrieves the `Content-Type` header from a `WebResponseObject`.

PowerShell 6.0 has switched from `System.Net.HttpWebResponse` to `System.Net.Http.HttpResponseMessage` for the underlying base object. `HttpResponseMessage` separates content related headers from response headers. This private function provides compatibility between 5.0, 5.1, and 6.0+.

## EXAMPLES

### Example 1
```
Invoke-WebRequest -Uri 'reddit.com' | Get-HttpResponseContentType
```

## PARAMETERS

### -Response
`Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject` or `Microsoft.PowerShell.Commands.HtmlWebResponseObject` returned from `Invoke-WebRequest`

```yaml
Type: WebResponseObject
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

### Microsoft.PowerShell.Commands.WebResponseObject

## OUTPUTS

### System.String

## NOTES
For more information see [Issue #4467](https://github.com/PowerShell/PowerShell/issues/4467) and [Pull Request #4494](https://github.com/PowerShell/PowerShell/pull/4494).

This function is used in the following functions:

* [Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)
* [Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)
* [Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)
* [Request-RedditOAuthTokenPassword](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenPassword)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-HttpResponseContentType](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Get-HttpResponseContentType)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)

[Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)

[Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)

[Request-RedditOAuthTokenPassword](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenPassword)