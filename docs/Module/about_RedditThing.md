# RedditThing
## about_RedditThing

# SHORT DESCRIPTION
Describes the RedditThing Class

# LONG DESCRIPTION
This is a meta-class used for objects returned from the reddit API. "Reddit Things" describe what the returned object is, such as a listing, a comment, a submission, a subreddit, etc.

# Constructors
## RedditThing()
Creates an empty `RedditThing`

```powershell
[RedditThing]::new()
```


## RedditThing(System.Management.Automation.PSObject Object)
Creates a `RedditThing` form a `PSObject` converted from JSON Reddit API response.

```powershell
[RedditThing]::new([System.Management.Automation.PSObject]$Object)
```


# Properties
## Data
The "Thing" being returned such as a listing, a comment, a submission, a subreddit, etc.

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


## ParentObject
If A Reddit Thing was a child of something like a listing, the `ParentObject` may contain the parent object.

```yaml
Name: Parent
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```


## RedditData
A converted `RedditDataObject` of the `RedditThing`. For example, it the `RedditThing` is a comment, `RedditData` will contain the converted `RedditComment` object.

```yaml
Name: RedditData
Type: RedditDataObject
Hidden: False
Static: False
```


# Methods

## CreateFrom(RedditApiResponse Response)
Generates `RedditThings` from a `RedditApiResponse` returned from `Invoke-RedditRequest`. A `RedditApiResponse` may contain multiple `RedditThings` in the response.

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
    Kind        = 'Listing'
    Data        = $Object
}
```

## Example 2

```powershell
$Response = Invoke-RedditRequest -Uri $Uri
$Things = [RedditThing]::CreateFrom($Response)
```


# SEE ALSO

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[about_RedditApiResponse](https://psraw.readthedocs.io/en/latest/Module/about_RedditApiResponse)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Import-RedditRequest)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
