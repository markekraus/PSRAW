---
external help file: PSRAW-help.xml
Module Name: PSRAW
online version: https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope
schema: 2.0.0
---

# Get-RedditOAuthScope

## SYNOPSIS
Retrieve valid Reddit OAuth Scopes.

## SYNTAX

```
Get-RedditOAuthScope [[-ApiEndpointUri] <String>] [<CommonParameters>]
```

## DESCRIPTION
Retrieve valid OAuth scope IDs, Names, and Descriptions from Reddit. 

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$RedditOAuthScopes = Get-RedditOAuthScope
```

## PARAMETERS

### -ApiEndpointUri
Optional.
URL for the Reddit App Scope definitions.
Default:

https://www.reddit.com/api/v1/scopes

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: [RedditOAuthScope]::GetApiEndpointUri()
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### RedditOAuthScope

## NOTES
For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope)

[about_RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthScope)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)