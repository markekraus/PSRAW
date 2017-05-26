# Version 1.1.0.6 (2017-05-26)
## What's new?

Everything! This is the initial release of PSRAW so everything is a new feature! Check out the project at https://github.com/markekraus/PSRAW/ and the documentation at https://psraw.readthedocs.io/

This is a "Core Functionality" release. It provides all the components needed to build the rest of the functionality this module will provide. It does not include any of the wrapper functionality, but it is capable of making authenticated API calls in a manner similar to `Invoke-WebRequest`

## Public Functions

### API

#### Invoke-RedditRequest
* Provides authenticated access to the Reddit API in a `Invoke-WebRequest` style.

### Application

#### Export-RedditApplication
* Provides the ability to export `RedditApplication` objects so they can be imported later by `Import-RedditApplication`

#### Import-RedditApplication
* Provides the ability import `RedditApplication` objects previously exported by `Export-RedditApplication`

#### New-RedditApplication
* Creates new `RedditApplication` objects that can be used to request OAuth access to the API.

### OAuth

#### Export-RedditOAuthToken
* Provides the ability to export `RedditOAuthToken` objects so they can be imported later by `Import-RedditPAuthToken`

#### Get-RedditOAuthScope
* Retrieves all valid OAuth Scopes from reddit as `RedditOAuthScope` objects.

#### Import-RedditOAuthToken
* Provides the ability import `RedditOAuthToken` objects previously exported by `Export-RedditOAuthToken`

#### Request-RedditOAuthToken
* Provides the ability to request OAuth Authorization and Access Tokens for all Grant Flows supported by reddit. Creates new `RedditOAuthToken` objects.

#### Update-RedditOAuthToken
* Provides lifecycle management of OAuth Access Tokens stored in `RedditOAuthToken` objects and perms refresh or re-grant operations when they expire.

## Classes

PSRAW Classes automatically become available in the calling scope when the module is Imported!

### Api

#### RedditApiResponse
* Used for API responses from `Invoke-RedditRequest`

### Application

### RedditApplication
* Models an Application as it is registered on Reddit and used to request `RedditOAuthToken` objects

### OAuth

### RedditOAuthCode
* Returned by the `Request-RedditOAuthCode` private function used in `Code` grant flows for OAuth. Provides a secure means of temporarily storing the Authentication Code.

### RedditOAuthScope
* Models the Reddit OAuth Scopes available for the Reddit API.

### RedditOAuthToken
* Houses the authorized `RedditApplication`, the OAuth Access Token and Refresh Token (if present) and used to authenticated to the Reddit API.

## Enums

PSRAW Enums automatically become available in the calling scope when the module is Imported!

### Application

### RedditApplicationType
* provides the available types for `RedditApplication` objects

### OAuth

### RedditOAuthDuration
* provides the available OAuth Duration types.

### RedditOAuthGrantType
* Provides the available OAuth Grant Flow Types.

### RedditOAuthResponseType
* Provides the available OAuth Response Types to request.

## Help

Help topics are available for all public functions, classes and Enums! Examples:

`Get-Help Invoke-RedditRequest`

`Get-Help about_RedditOAuthToken`

`Get-Help about_RedditApplicationType`

All functions (public and private) and all classes and enums are also documented online at https://psraw.readthedocs.io/

## Private Functions

### API

`Wait-RedditApiRateLimit` provides Rate Limit cooldown.

### OAuth

The following functions have been added to deal with OAuth Grant flow in the function name

* `Request-RedditOAuthTokenClient`
* `Request-RedditOAuthTokenCode`
* `Request-RedditOAuthTokenImplicit`
* `Request-RedditOAuthTokenInstalled`
* `Request-RedditOAuthTokenPassword`
* `Request-RedditOAuthTokenRefresh`

`Get-AuthorizationHeader` provides the rfc2617 Authorization header required by Reddit for OAuth Access Token requests.

`Request-RedditOAuthCode` is used to request Authorization codes in `Code grant flows.

`Show-RedditOAuthWindows` provides a `WinForms` GUI browser for the Grant Flows that require the user to log i to the site and authorize the application.
