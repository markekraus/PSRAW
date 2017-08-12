# RedditOAuthResponse
## about_RedditOAuthResponse

# SHORT DESCRIPTION
Describes the RedditOAuthResponse Class

# LONG DESCRIPTION
The `RedditOAuthResponse` Class encapsulates the responses from Reddit OAuth grant flows.

The `RedditOAuthResponse` class is imported automatically when you import the PSRAW module.


# Constructors
## RedditOAuthResponse()
Default Constructor creates an empty `RedditOAuthResponse` object.

```powershell
[RedditOAuthResponse]::new()
```


# Properties
## Content
The Content returned from the Reddit. It may be either plain text or an object created from JSON.

```yaml
Name: Content
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## ContentType
The `Content-Type` response header returned from Reddit.

```yaml
Name: ContentType
Type: String
Hidden: False
Static: False
```

## Parameters
The parameters that were passed to `Invoke-WebRequest`.

```yaml
Name: Parameters
Type: System.Collections.Hashtable
Hidden: False
Static: False
```

## RequestDate
The date the request was made.

```yaml
Name: RequestDate
Type: DateTime
Hidden: False
Static: False
```

## Response
The `Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject` or `Microsoft.PowerShell.Commands.HtmlWebResponseObject` returned from `Invoke-WebRequest`

```yaml
Name: Response
Type: Microsoft.PowerShell.Commands.WebResponseObject
Hidden: False
Static: False
```


# Methods

# EXAMPLES

## Example 1
```powershell
[RedditOAuthResponse]@{
    Response    = $Response
    RequestDate = $Response.Headers.Date[0]
    Parameters  = $Params
    Content     = $Response.Content
    ContentType = $Response | Get-HttpResponseContentType
} 
```

This is an example of how the `RedditOAuthResponse` class is used in `Request-RedditOAuthTokenPassword`.


# SEE ALSO

[RedditOAuthResponse](https://psraw.readthedocs.io/en/latest/Module/RedditOAuthResponse)

[Request-RedditOAuthTokenClient](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenClient)

[Request-RedditOAuthTokenInstalled](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenInstalled)

[Request-RedditOAuthTokenPassword](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenPassword)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Update-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Update-RedditOAuthToken)

[Invoke-WebRequest](https://go.microsoft.com/fwlink/?LinkID=217035)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)