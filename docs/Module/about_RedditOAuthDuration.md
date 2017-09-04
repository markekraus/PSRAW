# RedditOAuthDuration
## about_RedditOAuthDuration

# SHORT DESCRIPTION
Describes the RedditOAuthDuration Enum

# LONG DESCRIPTION
The `RedditOAuthDuration` enumerator represents the available options for Access Token durations during Authorization code requests to the Reddit API.


# Fields
## Permanent
Requests for permanent OAuth Access Tokens will issue an OAuth Refresh Token. Access Tokens are valid for 60 minutes. When the Access Token expires the Refresh Token can be used to request a new access token without requiring the application to be authorized again. Refresh tokens are valid until a user or developer revokes the authorization for the application.

When `Permanent` Access Tokens are "renewed" the do not require a new grant flow and the Refresh Token will be used to request a new Access Token.

`Permanent` is currently not support in PSRAW.

## Temporary
Requests for temporary OAuth Access Tokens will not issue Refresh Tokens and when they expire the user will need to authorize the applications again. Access Tokens are valid for 60 minutes.

When `Temporary` Access Tokens are "renewed" a new grant flow is started.

`Temporary` can be used with any grant flow.

# EXAMPLES
## Permanent
```powershell
$Permanent = [RedditOAuthDuration]::Permanent
```

## Temporary
```powershell
$Temporary = [RedditOAuthDuration]::Temporary
```

# SEE ALSO

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[https://ssl.reddit.com/prefs/apps](https://ssl.reddit.com/prefs/apps)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
