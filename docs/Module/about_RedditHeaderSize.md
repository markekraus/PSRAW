# RedditHeaderSize
## about_RedditHeaderSize

# SHORT DESCRIPTION
Describes the RedditHeaderSize Class

# LONG DESCRIPTION
Represents the size of a Subreddit Header


# Constructors
## RedditHeaderSize()
Creates an empty `RedditHeaderSize`

```powershell
[RedditHeaderSize]::new()
```

## RedditHeaderSize(Object[] InputObjects)
Creates a `RedditHeaderSize` from an array where the first element is the width and the second element is the height. This is how the Reddit API returns the object.

```powershell
[RedditHeaderSize]::new([Object[]]$InputObjects)
```


# Properties
## Height
The Height of the Header

```yaml
Name: Height
Type: Int64
Hidden: False
Static: False
```

## Width
The Width of the Header

```yaml
Name: Width
Type: Int64
Hidden: False
Static: False
```


# Methods

# SEE ALSO

[about_RedditHeaderSize](https://psraw.readthedocs.io/en/latest/Module/about_RedditHeaderSize)

[about_RedditSubreddit](https://psraw.readthedocs.io/en/latest/Module/about_RedditSubreddit)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
