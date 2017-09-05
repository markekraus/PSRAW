# RedditListing
## about_RedditListing

# SHORT DESCRIPTION
Describes the RedditListing Class

# LONG DESCRIPTION
Represents a `Listing` returned from the Reddit API. Listings contain collections of children such as Comments, links, and Subreddits. For example, when querying the top 100 links form a subreddit, a listing containing the Reddit `Thing`s for those 100 links is returned by the API.


# Constructors
## RedditListing()
Creates an empty `RedditListing` object

```powershell
[RedditListing]::new()
```

## RedditListing(RedditThing RedditThing)
Creates a `RedditListing` object from a `RedditThing` containing a `Listing` returned by the Reddit API.

```powershell
[RedditListing]::new([RedditThing]$RedditThing)
```


# Properties
## After
The Reddit Fullname of the listing that follows after this page. null if there is no next page.

```yaml
Name: After
Type: String
Hidden: False
Static: False
```

## Before
The Reddit Fullname of the listing that follows before this page. null if there is no previous page.

```yaml
Name: Before
Type: String
Hidden: False
Static: False
```

## ChildKinds
Array of unique `RedditThingKind` kinds for children of the listing.

```yaml
Name: ChildKinds
Type: RedditThingKind[]
Hidden: False
Static: False
```

## Children
`RedditThing`s of all child objects of the `Listing`

```yaml
Name: Children
Type: RedditThing[]
Hidden: False
Static: False
```

## Items
Resolved PSRAW objects of the Children of the `Listing` for example, if the listing is a list of comments, the `RedditComment` objects will be available under `Items`.

```yaml
Name: Items
Type: RedditDataObject[]
Hidden: False
Static: False
```

## Kind
The kind. This should always be `Listing`

```yaml
Name: Kind
Type: RedditThingKind
Hidden: False
Static: False
```

## Modhash
Modhashes are not required when authenticated with OAuth and thus may not appears when using PSRAW.

A modhash is a token that the reddit API requires to help prevent CSRF. Modhashes can be obtained via the /api/me.json call or in response data of listing endpoints.

```yaml
Name: Modhash
Type: String
Hidden: False
Static: False
```

## ParentObject
This may contain the Parent Object of the listing. This could be a `RedditSbmission`, `RedditComment`, `RedditApiResponse` or a `RedditThing`.

```yaml
Name: ParentObject
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## RedditThingKind
The kind. This should always be `Listing`

```yaml
Name: RedditThingKind
Type: RedditThingKind
Hidden: False
Static: True
```


# Methods
## GetComments()
Returns all `RedditComment` children of the listing.

```yaml
Name: GetComments
Return Type: RedditComment[]
Hidden: False
Static: False
Definition: RedditComment[] GetComments()
```

## GetLinks()
Returns all `RedditLink` children of the listing.

```yaml
Name: GetLinks
Return Type: RedditLink[]
Hidden: False
Static: False
Definition: RedditLink[] GetLinks()
```

## GetMores()
Returns all `RedditMore` children of the listing.

```yaml
Name: GetMores
Return Type: RedditMore[]
Hidden: False
Static: False
Definition: RedditMore[] GetMores()
```


# DERIVED FROM

[RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

# SEE ALSO

[about_RedditListing](https://psraw.readthedocs.io/en/latest/Module/about_RedditListing)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[about_RedditMore](https://psraw.readthedocs.io/en/latest/Module/about_RedditMore)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
