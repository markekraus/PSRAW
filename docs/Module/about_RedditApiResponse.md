# RedditApiResponse
## about_RedditApiResponse

# SHORT DESCRIPTION
Describes the RedditApiResponse Class

# LONG DESCRIPTION
The `RedditApiResponse` is returned by the `Invoke-RedditRequest` function. It is used to house the response from the Reddit API.

The `RedditApiResponse` class is imported automatically when you import the PSRAW module.


# Constructors
## RedditApiResponse()
Creates a new `RedditApiResponse` object.

```powershell
[RedditApiResponse]::new()
```


# Properties
## AccessToken
The `RedditOAuthToken` used to authenticated the API request that resulted in this `RedditApiResponse`.

```yaml
Name: AccessToken
Type: RedditOAuthToken
Hidden: False
Static: False
```

## ContentObject
Will either be a `System.Management.Automation.PSCustomObject` or `System.String`. This is the converted content from the Reddit API response. Most responses from the API should be JSON object. This will be converted to `System.Management.Automation.PSCustomObject`. Other responses will be stored as `System.String`.

```yaml
Name: ContentObject
Type: Object
Hidden: False
Static: False
```

## ContentType
The `Content-Type` response header returned from Reddit.

```yaml
Name: ContentType
Type: System.String
Hidden: False
Static: False
```

## Parameters
These are the parameters that were used with `Invoke-WebRequest` when it is called by `Invoke-RedditRequest`. The `Authorization` header will be truncated to protect the Access Token.

```yaml
Name: Parameters
Type: System.Collections.Hashtable
Hidden: False
Static: False
```

## RequestDate
This is the date the request was made to the API as determined by the API response (Reddit's Servers). This may differ from the local time.

```yaml
Name: RequestDate
Type: DateTime
Hidden: False
Static: False
```

## Response
This is the response object returned from `Invoke-WebRequest` when it is called by `Invoke-RedditRequest`.

```yaml
Name: Response
Type: Object
Hidden: False
Static: False
```


# Methods

# EXAMPLES

## Basic Example
```powershell
$Params = @{
    ContentType     = 'application/json'
    Uri             = 'https://oauth.reddit.com/api/v1/me'
    Method          = 'Get'
    ErrorAction     = 'Stop'
    UserAgent       = $AccessToken.Application.UserAgent
    WebSession      = $AccessToken.Session
    UseBasicParsing = $true
    Headers = {
        Authorization = 'Bearer {0}' -f $AccessToken.GetAccessToken()
    }
}
$Result = Invoke-WebRequest @Params
 [RedditApiResponse]@{
    AccessToken   = $AccessToken
    Parameters    = $Params
    RequestDate   = $Result.Headers.Date
    Response      = $Result
    ContentObject = $Result.Content | ConvertFrom-Json
    ContentType   = $Result | Get-HttpResponseContentType
}
```

This example demonstrates using a `RedditOAuthToken` to make an authenticated web request to `https://oauth.reddit.com/api/v1/me` and creating a `RedditApiResponse` with the results. This is basically what is done within `Invoke-RedditRequest`

# SEE ALSO

[about_RedditApiResponse](https://psraw.readthedocs.io/en/latest/Module/about_RedditApiResponse)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
