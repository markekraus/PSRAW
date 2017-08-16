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
        $This.Id = $Data.Id
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
                $Thing = [RedditThing]$Data.replies
                if($Thing -is 'RedditListing'){
                    $This.replies = $Thing.RedditData.Items
                }
                if($Thing -is 'RedditMore'){
                    $This.replies = foreach($Child in $Thing.Children){
                        [RedditComment]@{
                            Id = $Child
                            parent_id = $Data.id
                        }
                    }
                }
                foreach($Reply in $This.Replies){
                    $Reply.ParentObject = $This
                }   
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

    hidden [void] _initReplies ([PSobject]$Replies){
        if([string]::IsNullOrEmpty($Replies)){
            return
        }
        $Thing = [RedditThing]$Replies
        if($Thing -is 'RedditListing'){
            $This.replies = $Thing.RedditData.Items
        }
        if($Thing -is 'RedditMore'){
            $This.replies = foreach($Child in $Thing.Children){
                [RedditComment]@{
                    Id = $Child
                    parent_id = $This.id
                }
            }
        }
        foreach($Reply in $This.Replies){
            $Reply.ParentObject = $This
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

    #TODO add HasData() to detect if this was a "more" comment
    #TODO add UpdateData() to retrieve comment data
}
