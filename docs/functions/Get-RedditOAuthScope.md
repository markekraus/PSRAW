# Get-RedditOAuthScope

## SYNOPSIS
Retireve valid Reddit OAuth Scopes.

## SYNTAX

```
Get-RedditOAuthScope [[-ApiEndpointUri] <String>]
```

## DESCRIPTION
Retrive valid OAuth scope IDs, Names, and Descriptions from Reddit.
The Scope ID's
are required for requesting OAuth Authorzation codes

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$RedditScopes = Get-RedditOAuthScope
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
Default value: [RedditScope]::GetApiEndpointUri()
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### RedditScope

## NOTES
For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:
    https://github.com/reddit/reddit/wiki/API
    https://github.com/reddit/reddit/wiki/OAuth2
    https://www.reddit.com/prefs/apps
    https://www.reddit.com/wiki/api

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/functions/Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/functions/Get-RedditOAuthScope)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

