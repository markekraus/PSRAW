# RedditMore
## about_RedditMore

# SHORT DESCRIPTION
Describes the RedditMore Class (experimental)

# LONG DESCRIPTION
Represents a `More` objects returned from teh reddit API. A more is returned containing a list of IDs when a listing contains too many items to return all of the data for all items. This happens, for example, when a submission has too many replies. X number or replies will be returned normally and the rest will be returned as a `More`. Another instance when a `More` is returned is when a comments is too deep in the reply chain that an empty More is returned to indicate the comment has replies that can be fetched separately.


# Constructors
## RedditMore()
Creates an empty `RedditMore` object

```powershell
[RedditMore]::new()
```

## RedditMore(RedditThing RedditThing)
Creates a `RedditMore` from a `RedditThing` containing a `More` returned from the reddit API.

```powershell
[RedditMore]::new([RedditThing]$RedditThing)
```


# Properties
## Children
IDs of the Children that were not returned

```yaml
Name: Children
Type: String[]
Hidden: False
Static: False
```

## Count
The number of Children

```yaml
Name: Count
Type: Int64
Hidden: False
Static: False
```

## Id
The `More`'s ID

```yaml
Name: Id
Type: String
Hidden: False
Static: False
```

## Kind
The kind. this should always be `More`

```yaml
Name: Kind
Type: RedditThingKind
Hidden: False
Static: False
```

## Name
The Reddit Fullname of the `More`

```yaml
Name: Name
Type: String
Hidden: False
Static: False
```

## Parent_Id
The Fullname of the parent that returned the more This is either a link or comment.

```yaml
Name: Parent_Id
Type: String
Hidden: False
Static: False
```

## ParentObject
This may contain the Parent object that returned the more

```yaml
Name: ParentObject
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## RedditThingKind
The kind. This should always be `More`

```yaml
Name: RedditThingKind
Type: RedditThingKind
Hidden: False
Static: True
```


# Methods

# NOTES

Experimental: This is an experimental feature. Expect radical changes between versions. Do not write production code against this until it has been marked stable.

# DERIVED FROM

[RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

# SEE ALSO

[about_RedditMore](https://psraw.readthedocs.io/en/latest/Module/about_RedditMore)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[about_RedditListing](https://psraw.readthedocs.io/en/latest/Module/about_RedditListing)

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
