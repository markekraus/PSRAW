# RedditOAuthCode
## about_RedditOAuthCode

# SHORT DESCRIPTION
Describes the RedditOAuthCode Class

# LONG DESCRIPTION
The `RedditOAuthCode` class contains the result of an OAuth Authorization Code requeest to the Reddit API. `RedditOAuthCode` objectss are returnd from `Request-RedditOAuthCode` and are used to request `RedditOAuthToken`'s via `Request-RedditOAuthTokenCode`.

The `RedditOAuthCode` class is imported automatically when you import the PSRAW module.

# Constructors
## RedditOAuthCode()
The default constructor will retrun an empty `RedditOAuthCode` object.

```powershell
[RedditOAuthCode]::new()
```


# Properties
## Application
The `Application` property contains the `RedditApplication` object for the Application for which the Authorization Code was requested.

```yaml
Name: Application
Type: RedditApplication
Hidden: False
Static: False
```

## AuthBaseURL
This is the base URL which was use to request the Authorization Code.

```yaml
Name: AuthBaseURL
Type: String
Hidden: False
Static: False
```

## AuthCodeCredential
The `AuthCodeCredential` hidden property houses the Authorization Code as the password in a `PSCredential` object. The username is ignored.

```yaml
Name: AuthCodeCredential
Type: System.Management.Automation.PSCredential
Hidden: True
Static: False
```

## Duration
This is the `RedditOAuthDuration` for the duration of the Token that this Authorization Code will be able to request. `Permanent` is most often used for `Code` requests methods.

```yaml
Name: Duration
Type: RedditOAuthDuration
Hidden: False
Static: False
```

## IssueDate
This is date and time the Authorization Code was requested.

```yaml
Name: IssueDate
Type: DateTime
Hidden: False
Static: False
```

## ResponseType
This is the `RedditOAuthResponseType` that was requested. For `RedditOAuthCode` this should always be `Code`.

```yaml
Name: ResponseType
Type: RedditOAuthResponseType
Hidden: False
Static: False
```

## StateReceived
This is the `state` that was received from Reddit along with the Authorization Code. It should match the `StateSent` property unless there were problems.


```yaml
Name: StateReceived
Type: String
Hidden: False
Static: False
```

## StateSent
This is the `state` that was sent to Reddit during the Authorization Code request. It should match the `StateReceived` property unless there were problems.

```yaml
Name: StateSent
Type: String
Hidden: False
Static: False
```

## TTL
The `TTL` Static property is a `TimeSpan`for the time period an Authorization Code is valid for. This is used in conjunction with the `IssueDate` to determine if the Code has expired. Authorization Codes are only valid for 10 minutes.


```yaml
Name: TTL
Type: TimeSpan
Hidden: False
Static: True
```


# Methods
## GetAuthorizationCode()
Returns the Authorization Code stored in the `AuthCodeCredential` hidden property.

```yaml
Name: GetAuthorizationCode
Return Type: String
Hidden: False
Static: False
Definition: String GetAuthorizationCode()
```

## GetExpireDate()
Returns the expiration date of the Authorization code.

```yaml
Name: GetExpireDate
Return Type: DateTime
Hidden: False
Static: False
Definition: DateTime GetExpireDate()
```

## IsExpired()
Returns `$True` if the Authorization Code is expired.
Returns `$False` if the Authorization Code is not expired.

```yaml
Name: IsExpired
Return Type: Boolean
Hidden: False
Static: False
Definition: Boolean IsExpired()
```

## ToString()
Creates string representation of the `RedditOAuthCode` object.

```yaml
Name: ToString
Return Type: String
Hidden: False
Static: False
Definition: String ToString()
```

# NOTE
`RedditOAuthCode` Objects are not intended to be cerate manually or modified by module consumers. Documentation is provided for developers and contributors.

# SEE ALSO

[about_RedditAplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditAplicationType)

[about_RedditAplicationType](https://psraw.readthedocs.io/en/latest/Module/about_RedditAplicationType)

[about_RedditOAuthDuration](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthDuration)

[about_RedditOAuthResponseType](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthResponseType)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Request-RedditOAuthCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthCode)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Request-RedditOAuthTokenCode](https://psraw.readthedocs.io/en/latest/PrivateFunctions/Request-RedditOAuthTokenCode)

[https://github.com/reddit/reddit/wiki/OAuth2#token-retrieval-code-flow](https://github.com/reddit/reddit/wiki/OAuth2#token-retrieval-code-flow)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)