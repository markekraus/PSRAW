# RedditThing
## about_RedditThing

# SHORT DESCRIPTION
Describes the RedditThing Class

# LONG DESCRIPTION
This is a meta-class used for objects returned from the reddit API. "Reddit Things" describe what the returned object is, such as a listing, a comment, a submission, a subreddit, a user, etc. 

The `RedditThing` Class is imported automatically when you import the PSRAW module.

# Constructors
## RedditThing()
Creates an empty `RedditThing`

```powershell
[RedditThing]::new()
```


## RedditThing(System.Management.Automation.PSObject Object)
{{ Constructor Description Placeholder }}

```powershell
[RedditThing]::new([System.Management.Automation.PSObject]$Object)
```


# Properties
## Data
The "Thing" being returned such as a listing, a comment, a submission, a subreddit, a user, etc.

```yaml
Name: Data
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```


## Id
The ID for the object may also be returned with the Reddit Thing meta-data. For Things without ID's (such as a listing), this will be empty.

```yaml
Name: Id
Type: String
Hidden: False
Static: False
```

## Kind
The `RedditThingKind` that identifies what kind of Reddit Thing this is.

```yaml
Name: Kind
Type: RedditThingKind
Hidden: False
Static: False
```

## Name
The Reddit Name for the object may also be returned with the Reddit Thing meta-data. For Things without Reddit Names (such as a listing), this will be empty.

```yaml
Name: Name
Type: String
Hidden: False
Static: False
```


## Parent
If A Reddit Thing was a child of something like a listing, the `Parent` may contain the parent object.

```yaml
Name: Parent
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```


## RedditData
{{ Property Description Placeholder }}

```yaml
Name: RedditData
Type: RedditDataObject
Hidden: False
Static: False
```


# Methods

## CreateFrom(RedditApiResponse Response)
{{ Method Description Placeholder }}

```yaml
Name: CreateFrom
Return Type: RedditThing[]
Hidden: False
Static: True
Definition: static RedditThing[] CreateFrom(RedditApiResponse Response)
```


# EXAMPLES

## Example 1

```powershell
[RedditThing]@{
    AccessToken = $Token
    Kind        = 'Listing'
    Data        = $Object
}
```


# SEE ALSO

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Import-RedditRequest)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
