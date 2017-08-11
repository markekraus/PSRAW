---
external help file: 
online version: https://psraw.readthedocs.io/en/latest/PrivateFunctions/Wait-RedditApiRateLimit
schema: 2.0.0
---

# Wait-RedditApiRateLimit

## SYNOPSIS
Suppresses the command prompt until the Reddit API Rate Limit has been lifted.

## SYNTAX

```
Wait-RedditApiRateLimit [-AccessToken] <RedditOAuthToken> [[-MaxSleepSeconds] <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Reddit allows only 600 requests to be made to the API in 8 minutes. This information is returned by the Reddit API as the `x-ratelimit-used`, `x-ratelimit-remaining`, and `x-ratelimit-reset` response headers. `Invoke-GraphRequest` calls the `UpdateRatelimit()` method on `RedditOAuthToken` access tokens after every API call. `Wait-RedditApiRateLimit` will sleep until the rate limit period has been reset or until the `MaxSleepSeconds` has been reached. `Invoke-GraphRequest` calls `Wait-RedditApiRateLimit` before performing any API requests. If the rate limit is not in effect, `Wait-RedditApiRateLimit` will immediately return.

This function is not intended for direct usage by the module consumer and is not exported by the module. Documentation is provided for developers and contributors.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$AccessToken | Wait-RedditApiRateLimit
```

This example shows how `Invoke-GraphRequest` calls `Wait-RedditApiRateLimit`

## PARAMETERS

### -AccessToken
The `RedditOAuthToken` to check for Rate Limiting and sleep if necessary.

```yaml
Type: RedditOAuthToken
Parameter Sets: (All)
Aliases: Token

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -MaxSleepSeconds
The Maximum number of seconds to wait. If this number is lower than the number of seconds until the Rate Limit reset, the function will return before the Rate Limit has been lifted.

```yaml
Type: Int32
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

### RedditOAuthToken
System.Int32

## OUTPUTS

### System.Void

## NOTES
This Function is called by 

* [Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/PrivateFunctions/Wait-RedditApiRateLimit](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Wait-RedditApiRateLimit)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)