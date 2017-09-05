# RedditUserReport
## about_RedditUserReport

# SHORT DESCRIPTION
Describes the RedditUserReport Class

# LONG DESCRIPTION
`RedditUserReport` represent reports made by a users on a link or comment. These will only be visible to subreddit moderators.

# Constructors
## RedditUserReport()
Creates an empty `RedditUserReport` object.

```powershell
[RedditUserReport]::new()
```


## RedditUserReport(Object[] InputObjects)
Creates `RedditUserReport` from an object array

```powershell
[RedditUserReport]::new([Object[]]$InputObjects)
```


# Properties
## Count
The number of times this reason has been reported

```yaml
Name: Count
Type: Int64
Hidden: False
Static: False
```

## Reason
The reason provided by the user(s).

```yaml
Name: Reason
Type: String
Hidden: False
Static: False
```


# Methods

# EXAMPLES
```powershell
[RedditUserReport]@{
    Reason = 'Spam'
    Count  = 5
}
```

# SEE ALSO

[about_RedditUserReport](https://psraw.readthedocs.io/en/latest/Module/about_RedditUserReport)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
