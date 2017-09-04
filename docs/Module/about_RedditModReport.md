# RedditModReport
## about_RedditModReport

# SHORT DESCRIPTION
Describes the RedditModReport Class

# LONG DESCRIPTION
A moderator report for a comment or submission.


# Constructors
## RedditModReport()
Creates an empty `RedditModReport` object.

```powershell
[RedditModReport]::new()
```


## RedditModReport(Object[] InputObjects)
Creates a `RedditModReport` from an array.

```powershell
[RedditModReport]::new([Object[]]$InputObjects)
```


# Properties
## Moderator
The reporting Moderator's Reddit username.

```yaml
Name: Moderator
Type: String
Hidden: False
Static: False
```

## Reason
The reason for the report.

```yaml
Name: Reason
Type: String
Hidden: False
Static: False
```


# Methods

# EXAMPLES
```powershell
$RedditModReport = [RedditModReport]@('Breaks Rule 12', 'markekraus')
```

# SEE ALSO

[about_RedditModReport](https://psraw.readthedocs.io/en/latest/Module/about_RedditModReport)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
