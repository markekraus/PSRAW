# RedditSubreddit
## about_RedditSubreddit

# SHORT DESCRIPTION
Describes the RedditSubreddit Class (experimental)

# LONG DESCRIPTION
Contains information about a Reddit Subreddit.


# Constructors
## RedditSubreddit()
Creates an Empty `RedditSubreddit` object.

```powershell
[RedditSubreddit]::new()
```

## RedditSubreddit(RedditThing RedditThing)
Creates a `RedditSubreddit` object from a `RedditThing` containing a Subreddit returned from the Reddit API.

```powershell
[RedditSubreddit]::new([RedditThing]$RedditThing)
```


# Properties
## accounts_active
Th number of users active in last 15 minutes

```yaml
Name: accounts_active
Type: Int64
Hidden: False
Static: False
```

## accounts_active_is_fuzzed
Whether the number in `accounts_active` is "fuzzed" or not

```yaml
Name: accounts_active_is_fuzzed
Type: Boolean
Hidden: False
Static: False
```

## active_user_count
unknown

```yaml
Name: active_user_count
Type: Int64
Hidden: False
Static: False
```

## advertiser_category
The category of advertising used in the the subreddit.

```yaml
Name: advertiser_category
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## allow_images
Whether or not the subreddit allows images

```yaml
Name: allow_images
Type: Boolean
Hidden: False
Static: False
```

## ApiEndpointUri
The URL template use to generate the ApiEndpointUri for a subreddit.

```yaml
Name: ApiEndpointUri
Type: String
Hidden: False
Static: True
```

## audience_target
The audience types the subreddit targets.

```yaml
Name: audience_target
Type: String
Hidden: False
Static: False
```

## banner_img
Mobile banner image

```yaml
Name: banner_img
Type: String
Hidden: False
Static: False
```

## banner_size
Size of Mobile Banner Image

```yaml
Name: banner_size
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## collapse_deleted_comments
Whether or not deleted comments are collapsed.

```yaml
Name: collapse_deleted_comments
Type: Boolean
Hidden: False
Static: False
```

## comment_score_hide_mins
Comments with a score below this will be hidden in the subreddit

```yaml
Name: comment_score_hide_mins
Type: Int64
Hidden: False
Static: False
```

## created
The localize time the subreddit was created.

```yaml
Name: RedditDate
Type: Double
Hidden: False
Static: False
```

## created_utc
The UTC time the subreddit was created.

```yaml
Name: created_utc
Type: Double
Hidden: False
Static: False
```

## description
The description of the subreddit

```yaml
Name: description
Type: String
Hidden: False
Static: False
```

## description_html
The HTML version of the description text.

```yaml
Name: description_html
Type: String
Hidden: False
Static: False
```

## display_name
The human name of the subreddit (without the prefix)

```yaml
Name: display_name
Type: String
Hidden: False
Static: False
```

## display_name_prefixed
The human name of the subreddit with the `r/` prefix

```yaml
Name: display_name_prefixed
Type: String
Hidden: False
Static: False
```

## header_img
The full URL to the header image

```yaml
Name: header_img
Type: String
Hidden: False
Static: False
```

## header_size
The width and height of the header image

```yaml
Name: header_size
Type: RedditHeaderSize
Hidden: False
Static: False
```

## header_title
The description of header image shown on hover

```yaml
Name: header_title
Type: String
Hidden: False
Static: False
```

## hide_ads
Whether or not the user has chosen to hide ads in ths subreddit.

```yaml
Name: hide_ads
Type: Boolean
Hidden: False
Static: False
```

## icon_img
URL of the Mobile Icon for the subreddit

```yaml
Name: icon_img
Type: String
Hidden: False
Static: False
```

## icon_size
Size of the Mobile Icon for the subreddit

