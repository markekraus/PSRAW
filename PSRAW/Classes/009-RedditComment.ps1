<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	6/1/2017 4:50 AM
     Edited on:     6/1/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	009-RedditComment.ps1
    
    .DESCRIPTION
        RedditComment Class
#>
Class RedditComment : RedditDataObject {
    [string]$approved_by
    [bool]$archived
    [string]$author
    [string]$author_flair_css_class
    [string]$author_flair_text
    [string]$banned_by
    [string]$body
    [string]$body_html
    [bool]$can_gild
    [double]$controversiality
    [RedditDate]$created
    [RedditDate]$created_utc
    [long]$depth
    [string]$distinguished
    [long]$downs
    [bool]$edited
    [long]$gilded
    [string]$id
    [string]$likes
    [string]$link_id
    [RedditModReport[]]$mod_reports
    [string]$name
    [string]$num_reports
    [string]$parent_id
    [PSObject]$ParentObject
    [string]$removal_reason
    [RedditComment[]]$replies
    [string[]]$report_reasons
    [bool]$saved
    [long]$score
    [bool]$score_hidden
    [bool]$stickied
    [string]$subreddit
    [string]$subreddit_id
    [string]$subreddit_name_prefixed
    [string]$subreddit_type
    [long]$ups
    [RedditUserReport[]]$user_reports
    [RedditThingPrefix]$Prefix = 't1'
    hidden [RedditOAuthToken]$AccessToken  
    static [string] $ApiEndpointUri = 'https://oauth.reddit.com/api/info?id=t1_{0}'
    RedditComment () { }
    RedditComment ([String]$String) { $This = $Null }
    RedditComment ([RedditThing]$RedditThing) {
        $This.AccessToken = Get-RedditTokenOrDefault $RedditThing.AccessToken
        $Data = $RedditThing.data
        $DataProperties = $Data.psobject.Properties.name
        $ClassProperties = $This.psobject.Properties.name
        foreach ($Property in $DataProperties) {
            if(
                $Property -eq 'replies' -and 
                [string]::IsNullOrEmpty($Data.replies)
            ){
                continue
            }
            If($Property -eq 'replies'){
                    $Listing = [RedditThing]$Data.replies
                    $This.replies = $Listing.RedditData.Items
                    continue
            }
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
        return ([RedditComment]::ApiEndpointUri -f $This.id)
    }
    [String] GetFullName () {
        return $This.name
    }
    [String] ToString () {
        return $This.body
    }
}
