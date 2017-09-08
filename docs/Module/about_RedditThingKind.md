# RedditThingKind
## about_RedditThingKind

# SHORT DESCRIPTION
Describes the RedditThingKind Enum

# LONG DESCRIPTION
This s used by `RedditThing` objects to determine their kind.

# Fields
## listing
A listing is a list of Reddit Things

## more
A list of String ids that are the additional things that can be downloaded but are not because there are too many to list.

## t1
Reddit Comment

## t2
Reddit Account

## t3
Reddit Submission Link

## t4
Reddit Message

## t5
Reddit Subreddit

## t6
Reddit Award

## t8
Reddit Promotion Campaign


# EXAMPLES

## Example 1

```powershell
$Listing = [RedditThingKind]::listing
```

# SEE ALSO

[about_RedditThingKind](https://psraw.readthedocs.io/en/latest/Module/about_RedditThingKind)

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Import-RedditRequest)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
