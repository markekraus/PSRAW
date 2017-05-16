# RedditOAuthScope
## about_RedditOAuthScope

# SHORT DESCRIPTION
Describes the RedditOAuthScope Class

# LONG DESCRIPTION
The `RedditOAuthScope` Class is used to define OAuth Scopes for Reddit's API. All OAuth Access Tokens are limited in what functions they may perform. Scopes for an application define what the application can and cannot do on the API. When creating a new `RedditApplication` class, one or more `RedditOAuthScope` objects are required to be set on the `Scope` property. When a request is made for an OAuth Authorization Code, the scopes will be provided and the resulting Access Token will only be valid for those scopes.

`RedditOAuthScope` objects can be created manually or you can retrieve all valid scopes with `Get-RedditOAuthScope`. `RedditOAuthScope` objects appear as properties on `RedditApplication` and `RedditOAuthToken` objects.

The `RedditOAuthScope` class is imported automatically when you import the PSRAW module.

# Constructors
## RedditOAuthScope()
Initializes an empty `RedditOAuthScope`.

```powershell
[RedditOAuthScope]::new()
```

## RedditOAuthScope(String Scope)
Initializes a `RedditOAuthScope` where all members match the provided string.

```powershell
[RedditOAuthScope]::new([String]$Scope)
```

## RedditOAuthScope(String Scope, String Id, String Name, String Description)
Initializes a `RedditOAuthScope` with all the properties.

```powershell
[RedditOAuthScope]::new([String]$Scope, [String]$Id, [String]$Name, [String]$Description)
```


# Properties
## ApiEndpointUri
The `ApiEndpointUri` static member is included on all API generated objects. It is a template string for the API End Point to access objects of that class. To get a formatted string to make API calls, use the `GetApiEndpointUri()` static method(s).

```yaml
Name: ApiEndpointUri
Type: String
Hidden: False
Static: True
```

## Description
Longer description of the scope.

```yaml
Name: Description
Type: String
Hidden: False
Static: False
```

## Id
This ID is provided by reddit to identify the scope. it usually matches the `Scope`

```yaml
Name: Id
Type: String
Hidden: False
Static: False
```

## Name
A short descriptive name of the scope

```yaml
Name: Name
Type: String
Hidden: False
Static: False
```

## Scope
Reddit's API reuturns a JSON object that contains an array of hashes. The Scope property preprsents the name of the scope hash. In most cases this matches the `Id`. This is the string that is sent to Reddit to request access to a scope.

```yaml
Name: Scope
Type: String
Hidden: False
Static: False
```


# Methods
## _init(String Scope, String Id, String Name, String Description)
The `_init` hidden method is used by the constructors to initialize the class. This way class initialization code can be maintained in a single method instead of each individual constructor.

```yaml
Name: _init
Return Type: Void
Hidden: True
Static: False
Definition: hidden Void _init(String Scope, String Id, String Name, String Description)
```

## GetApiEndpointUri()
The `GetApiEndpointUri` static method is included on all API generated objects. It returns a formatted string for the API endpoint that is used to query objects of this class.

```yaml
Name: GetApiEndpointUri
Return Type: String
Hidden: False
Static: True
Definition: static String GetApiEndpointUri()
```

## ToString()
Creates a string representation of the `RedditOAuthScope` object.

```yaml
Name: ToString
Return Type: String
Hidden: False
Static: False
Definition: String ToString()
```


# EXAMPLES

## Creating a Full RedditOAuthScope Object
```powershell
Import-Module PSRAW
$Scope = [RedditOAuthScope]@{
    Scope = 'creddits'
    Id = 'creddits'
    Name = 'Spend reddit gold creddits'
    Description = 'Spend my reddit gold creddits on giving gold to other users.'
}
```

## Simple String Scope
```powershell
Import-Module PSRAW
$ReadScope = [RedditOAuthScope]'read'
```

# SEE ALSO
[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)