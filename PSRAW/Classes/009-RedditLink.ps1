<#
    .NOTES

     Created with: 	Plaster
     Created on:   	6/1/2017 4:50 AM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization:
     Filename:     	009-RedditLink.ps1

    .DESCRIPTION
        RedditLink Class
#>
Class RedditLink : RedditDataObject {
    [RedditDate]$approved_at_utc
    [String]$approved_by
    [Boolean]$archived
    [String]$author
    [string]$author_flair_css_class
    [string]$author_flair_text
    [RedditDate]$banned_at_utc
    [string]$banned_by
    [Boolean]$brand_safe
    [Boolean]$can_gild
    [Boolean]$can_mod_post
    [Boolean]$clicked
    [Boolean]$contest_mode
    [RedditDate]$created
    [RedditDate]$created_utc
    [String]$distinguished
    [String]$domain
    [long]$downs
    [Decimal]$edited
    [long]$gilded
    [Boolean]$hidden
    [Boolean]$hide_score
    [String]$id
    [Boolean]$is_self
    [Boolean]$is_video
    [bool]$likes
    [String]$link_flair_css_class
    [String]$link_flair_text
    [Boolean]$locked
    [PSObject]$media
    [PSObject]$media_embed
    [RedditModReport[]]$mod_reports
    [String]$name
    [long]$num_comments
    [long]$num_reports
    [Boolean]$over_18
    [String]$parent_whitelist_status
    [String]$permalink
    [Boolean]$quarantine
    [String]$removal_reason
    [String[]]$report_reasons
    [Boolean]$saved
    [long]$score
    [PSObject]$secure_media
    [PSObject]$secure_media_embed
    [String]$selftext
    [String]$selftext_html
    [Boolean]$spoiler
    [Boolean]$stickied
    [String]$subreddit
    [String]$subreddit_id
    [String]$subreddit_name_prefixed
    [String]$subreddit_type
    [PSObject]$suggested_sort
    [String]$thumbnail
    [String]$title
    [long]$ups
    [Double]$upvote_ratio
    [Uri]$url
    [RedditUserReport[]]$user_reports
    [PSObject]$view_count
    [Boolean]$visited
    [String]$whitelist_status
    [PSObject]$ParentObject
    [RedditThingPrefix]$Prefix = 't3'
    static [RedditThingKind]$RedditThingKind = 't3'
    static [string] $ApiEndpointUri = 'https://oauth.reddit.com/api/info?id=t3_{0}'
    RedditLink () { }
    RedditLink ([RedditThing]$RedditThing) {
        if($RedditThing.Kind -ne $This::RedditThingKind){
            $Message = 'Unable to convert RedditThing of kind "{0}" to "{1}"' -f
                $RedditThing.Kind,
                $This.GetType().Name
            $Exception = [System.InvalidCastException]::new($Message)
            Throw $Exception
        }
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
        return ([RedditLink]::ApiEndpointUri -f $This.id)
    }
    [String] GetFullName () {
        return $This.name
    }
    [String] ToString () {
        return '[{0} in {1}] {2}' -f
            $This.author,
            $This.subreddit_name_prefixed,
            $This.title

    }

    # TODO Add HasData()
    # Add UpdateData()
}