```yaml
Name: icon_size
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## id
The id of the subreddit

```yaml
Name: id
Type: String
Hidden: False
Static: False
```

## key_color
The key color for Mobile

```yaml
Name: key_color
Type: String
Hidden: False
Static: False
```

## Kind
The Kind of `RedditThing`. this should always be `t5`

```yaml
Name: Kind
Type: RedditThingKind
Hidden: False
Static: False
```

## lang
The language of the subreddit

```yaml
Name: lang
Type: String
Hidden: False
Static: False
```

## link_flair_enabled
Whether or not link flair is enabled

```yaml
Name: link_flair_enabled
Type: Boolean
Hidden: False
Static: False
```

## name
The Reddit Fullname of the subreddit

```yaml
Name: name
Type: String
Hidden: False
Static: False
```

## over18
Whether or not the subreddit is NSFW

```yaml
Name: over18
Type: Boolean
Hidden: False
Static: False
```

## ParentObject
The Parent Object of the subreddit. This could be a listing or a more.

```yaml
Name: ParentObject
Type: System.Management.Automation.PSObject
Hidden: False
Static: False
```

## Prefix
The prefix type. this should always be `t5`

```yaml
Name: Prefix
Type: RedditThingPrefix
Hidden: False
Static: False
```

## public_description
The public description shown in search results

```yaml
Name: public_description
Type: String
Hidden: False
Static: False
```

## public_description_html
The HTML version of the public description.

```yaml
Name: public_description_html
Type: String
Hidden: False
Static: False
```

## public_traffic
Whether or not the subreddit has made their traffic status public.

```yaml
Name: public_traffic
Type: Boolean
Hidden: False
Static: False
```

## quarantine
Whether or not the subreddit has been quarantined.

```yaml
Name: quarantine
Type: Boolean
Hidden: False
Static: False
```

## RedditThingKind
The kind. this should always be `t5`

```yaml
Name: RedditThingKind
Type: RedditThingKind
Hidden: False
Static: True
```

## show_media
Whether or not to show thumbnails in the subreddit.

```yaml
Name: show_media
Type: Boolean
Hidden: False
Static: False
```

## show_media_preview
Whether or not to expand media previews on the comments page

```yaml
Name: show_media_preview
Type: Boolean
Hidden: False
Static: False
```

## spoilers_enabled
Whether or not spoilers are enabled int he subreddit.

```yaml
Name: spoilers_enabled
Type: Boolean
Hidden: False
Static: False
```

## submission_type
The submission types allowed in the subreddit.

```yaml
Name: submission_type
Type: String
Hidden: False
Static: False
```

## submit_link_label
The label on the submit link button

```yaml
Name: submit_link_label
Type: String
Hidden: False
Static: False
```

## submit_text
Text displayed on submission page.

```yaml
Name: submit_text
Type: String
Hidden: False
Static: False
```

## submit_text_html
HTML version of the submit_text

```yaml
Name: submit_text_html
Type: String
Hidden: False
Static: False
```

## submit_text_label
The label on the submit test button

```yaml
Name: submit_text_label
Type: String
Hidden: False
Static: False
```

## subreddit_type
The subreddit's type - one of "public", "private", "restricted", or in very special cases "gold_restricted" or "archived"

```yaml
Name: subreddit_type
Type: String
Hidden: False
Static: False
```

## subscribers
Number of subscribers to the subreddit.

```yaml
Name: subscribers
Type: Int64
Hidden: False
Static: False
```

## suggested_comment_sort
The suggested sort order for the subreddit.

```yaml
Name: suggested_comment_sort
Type: String
Hidden: False
Static: False
```

## title
The title of the subreddit.

```yaml
Name: title
Type: String
Hidden: False
Static: False
```

## url
The relative URL of the subreddit. Ex: "/r/pics/"

```yaml
Name: url
Type: String
Hidden: False
Static: False
```

## user_can_flair_in_sr
Whether or not the user can flair in the subreddit

```yaml
Name: user_can_flair_in_sr
Type: Boolean
Hidden: False
Static: False
```

## user_flair_css_class
CSS class for the user's flair

```yaml
Name: user_flair_css_class
Type: String
Hidden: False
Static: False
```

## user_flair_enabled_in_sr
Whether or not the user's flair is enabled in the subreddit

```yaml
Name: user_flair_enabled_in_sr
Type: Boolean
Hidden: False
Static: False
```

## user_flair_text
The text of the user's flair

```yaml
Name: user_flair_text
Type: String
Hidden: False
Static: False
```

## user_has_favorited
Whether or not the user has "favorited" the subreddit.

```yaml
Name: user_has_favorited
Type: Boolean
Hidden: False
Static: False
```

## user_is_banned
Whether or not the user is banned from the subreddit.

```yaml
Name: user_is_banned
Type: Boolean
Hidden: False
Static: False
```

## user_is_contributor
Whether or not the user is a contributor to the subreddit.

```yaml
Name: user_is_contributor
Type: Boolean
Hidden: False
Static: False
```

## user_is_moderator
Whether or not the user is a moderator to the subreddit

```yaml
Name: user_is_moderator
Type: Boolean
Hidden: False
Static: False
```

## user_is_muted
Whether or not the user is muted in the subreddit.

```yaml
Name: user_is_muted
Type: Boolean
Hidden: False
Static: False
```

## user_is_subscriber
Whether or not the user is a subscriber of the subreddit.

```yaml
Name: user_is_subscriber
Type: Boolean
Hidden: False
Static: False
```

## user_sr_flair_enabled
Whether or not user subreddit flair is enabled

```yaml
Name: user_sr_flair_enabled
Type: Boolean
Hidden: False
Static: False
```

## user_sr_theme_enabled
Whether or not the subreddit theme is enabled by the user.

```yaml
Name: user_sr_theme_enabled
Type: Boolean
Hidden: False
Static: False
```

## whitelist_status
What advertising the subreddit has been whitelisted for

```yaml
Name: whitelist_status
Type: String
Hidden: False
Static: False
```

## wiki_enabled
Whether or not the subreddit wiki is enabled.

```yaml
Name: wiki_enabled
Type: Boolean
Hidden: False
Static: False
```


# Methods
## GetApiEndpointUri()
Returns the API endpoint URL for the current instance.

```yaml
Name: GetApiEndpointUri
Return Type: String
Hidden: False
Static: False
Definition: String GetApiEndpointUri()
```

## GetFullName()
Returns the Reddit Fllname for the instance.

```yaml
Name: GetFullName
Return Type: String
Hidden: False
Static: False
Definition: String GetFullName()
```

## ToString()
Overrides `ToString()` to return the Subreddit name and title.

```yaml
Name: ToString
Return Type: String
Hidden: False
Static: False
Definition: String ToString()
```

# NOTES

Experimental: This is an experimental feature. Expect radical changes between versions. Do not write production code against this until it has been marked stable.

# DERIVED FROM

[RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

# SEE ALSO

[about_RedditSubreddit](https://psraw.readthedocs.io/en/latest/Module/about_RedditSubreddit)

[about_RedditComment](https://psraw.readthedocs.io/en/latest/Module/about_RedditComment)

[about_RedditDate](https://psraw.readthedocs.io/en/latest/Module/about_RedditDate)

[about_RedditHeaderSize](https://psraw.readthedocs.io/en/latest/Module/about_RedditHeaderSize)

[about_RedditLink](https://psraw.readthedocs.io/en/latest/Module/about_RedditLink)

[about_RedditThing](https://psraw.readthedocs.io/en/latest/Module/about_RedditThing)

[about_RedditDataObject](https://psraw.readthedocs.io/en/latest/Module/about_RedditDataObject)

[https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

[https://github.com/reddit/reddit/wiki/JSON](https://github.com/reddit/reddit/wiki/JSON)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)
