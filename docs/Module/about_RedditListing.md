# RedditListing
## about_RedditListing

# SHORT DESCRIPTION
Describes the RedditListing Class

# LONG DESCRIPTION
{{ Long Description Placeholder }}


# Constructors
## RedditListing()
{{ Constructor Description Placeholder }}

```powershell
[RedditListing]::new()
```

## RedditListing(RedditThing RedditThing)
{{ Constructor Description Placeholder }}

```powershell
[RedditListing]::new([RedditThing]$RedditThing)
```


# Properties
## After
{{ Property Description Placeholder }}

```yaml
Name: After
Type: String
Hidden: False
Static: False
```

## Before
{{ Property Description Placeholder }}

```yaml
Name: Before
Type: String
Hidden: False
Static: False
```

## ChildKinds
{{ Property Description Placeholder }}

```yaml
Name: ChildKinds
Type: RedditThingKind[]
Hidden: False
Static: False
```

## Children
{{ Property Description Placeholder }}

```yaml
Name: Children
Type: RedditThing[]
Hidden: False
Static: False
```

## Items
{{ Property Description Placeholder }}

```yaml
Name: Items
Type: RedditDataObject[]
Hidden: False
Static: False
```

## Kind
{{ Property Description Placeholder }}

```yaml
Name: Kind
Type: RedditThingKind
Hidden: False
Static: False
```

## Modhash
{{ Property Description Placeholder }}

```yaml
Name: Modhash
Type: String
Hidden: False
Static: False
```

## ParentObject
{{ Property Description Placeholder }}

```yaml
Name: ParentObject
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## RedditThingKind
{{ Property Description Placeholder }}

```yaml
Name: RedditThingKind
Type: RedditThingKind
Hidden: False
Static: True
```


# Methods
## GetComments()
{{ Method Description Placeholder }}

```yaml
Name: GetComments
Return Type: RedditComment[]
Hidden: False
Static: False
Definition: RedditComment[] GetComments()
```

## GetLinks()
{{ Method Description Placeholder }}

```yaml
Name: GetLinks
Return Type: RedditLink[]
Hidden: False
Static: False
Definition: RedditLink[] GetLinks()
```

## GetMores()
{{ Method Description Placeholder }}

```yaml
Name: GetMores
Return Type: RedditMore[]
Hidden: False
Static: False
Definition: RedditMore[] GetMores()
```


# EXAMPLES
{{ Code or descriptive examples of how to leverage the functions described. }}

# NOTE
{{ Note Placeholder - Additional information that a user needs to know.}}

# TROUBLESHOOTING NOTE
{{ Troubleshooting Placeholder - Warns users of bugs}}

{{ Explains behavior that is likely to change with fixes }}

# DERIVED FROM

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/Resolve-RedditDataObject)

# SEE ALSO


[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
