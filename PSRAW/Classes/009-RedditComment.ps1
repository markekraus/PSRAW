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
    [RedditThingKind]$Kind = 't1'
    [string]$likes
    [string]$link_id
    [RedditModReport[]]$mod_reports
    hidden [RedditDataObject]$MoreObject
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
    static [string] $ApiEndpointUri = 'https://oauth.reddit.com/api/info?id=t1_{0}'
    static [RedditThingKind]$RedditThingKind = 't1'
    RedditComment () { }
    RedditComment ([RedditThing]$RedditThing) {
        $Data = $RedditThing.data
        $This.Id = $Data.Id
        $DataProperties = $Data.psobject.Properties.name
        $ClassProperties = $This.psobject.Properties.name
        foreach ($Property in $DataProperties) {
            If($Property -eq 'replies'){
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
        $This._initReplies($Data.replies)
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

    [bool] HasMore(){
        return ($null -ne $This.MoreObject)
    }

    hidden [void] _initReplies ([Object]$Replies){
        if($Replies -is [string] -and [string]::IsNullOrEmpty($Replies)){
            return
        }
        $List = [system.collections.generic.list[RedditComment]]::new()
        $Thing = [RedditThing]$Replies
        if($Thing.Kind -eq 'Listing'){
            foreach($ReplyComment in $Thing.RedditData.GetComments()){
                $List.Add($ReplyComment)
            }
            foreach($ReplyID in $Thing.RedditData.GetMores().Children){
                $ReplyComment = [RedditComment]@{
                    id                      = $ReplyID
                    name                    = 't1_{0}' -f $ReplyID
                    parent_id               = $This.name
                    link_id                 = $This.link_id
                    subreddit               = $This.subreddit
                    subreddit_id            = $This.subreddit_id
                    subreddit_name_prefixed = $This.subreddit_name_prefixed
                }
                $List.Add($ReplyComment)
            }
        }
        if($Thing.kind -eq 'More' -and $Thing.RedditData.Count -eq 0){
                $This.MoreObject = $Thing.RedditData
        }
        if($Thing.kind -eq 'More' -and $Thing.RedditData.Count -gt 0){
            foreach($ReplyID in $Thing.RedditData.Children){
                $ReplyComment = [RedditComment]@{
                    id                      = $ReplyID
                    name                    = 't1_{0}' -f $ReplyID
                    parent_id               = $This.name
                    link_id                 = $This.link_id
                    subreddit               = $This.subreddit
                    subreddit_id            = $This.subreddit_id
                    subreddit_name_prefixed = $This.subreddit_name_prefixed
                }
                $List.Add($ReplyComment)
            }
        }
        $This.replies = $List
        foreach($Reply in $This.Replies){
            $Reply.ParentObject = $This
        }
    }

    #[string] GetPermalink() {
    #    get submission link info
    #    append comemnt id
    #}
    #TODO add HasData() to detect if this was a "more" comment
    #TODO add UpdateData() to retrieve comment data
}
