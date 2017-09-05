# RedditLink
## about_RedditLink

# SHORT DESCRIPTION
Describes the RedditLink Class

# LONG DESCRIPTION
Represents a Reddit Link which can be either a Self-Post or a Link posted to a Subreddit.


# Constructors
## RedditLink()
Creates an Empty `RedditLink` object.

```powershell
[RedditLink]::new()
```

## RedditLink(RedditThing RedditThing)
Creates a `RedditLink` from a `RedditThing` representing a reddit Link returned from the API.

```powershell
[RedditLink]::new([RedditThing]$RedditThing)
```


# Properties
## ApiEndpointUri
The API endpoint url template used to generate the the API endpoint where the Link can be retrieved.

```yaml
Name: ApiEndpointUri
Type: String
Hidden: False
Static: True
```

## approved_at_utc
The UTC time the link was approved by a moderator.

```yaml
Name: approved_at_utc
Type: RedditDate
Hidden: False
Static: False
```

## approved_by
The Moderator who approved the link.

```yaml
Name: approved_by
Type: String
Hidden: False
Static: False
```

## archived
If true, the link has been archived.

```yaml
Name: archived
Type: Boolean
Hidden: False
Static: False
```

## author
The Reddit username of the author of the link.

```yaml
Name: author
Type: String
Hidden: False
Static: False
```

## author_flair_css_class
The flair CSS class for the author

```yaml
Name: author_flair_css_class
Type: String
Hidden: False
Static: False
```

## author_flair_text
The text for the author's flair.

```yaml
Name: author_flair_text
Type: String
Hidden: False
Static: False
```

## banned_at_utc
The UTC time the link was banned by a moderator.

```yaml
Name: banned_at_utc
Type: RedditDate
Hidden: False
Static: False
```

## banned_by
The username of the moderator who banned the link.

```yaml
Name: banned_by
Type: String
Hidden: False
Static: False
```

## brand_safe
This is true if Reddit has determined the subreddit the Link was posted in is safe for advertising.

```yaml
Name: brand_safe
Type: Boolean
Hidden: False
Static: False
```

## can_gild
Whether or not this link can be "gilded" by giving the link author Reddit Gold.

```yaml
Name: can_gild
Type: Boolean
Hidden: False
Static: False
```

## can_mod_post
Unknown

```yaml
Name: can_mod_post
Type: Boolean
Hidden: False
Static: False
```

## clicked
Whether or not the link has been clicked by the user.

```yaml
Name: clicked
Type: Boolean
Hidden: False
Static: False
```

## contest_mode
If true, the link has been set to Contest mode.  https://www.reddit.com/r/bestof2012/comments/159bww/introducing_contest_mode_a_tool_for_your_voting/

```yaml
Name: contest_mode
Type: Boolean
Hidden: False
Static: False
```

## created
The localized time the link was created

```yaml
Name: created
Type: RedditDate
Hidden: False
Static: False
```

## created_utc
The UTC time the link was created

```yaml
Name: created_utc
Type: RedditDate
Hidden: False
Static: False
```

## distinguished
Whether or not the link has been distinguished by a moderator.

```yaml
Name: distinguished
Type: String
Hidden: False
Static: False
```

## domain
The domain of the URL the link was submitted for.

```yaml
Name: domain
Type: String
Hidden: False
Static: False
```

## downs
Number of DownVotes

```yaml
Name: downs
Type: Int64
Hidden: False
Static: False
```

## edited
The UNIX Time stamp the link has been edited or false

```yaml
Name: edited
Type: Decimal
Hidden: False
Static: False
```

## gilded
The number of times the link has been gilded.

```yaml
Name: gilded
Type: Int64
Hidden: False
Static: False
```

## hidden
Whether or not the link has been hidden by the user.

```yaml
Name: hidden
Type: Boolean
Hidden: False
Static: False
```

## hide_score
Whether or not the score is hidden.

```yaml
Name: hide_score
Type: Boolean
Hidden: False
Static: False
```

## id
The ID of the link submission.

```yaml
Name: id
Type: String
Hidden: False
Static: False
```

## is_self
Whether or not the link is a self-post.

```yaml
Name: is_self
Type: Boolean
Hidden: False
Static: False
```

## is_video
Whether or not the link is a video post.

```yaml
Name: is_video
Type: Boolean
Hidden: False
Static: False
```

## likes
Whether the user likes (upvoted) the link or not

```yaml
Name: likes
Type: Boolean
Hidden: False
Static: False
```

## link_flair_css_class
The CSS for the link's flair

```yaml
Name: link_flair_css_class
Type: String
Hidden: False
Static: False
```

## link_flair_text
The text for the link's flair.

```yaml
Name: link_flair_text
Type: String
Hidden: False
Static: False
```

## locked
Whether or not the link has been locked.

```yaml
Name: locked
Type: Boolean
Hidden: False
Static: False
```

## media
An object containing information about the media in media posts.

```yaml
Name: media
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## media_embed
Object containing information about the embedded media in media posts.

```yaml
Name: media_embed
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## mod_reports
An array of reports made by Moderators on this link.

```yaml
Name: mod_reports
Type: RedditModReport[]
Hidden: False
Static: False
```

## name
The reddit Fullname of the link.

```yaml
Name: name
Type: String
Hidden: False
Static: False
```

## num_comments
The number of comments the link has.

```yaml
Name: num_comments
Type: Int64
Hidden: False
Static: False
```

