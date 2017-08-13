---
external help file: PSRAW-help.xml
Module Name: psraw
online version: https://psraw.readthedocs.io/en/latest/Module/Get-RedditDefaultOAuthToken
schema: 2.0.0
---

# Get-RedditDefaultOAuthToken

## SYNOPSIS
Retrieves the session default OAuth Token

## SYNTAX

```
Get-RedditDefaultOAuthToken [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
A session default OAuth Token is set by `Set-RedditDefaultOAuthToken`, `Connect-Reddit`, `Import-RedditOAuthToken`, `Request-RedditOAuthToken`, and `Update-RedditOAuthToken` (with the `-SetDefault` parameter) all set the default session OAuth Token. The `Get-RedditDefaultOAuthToken` can be used to retrieve the current default OAuth Token. Many PSRAW commands require a `RedditOAuthToken` to authenticate with the Reddit API. The session default OAuth Token is used by those commands so that one does not need to be manually supplied each time.

## EXAMPLES

### Example 1
```
PS C:\> $DefaultToken = Get-RedditDefaultOAuthToken
```

This retrieves the current default session OAuth Token.

## PARAMETERS

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

### RedditOAuthToken

## NOTES

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Get-RedditDefaultOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Get-RedditDefaultOAuthToken)

[Connect-Reddit](https://psraw.readthedocs.io/en/latest/Module/Connect-Reddit)

[Import-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Import-RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Set-RedditDefaultOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Set-RedditDefaultOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)