## Module Manifest

* All `RequiredAssemblies` have been removed

## Root Module

* Added `$PSDefaultParameterValues` for `Invoke-WebRequest` to set `-SkipHeaderValidation` if available (for backwards compatibility with 5.1)

## Public Functions

### Invoke-RedditRequest

* Now has `irr` alias to mimic `iwr` and `irm` aliases.
* `Invoke-WebRequest` error handling logic reworked to support 5.1 and 6.0

### New-RedditApplication

* Default Parameter Set changed to `Script`
* `Name` parameter is no longer Mandatory to simplify connecting
* `Scope` parameter  has been deprecated and is no longer Mandatory

### Request-RedditOAuthToken

* `Code` and `Implicit` parameter sets have been removed.
* `Code` and `Implicit` parameters have been removed
* `Code` and `Implicit` grants flows have been removed
* `State` parameter has been removed (was only required for Implicit grants)

### Update-RedditOAuthToken

* `Code` and `Implicit` grants flows have been removed

## Private Functions

### Get-HttpResponseContentType

* Added `Get-HttpResponseContentType` to get API response `Content-Type` as 6.0 and 5.1 currently house this in different locations.

### Request-RedditOAuthCode

* Removed `Request-RedditOAuthCode` as it is no needed without Code grant flow

### Request-RedditOAuthTokenClient

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenCode

* Removed `Request-RedditOAuthTokenCode` as it is not needed without Code grant flow

### Request-RedditOAuthTokenImplicit

* Removed `Request-RedditOAuthTokenImplicit` as it is not needed without Implicit grant flow

### Request-RedditOAuthTokenInstalled

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenPassword

* Now returns a `RedditOAuthResponse`

### Request-RedditOAuthTokenRefresh

* Removed `Request-RedditOAuthTokenRefresh` as it is no longer needed without Code grant flow

### Show-RedditOAuthWindow

* Removed `Show-RedditOAuthWindow` as it is not compatible with Core (this is why Code and Implicit grant flows are no longer available)

## Classes

### RedditApplication

* `Scope` is now hidden as it serves no purpose without Code grant flows.
* Removed `GetAuthorizationUrl()` and `_GetAuthorizationUrl()` as they depended on System.Web (not available in Core) and are not needed without the Code or Implicit grant flows.

### ReditOAuthCode

* This class has been deleted as it is not needed without the Code grant flow.

### RedditOAuthResponse

* Created `RedditOAuthResponse` class to abstract the OAuth response from Reddit.

### RedditOAuthToken

* Removed RefreshCredential (not needed without Code grant flow)
* Constructors now take a `RedditOAuthResponse` instead of a `PSobject` and the code adjusted to use its properties
* `GetRefreshToken()` Removed (not needed without Code grant flow)
* `Refresh()` now takes a `RedditOAuthResponse`
* `UpdateRateLimit()` adjusted to support both 5.1 and 6.0 style headers dictionaries.

### RedditApiResponse

* `Response` and `ContentObject` are now appropriately typed
* Added `ContentType`property to hold the `Content-Type` information

### RedditDate

* Added `RedditDate` class to handle unix-to-date and date-to-unix translations for dates returned from the API.

### RedditThing

* Added `RedditThing` class to work with "Reddit Things" returned from the Reddit API

### RedditModReport

* Added `RedditModReport` to house moderator reports

### RedditUserReport

* Added `RedditUserReport` to house user reports

### RedditComment

* Added `RedditComment` to house comments.

## Enums

### RedditOAuthGrantType

* Removed `Authorization_Code`, `Refresh_Token`, and `Implicit` which are not needed without Code and Implicit grant flows

### RedditThingKind

* Added `RedditThingKind` to Define "Reddit Thing" "Kind" (their terms, not mine)

### RedditThingPrefix

* Added `RedditThingPrefix` to define valid prefixes for "Reddit Things"