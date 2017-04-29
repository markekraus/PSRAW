# RedditScope Class
## about_RedditScope

# SHORT DESCRIPTION
Describes the RedditScope Class

# LONG DESCRIPTION
The ReditScope Class is used to define OAuth Scopes for reddit's API. All OAuth bearer tokens are limited in what functions they may perform. Scopes for an application define what the application can and cannot do on the API. When creating a new RedditApplication class, one or more RedditScope's are required ro be set on the Scope property. When a request is made for an OAuth Authorization Code, the scopes will be provided and the resulting Access Token will only be valid for those scopes.

ReditScope's can be created manually or you can retrieve all valid scopes with [Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope).

The RedditScope class is imported from a nested module located at moduleroot\Classes\RedditScope.psm1. This means you can import the class either from the PSRAW module or directly from the nested module.


## Members

### Scope
Redit's API reuturns a JSON hobject that contains an array of hashes. The Scope member preprsents the name of the scope hash. In most cases this matches the Id.

```yaml
Data Type: String
Name: Scope
Default value: None
Access Modifer: Public
Scope: Instance
Example: creddits
```

### Id
This is the ID of the Scope that is used in OAuth Authorization Code requests.

```yaml
Data Type: String
Name: Id
Default value: None
Access Modifer: Public
Scope: Instance
Example: creddits
```

### Name
A short descriptive name of the scope

```yaml
Data Type: String
Name: Name
Default value: None
Access Modifer: Public
Scope: Instance
Example: Spend reddit gold creddits
```

### Description
Longer description of the scope.

```yaml
Data Type: String
Name: Name
Default value: None
Access Modifer: Public
Scope: Instance
Example: Spend my reddit gold creddits on giving gold to other users.
```

### ApiEndpointUri
The ApiEndpointUri static member is included on all API generated objects. It is a template string for the API End Point to access objects of that class. To get a formatted string to make API calls, use the GetApiEndpointUri() static method(s).

```yaml
Data Type: String
Name: ApiEndpointUri
Value: 'https://www.reddit.com/api/v1/scopes'
Access Modifer: Public
Scope: Static
```

## Methods

### _init
The _init hidden method is used by the constructors to initialize the class. This way class initialization code can be maintained in a single methods instead of each constructor.

```yaml
Data Type: Void
Name: _init
Access Modifer: Hidden
Scope: Instance
Definition: void _init(string Scope, string Id, string Name, string Description)
```

### GetApiEndpointUri
The GetApiEndpointUri static method is included on all API generated objects. It returns a formatted string for the API End Point that is used to query objects of this class.

```yaml
Data Type: String
Name: GetApiEndpointUri
Access Modifer: Public
Scope: Static
Definition: static string GetApiEndpointUri()
```

## Constructors

### Default
Initializes an empty RedditScope.

```powershell
[RedditScope]::New()
```

### ($Scope)
Initializes a RedditScope where all members match the provided string.

```powershell
[RedditScope]::New([String]$Scope)
```

### ($Scope, $Id, $Name, $Description)
Initializes a RedditScope with all the properties.

```powershell
[RedditScope]::New([String]$Scope, [String]$Id, [String]$Name, [String]$Description)
```

# EXAMPLES

## Using the RedditScope.psm1

```powershell
Using module '.\PSRAW\Classes\RedditScope.psm1'
$Scope = [RedditScope]@{
    Scope = 'creddits'
    Id = 'creddits'
    Name = 'Spend reddit gold creddits'
    Description = 'Spend my reddit gold creddits on giving gold to other users.'
}
```

## Using PSRAW

```powershell
Using module PSRAW
$Scope = [PSRAW.RedditScope]@{
    Scope = 'creddits'
    Id = 'creddits'
    Name = 'Spend reddit gold creddits'
    Description = 'Spend my reddit gold creddits on giving gold to other users.'
}
```

## Simple String Scope

```powershell
Using module PSRAW
$ReadScope = [PSRAW.RedditScope]'read'
```


# SEE ALSO
[Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

