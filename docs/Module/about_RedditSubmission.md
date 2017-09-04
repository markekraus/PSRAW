# RedditSubmission
## about_RedditSubmission

# SHORT DESCRIPTION
Describes the RedditSubmission Class

# LONG DESCRIPTION
A `RedditSubmission` object contains the link and comments returned from a Reddit submission.


# Constructors
## RedditSubmission()
Creates an empty `RedditSubmission` object

```powershell
[RedditSubmission]::new()
```

## RedditSubmission(RedditApiResponse ApiResponse)
Creates a `RedditSubmission` from a `RedditApiResponse` returned from `Invoke-RedditRequest`.

```powershell
[RedditSubmission]::new([RedditApiResponse]$ApiResponse)
```


# Properties
## Comments
An array of comments in reply to the submission.

```yaml
Name: Comments
Type: RedditComment[]
Hidden: False
Static: False
```

## Link
The link or self-post of the submission.

```yaml
Name: Link
Type: RedditLink
Hidden: False
Static: False
```


# Methods

# DERIVED FROM

[RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

# SEE ALSO

[about_RedditSubmission](https://psraw.readthedocs.io/en/latest/Module/about_RedditSubmission)

[about_RedditApiResponse](https://psraw.readthedocs.io/en/latest/Module/about_RedditApiResponse)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
