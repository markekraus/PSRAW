<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	6/1/2017 4:50 AM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	009-RedditSubreddit.ps1
    
    .DESCRIPTION
        RedditSubreddit Class
#>
Class RedditSubreddit : RedditDataObject {
    [long]$accounts_active
    [Boolean]$accounts_active_is_fuzzed
    [long]$active_user_count
    [PSObject]$advertiser_category
    [Boolean]$allow_images
    [String]$audience_target
    [String]$banner_img
    [PSObject]$banner_size
    [Boolean]$collapse_deleted_comments
    [long]$comment_score_hide_mins
    [double]$created
    [double]$created_utc
    [String]$description
    [String]$description_html
    [String]$display_name
    [String]$display_name_prefixed
    [String]$header_img
    [RedditHeaderSize]$header_size
    [String]$header_title
    [Boolean]$hide_ads
    [String]$icon_img
    [PSObject]$icon_size
    [String]$id
    [String]$key_color
    [String]$lang
    [Boolean]$link_flair_enabled
    [String]$name
    [Boolean]$over18
    [String]$public_description
    [String]$public_description_html
    [Boolean]$public_traffic
    [Boolean]$quarantine
    [Boolean]$show_media
    [Boolean]$show_media_preview
    [Boolean]$spoilers_enabled
    [String]$submission_type
    [String]$submit_link_label
    [String]$submit_text
    [String]$submit_text_html
    [String]$submit_text_label
    [String]$subreddit_type
    [long]$subscribers
    [String]$suggested_comment_sort
    [String]$title
    [String]$url
    [Boolean]$user_can_flair_in_sr
    [String]$user_flair_css_class
    [Boolean]$user_flair_enabled_in_sr
    [String]$user_flair_text
    [Boolean]$user_has_favorited
    [Boolean]$user_is_banned
    [Boolean]$user_is_contributor
    [Boolean]$user_is_moderator
    [Boolean]$user_is_muted
    [Boolean]$user_is_subscriber
    [Boolean]$user_sr_flair_enabled
    [Boolean]$user_sr_theme_enabled
    [String]$whitelist_status
    [Boolean]$wiki_enabled
    [PSObject]$ParentObject
    [RedditThingPrefix]$Prefix = 't5'
    hidden [RedditOAuthToken]$AccessToken  
    static [string] $ApiEndpointUri = 'https://oauth.reddit.com/api/info?id=t5_{0}'
    RedditSubreddit () { }
    RedditSubreddit ([String]$String) { $This = $Null }
    RedditSubreddit ([RedditThing]$RedditThing) {
        $This.AccessToken = Get-RedditTokenOrDefault $RedditThing.AccessToken
        $Data = $RedditThing.data
        $DataProperties = $Data.psobject.Properties.name
        $ClassProperties = $This.psobject.Properties.name
        foreach ($Property in $DataProperties) {
            if ($Property -in $ClassProperties) {
                $This.$Property = $Data.$Property
                continue
            }
            $Params = @{
                MemberType = 'NoteProperty'
                Name       = $Property 
                Value      = $Data.$Property
            }
            $This | Add-Member @params
        }
    }

    [String] GetApiEndpointUri () {
        return ([RedditSubreddit]::ApiEndpointUri -f $This.id)
    }
    [String] GetFullName () {
        return $This.name
    }
    [String] ToString () {
        return $This.body
    }
}
