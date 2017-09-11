<#	
    .NOTES
    
     Created with: 	Plaster
     Created on:   	8/15/2017 4:53 AM
     Edited on:     8/15/2017
     Created by:   	Mark Kraus
     Organization: 	 
     Filename:     	011-RedditSubmission.ps1
    
    .DESCRIPTION
        RedditSubmission Class
#>
Class RedditSubmission : RedditDataObject {
    [RedditLink]$Link
    [RedditComment[]]$Comments
    RedditSubmission () { }
    RedditSubmission ([RedditApiResponse]$ApiResponse) {
        $Things = [RedditThing]::CreateFrom($ApiResponse)
        $This.Link = $Things[0].RedditData.Items[0]
        $List = [system.collections.generic.list[RedditComment]]::new()
        foreach($comment in $Things[1].RedditData.GetComments()){
            $List.Add($Comment)
        }        
        foreach($CommentId in $Things[1].RedditData.GetMores().Children){
            $Comment = [RedditComment]@{
                Id                      = $CommentId
                name                    = 't1_{0}' -f $CommentId
                link_id                 = $this.Link.name
                parent_id               = $this.Link.name
                subreddit               = $this.Link.subreddit
                subreddit_id            = $this.Link.subreddit_id
                subreddit_name_prefixed = $this.Link.subreddit_name_prefixed
                ParentObject            = $This.Link
            }
            $List.Add($Comment)
        }
        $This.Comments = $List
     }
}
