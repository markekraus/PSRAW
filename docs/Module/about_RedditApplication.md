# RedditApplication Class
## about_RedditApplication           

# SHORT DESCRIPTION
Describes the RedditApplication Class

# LONG DESCRIPTION
The RedditApplication class is used to define the parameters of an application which access the Reddit API. The RedditApplication class becomes imbedded in the [RedditOAuthAcessToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthAcessToken) class after an OAuth Access token is requested. A single Application may be used by multiple users or by a single user multiple time. Each user requires their own Access Token and a single user can have multiple Access Token. The RedditApplication class makes it possible to define an application’s parameters once and then reuse it multiple times in multiple Access Tokens. 

A RedditApplication class houses the Client ID and Client Secret as defined at [https://ssl.reddit.com/prefs/apps](https://ssl.reddit.com/prefs/apps). The Name and Description of the RedditApplication do not need to match what is registered with Reddit. They are provided along with the GUID property as a convenience to identify your applications.

A RedditApplication is required to request an Authorization Code with [Request-RedditOAuthAuthorzationCode](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthAuthorzationCode).

You can create RedditApplication objects using the [New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication) function

The RedditApplication class is imported from a nested module located at PSRAW\Classes\RedditApplication.psm1. This means you can import the class either from the PSRAW module or directly from the nested module.

## Constructors

### RedditApplication()
The default constructor will always throw an System.NotImplementedException exception. It is included because PowerShell v5 classes behave oddly when a default constructor is missing. This constructor cannot be used to create an instance of the class.

```powershell
[RedditApplicaion]::new()
```

## RedditApplication([System.Collections.Hashtable]$InitHash)
This constructor passes the provided HashTable to the _int([System.Collections.Hashtable]$InitHash) method. This constructor provides HashTable to RedditApplication conversion.

```powershell
[RedditApplicaion]::new([System.Collections.Hashtable]$InitHash)
```

## RedditApplication ([PSObject]$PSObject)
This constructor converts the provided PSObject to a hashtable and passes it to the _int([System.Collections.Hashtable]$InitHash) method. This constructor provides PSObject to RedditApplication converstion.

```powershell
[RedditApplicaion]::new([PSObject]$PSObject)
```

## RedditApplication([String]$Name,[String]$Description,[uri]$RedirectUri,[String]$UserAgent,[RedditApplicationType]$Type,[guid]$GUID,[string]$ExportPath,[RedditScope[]]$Scope,[System.Management.Automation.PSCredential]$ClientCredential,[System.Management.Automation.PSCredential]$UserCredential)
This constructor converts the arguments to a HashTable and pass them to the _int([System.Collections.Hashtable]$InitHash) method. 

```powershell
[RedditApplicaion]::new(
    [String]$Name,
    [String]$Description,
    [uri]$RedirectUri,
    [String]$UserAgent,
    [RedditApplicationType]$Type,
    [guid]$GUID,
    [string]$ExportPath,
    [RedditScope[]]$Scope,
    [System.Management.Automation.PSCredential]$ClientCredential,
    [System.Management.Automation.PSCredential]$UserCredential
)
```

## Properties

### Name
The name of the application used for convenience of identifying the RedditApplication object only

```yaml
Data Type: String
Name: Name
Default value: None
Access: Public
Scope: Instance
```

### Description
A description for the application used for conevnience of identifying and documenting the RedditApplication object only.

```yaml
Data Type: String
Name: Description
Default value: None
Access: Public
Scope: Instance
```

### RedirectUri
The Redirect URI for the application. This must match the Redirect URI registered at google. This is required byt Reddit's OAuth to request both Authorization codes and Access Tokens.

```yaml
Data Type: Uri
Name: RedirectUri
Default value: None
Access: Public
Scope: Instance
```

### UserAgent
The UserAgent property contains the text thatwill be sent as the User-Agent header to the Reddit API. Redit requires applications accessing their API provide a meaningful user agent. The following convetion is what they recommend.

```
<platform>:<app ID>:<version string> (by /u/<reddit username>)
```

Example:

```
windows:MyPSRAW-App:v1.2.3 (by /u/markekraus)
```

See [https://github.com/reddit/reddit/wiki/API#rules](https://github.com/reddit/reddit/wiki/API#rules) for more details.

```yaml
Data Type: Uri
Name: UserAgent
Default value: None
Access: Public
Scope: Instance
```

### Type
The Type property is one of the avialble [RedditAplicationType](https://psraw.readthedocs.io/en/latest/Module/about_RedditAplicationType) enum options. This should match the application type registered on Reddit.


```yaml
Data Type: RedditApplicationType
Name: Type
Default value: None
Access: Public
Scope: Instance
```

### ClientID
The ClientID property is the Client ID as provided by reddit when the application is registered. This should match the username of the ClientCredential. Changing this is not recommended.

```yaml
Data Type: String
Name: ClientID
Default value: None
Access: Public
Scope: Instance
```

### GUID
A Guid used to help identify the application. This is provided for convenience and is not sent to or required by the API.

```yaml
Data Type: Guid
Name: GUID
Default value: None
Access: Public
Scope: Instance
```

### ExportPath
This is the path the RedditApplication was last imported from or where you wish to export it to. It is provided for interaction with [Import-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Import-RedditApplication) and [Export-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Export-RedditApplication). This should be the literal path of the file.

```yaml
Data Type: String
Name: ExportPath
Default value: None
Access: Public
Scope: Instance
```

### ScriptUser 
The ScriptUser property is the Reddit username used for Script Applications. This should match the uername in the UserCrednetial property

```yaml
Data Type: String
Name: ExportPath
Default value: None
Access: Public
Scope: Instance
```

### Scope
The Scope property is an array of [RedditScope](https://psraw.readthedocs.io/en/latest/Module/about_RedditScope) objects which list the scopes for which the Application will request access to. To get all valid scopes use [Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope).

```yaml
Data Type: RedditScope[]
Name: Scope
Default value: None
Access: Public
Scope: Instance
```

### ClientCredential
The ClientCredential property contains a PSCredential object where the Username is the Application's Client ID and the password is the Client Secret as configired in reddit. For Installed applications, the password can be anything as it will be ignored.

```yaml
Data Type: System.Management.Automation.PSCredential
Name: ClientCredential
Default value: None
Access: Hidden
Scope: Instance
```

### UserCredential
The UserCredential property contains a PSCredential object where the username and passwords are the Reddit Username and password used for Script Applications. Fore WebApp and Installed apps, this is not required and will be ignored.

```yaml
Data Type: System.Management.Automation.PSCredential
Name: UserCredential
Default value: None
Access: Hidden
Scope: Instance
```

## Methods

### GetClientSecret()
The GetClientSecret method is used to retrieve the plaintext Client Secret which is stored as the password of the ClientCredential. This is used in various functions to retrieve the Client Secret in order to authenticate the application with OAuth.

```yaml
Data Type: String
Name: GetClientSecret
Access: Public
Scope: Instance
Definition: string GetClientSecret()
```

###  GetUserPassword()
The  GetUserPassword method is used to retrieve the plaintext user password which is stored as the password of the UserCredential. This is used in various functions to retrieve the user password in order to authenticate script applications with OAuth.

```yaml
Data Type: String
Name:  GetUserPassword
Access: Public
Scope: Instance
Definition: string  GetUserPassword()
```

### _init([System.Collections.Hashtable]$InitHash)
The _init hidden method is used by the constructors to initialize the class. This way class initialization code can be maintained in a single methods instead of each constructor. It performs serveral checks to ensure that required properties are provided and will throw System.ArgumentException exceptions if the requirements are not met.

```yaml
Data Type: Void
Name: _init
Access: Hidden
Scope: Instance
Definition: hidden void _init(System.Collections.Hashtable InitHash)
```

# EXAMPLES

## Create WebApp RedditApplication
```powershell
Using module '.\PSRAW\Classes\RedditApplication.psm1'
$ClientCredential = Get-Credential
$App = [RedditApplication]@{
     Name = 'TestApplication'
     Description = 'This is only a test'
     RedirectUri = 'https://localhost/'
     UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
     Scope = 'read'
     ClientCredential = $ClientCredential
     Type = 'WebApp'
 }
```

## Create Script RedditApplication
```powershell
Using module PSRAW
$UserCredential = Get-Credential
$ClientCredential = Get-Credential
$App = [PSRAW.RedditApplication]@{
    Name = 'TestApplication'
    Description = 'This is only a test'
    RedirectUri = 'https://localhost/'
    UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope = 'read'
    ClientCredential = $ClientCredential
    UserCredential = $UserCredential
    Type = 'Script'
}
```

## Create Installed RedditApplication
```powershell
Using module '.\PSRAW\Classes\RedditApplication.psm1'
$ClientCredential = Get-Credential
$App = [RedditApplication]@{
     Name = 'TestApplication'
     Description = 'This is only a test'
     RedirectUri = 'https://localhost/'
     UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
     Scope = 'read'
     ClientCredential = $ClientCredential
     Type = 'Installed'
 }
```

# SEE ALSO
[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Get-RedditOAuthScope](https://psraw.readthedocs.io/en/latest/Module/Get-RedditOAuthScope)

[about_RedditAplicationType](https://psraw.readthedocs.io/en/latest/Module/about_RedditAplicationType)

[about_RedditScope](https://psraw.readthedocs.io/en/latest/Module/about_RedditScope)

[https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)

[https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)

[https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)