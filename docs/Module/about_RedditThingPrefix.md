# RedditThingPrefix
## about_RedditThingPrefix

# SHORT DESCRIPTION
Describes the RedditThingPrefix Enum

# LONG DESCRIPTION
An data object returned from the Reddit API will have a type prefix to identify what kind of Reddit Thing it is. This is subset of `RedditThingKind` is only used with data objects such as comments, accounts, and links and not with collection objects such as `more`s and `listing`s.

The `RedditThingPrefix` Enumerator is imported automatically when you import the PSRAW module.


# Fields
## t1
Comment

## t2
Account

## t3
Link

## t4
Message

## t5
Subreddit

## t6
Award

## t8
Promotion campaign


# EXAMPLES

## Example 1

```powershell
$Comment = [RedditThingPrefix]::t1
```

# SEE ALSO

[about_RedditThingPrefix](https://psraw.readthedocs.io/en/latest/Module/about_RedditThingPrefix)

[about_RedditThingKind](https://psraw.readthedocs.io/en/latest/Module/about_RedditThingKind)

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Import-RedditRequest)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