## num_reports
The number of reports the link has.

```yaml
Name: num_reports
Type: Int64
Hidden: False
Static: False
```

## over_18
Whether or not the link is NSFW.

```yaml
Name: over_18
Type: Boolean
Hidden: False
Static: False
```

## parent_whitelist_status
Unknown


```yaml
Name: parent_whitelist_status
Type: String
Hidden: False
Static: False
```

## ParentObject
The Parent Object of this Link. It may be a listing or the API response.

```yaml
Name: ParentObject
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## permalink
The permalink to link.

```yaml
Name: permalink
Type: String
Hidden: False
Static: False
```

## Prefix
The prefix of the Reddit Thing this should always be `t3`

```yaml
Name: Prefix
Type: RedditThingPrefix
Hidden: False
Static: False
```

## quarantine
Whether or not the link has been quarantined.

```yaml
Name: quarantine
Type: Boolean
Hidden: False
Static: False
```

## RedditThingKind
The Kind of Reddit Thing. this should always be `t3`

```yaml
Name: RedditThingKind
Type: RedditThingKind
Hidden: False
Static: True
```

## removal_reason
The reason the link was removed by a moderator.

```yaml
Name: removal_reason
Type: String
Hidden: False
Static: False
```

## report_reasons
Reasons the link has been reported.

```yaml
Name: report_reasons
Type: String[]
Hidden: False
Static: False
```

## saved
Whether or not the user has saved the link.

```yaml
Name: saved
Type: Boolean
Hidden: False
Static: False
```

## score
The score of the link

```yaml
Name: score
Type: Int64
Hidden: False
Static: False
```

## secure_media
An object containing information about the secure media in a media post.

```yaml
Name: secure_media
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## secure_media_embed
Object containing information about the secure embedded media in a media post.

```yaml
Name: secure_media_embed
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## selftext
The text of a self-post.

```yaml
Name: selftext
Type: String
Hidden: False
Static: False
```

## selftext_html
The HTML version of the text in a self-post.

```yaml
Name: selftext_html
Type: String
Hidden: False
Static: False
```

## spoiler
Whether or not the link has been marked as a spoiler.

```yaml
Name: spoiler
Type: Boolean
Hidden: False
Static: False
```

## stickied
Whether or not a mod as stickied the post in the subreddit.

```yaml
Name: stickied
Type: Boolean
Hidden: False
Static: False
```

## subreddit
The name of the subreddit the link was posted in (without the prefix)

```yaml
Name: subreddit
Type: String
Hidden: False
Static: False
```

## subreddit_id
The Reddit Fullname of the subreddit

```yaml
Name: subreddit_id
Type: String
Hidden: False
Static: False
```

## subreddit_name_prefixed
The name of the subreddit prefixed with `r/`

```yaml
Name: subreddit_name_prefixed
Type: String
Hidden: False
Static: False
```

## subreddit_type
The type of subreddit (public, restricted, etc)

```yaml
Name: subreddit_type
Type: String
Hidden: False
Static: False
```

## suggested_sort
The suggested sort order for comments made to the link.

```yaml
Name: suggested_sort
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## thumbnail
Full url to the thumbnail for the post.

```yaml
Name: thumbnail
Type: String
Hidden: False
Static: False
```

## title
The title of the link post.

```yaml
Name: title
Type: String
Hidden: False
Static: False
```

## ups
The number of upvotes

```yaml
Name: ups
Type: Int64
Hidden: False
Static: False
```

## upvote_ratio
The ratio of upvotes to all votes.

```yaml
Name: upvote_ratio
Type: Double
Hidden: False
Static: False
```

## url
The url of the link.

```yaml
Name: url
Type: Uri
Hidden: False
Static: False
```

## user_reports
An array of reports made by users against the link.

```yaml
Name: user_reports
Type: RedditUserReport[]
Hidden: False
Static: False
```

## view_count
The times the link has been viewed

```yaml
Name: view_count
Type: int64
Hidden: False
Static: False
```

## visited
Whether or not the user has visited the link.

```yaml
Name: visited
Type: Boolean
Hidden: False
Static: False
```

## whitelist_status
unknown

```yaml
Name: whitelist_status
Type: String
Hidden: False
Static: False
```


# Methods
## GetApiEndpointUri()
Returns the API endpoint for the current instance.

```yaml
Name: GetApiEndpointUri
Return Type: String
Hidden: False
Static: False
Definition: String GetApiEndpointUri()
```

## GetFullName()
Returns the Reddit Fullname for the current instance.

```yaml
Name: GetFullName
Return Type: String
Hidden: False
Static: False
Definition: String GetFullName()
```

## ToString()
Overrides `ToString()` to return the subreddit, author, and link title.

```yaml
Name: ToString
Return Type: String
Hidden: False
Static: False
Definition: String ToString()
```

# DERIVED FROM

[RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

# SEE ALSO

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditMore](https://psraw.readthedocs.io/en/latest/Module/about_RedditMore)

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

[about_RedditDate](https://psraw.readthedocs.io/en/latest/Module/about_RedditDate)

[about_RedditListing](https://psraw.readthedocs.io/en/latest/Module/about_RedditListing)

[about_RedditModReport](https://psraw.readthedocs.io/en/latest/Module/about_RedditModReport)

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[about_RedditUserReport](https://psraw.readthedocs.io/en/latest/Module/about_RedditUserReport)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
