# RedditOAuthGrantType
## about_RedditOAuthGrantType

# SHORT DESCRIPTION
Describes the RedditOAuthGrantType Enum

# LONG DESCRIPTION
The `RedditOAuthGrantType` enumerator contains the available grant types available for OAuth Access Tokens requests on Reddit. this is visible on `RedditOAuthToken` objects as the `GrantType` property. It is used by various functions in this module to determine the actions and endpoints required to request Access Tokens.

# Fields

## Client_Credentials
This grant method uses the Client ID and Client Secret to request an anonymous Access Token. This method will not act under a user context but will allow "logged out" access to the OAuth API endpoints for `Script` and `WebApp` applications. For more information see the `Client` parameter description of `Request-RedditOAuthToken` or the Reddit OAuth documentation at  https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

## Installed_Client
This grant flow allows anonymous access to the Reddit API for `Installed` applications. This method will not act under a user context but will allow "logged out" access to the OAuth API endpoints.  For more information see the `Installed` parameter description of `Request-RedditOAuthToken` or the Reddit OAuth documentation at https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth

## Password
This grant flow allows for the developer of `Script` applications to access the Reddit API as themselves. This uses the Username, Password, Client ID, and Client Secret to request an OAuth Access Token.  For more information see the `Script` parameter description of `Request-RedditOAuthToken` or the Reddit OAuth documentation at https://github.com/reddit/reddit/wiki/OAuth2#application-only-oauth



# SEE ALSO

[about_RedditOAuthGrantType](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthGrantType)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
