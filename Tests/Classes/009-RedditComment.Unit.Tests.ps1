<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    6/02/2017 4:50 AM
     Edited on:     6/02/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     RedditComment.Unit.Tests.ps1
    
    .DESCRIPTION
        Unit Tests for RedditComment Class
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Class = 'RedditComment'

$CommentJSON = @'
{
    "kind": "t1",
    "data": {
            "subreddit_id": "t5_abc12",
        "banned_by": null,
        "removal_reason": null,
        "link_id": "t3_def345",
        "likes": null,
        "replies": "",
        "user_reports": [
                [
                    "Stupid Comment",
                2
            ]
        ],
        "saved": false,
        "id": "ghij678",
        "gilded": 0,
        "archived": false,
        "score": -2,
        "report_reasons": [
                "This attribute is deprecated. Please use mod_reports and user_reports instead."
        ],
        "author": "StupidUser",
        "parent_id": "t3_ghij677",
        "subreddit_name_prefixed": "r/SubReddit",
        "approved_by": null,
        "controversiality": 0,
        "body": "Stupid Comment!",
        "edited": false,
        "author_flair_css_class": null,
        "downs": 0,
        "body_html": "&lt;div class=\"md\"&gt;&lt;p&gt;stupid comment!&lt;/p&gt;\n&lt;/div&gt;",
        "can_gild": true,
        "removed": false,
        "approved": false,
        "name": "t1_ghij678",
        "score_hidden": false,
        "num_reports": 3,
        "stickied": false,
        "created": 1496196740.0,
        "subreddit": "SubReddit",
        "author_flair_text": null,
        "spam": false,
        "created_utc": 1496167940.0,
        "distinguished": null,
        "ignore_reports": false,
        "mod_reports": [
                [
                    "Really Stupid Comment",
                "markekraus"
            ]
        ],
        "subreddit_type": "public",
        "ups": -2
    }
}
'@


Function MyTest {
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $UserId = 'reddituser'
    $UserSecret = 'password'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)

    $TokenId = 'access_token'
    $TokenSecret = '34567'
    $SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
    $TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

    $ApplicationScript = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $ClientCredential
        UserCredential   = $UserCredential
        Type             = 'Script'
    }
    $TokenScript = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
    }
    It 'Creates a RedditComment from a RedditAccessToken and an object' {
        $Object = ConvertFrom-Json $CommentJSON 
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.subreddit_id | should be 't5_abc12'
        $RedditComment.link_id | should be 't3_def345'
        $RedditComment.user_reports[0].reason | should be 'Stupid Comment'
        $RedditComment.user_reports[0].count | should be 2
        $RedditComment.id | should be 'ghij678'
        $RedditComment.gilded | should be 0
        $RedditComment.score | should be -2
        $RedditComment.report_reasons[0] | should be 'This attribute is deprecated. Please use mod_reports and user_reports instead.'
        $RedditComment.author | should be 'StupidUser'
        $RedditComment.parent_id| should be 't3_ghij677'
        $RedditComment.body | should be 'Stupid Comment!'
        $RedditComment.mod_reports[0].reason | should be 'Really Stupid Comment'
        $RedditComment.mod_reports[0].moderator | should be 'markekraus'
        $RedditComment.created.unix | should be 1496196740.0
    }
    It 'Creates a RedditComment from a RedditAccessToken and an object' {
        $Object = ConvertFrom-Json $CommentJSON 
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.subreddit_id | should be 't5_abc12'
        $RedditComment.link_id | should be 't3_def345'
        $RedditComment.user_reports[0].reason | should be 'Stupid Comment'
        $RedditComment.user_reports[0].count | should be 2
        $RedditComment.id | should be 'ghij678'
        $RedditComment.gilded | should be 0
        $RedditComment.score | should be -2
        $RedditComment.report_reasons[0] | should be 'This attribute is deprecated. Please use mod_reports and user_reports instead.'
        $RedditComment.author | should be 'StupidUser'
        $RedditComment.parent_id| should be 't3_ghij677'
        $RedditComment.body | should be 'Stupid Comment!'
        $RedditComment.mod_reports[0].reason | should be 'Really Stupid Comment'
        $RedditComment.mod_reports[0].moderator | should be 'markekraus'
        $RedditComment.created.unix | should be 1496196740.0
    }
    It 'Automatically adds new properties' {
        $Object = ConvertFrom-Json $CommentJSON 
        $Object.data | Add-Member -MemberType NoteProperty -Name 'Testy' -Value 'TestTest'
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.Testy | should be 'TestTest'
    }
    It 'Has a working GetApiEndpointUri() method' {
        $Object = ConvertFrom-Json $CommentJSON 
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.GetApiEndpointUri() | should be 'https://oauth.reddit.com/api/info?id=t1_ghij678'
    }
    It 'Has a working GetFullName() method' {
        $Object = ConvertFrom-Json $CommentJSON 
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.GetFullName() | should be 't1_ghij678'
    }
    It 'Has a working ToString() method' {
        $Object = ConvertFrom-Json $CommentJSON 
        $RedditComment = [RedditComment]::new($TokenScript, $Object)
        $RedditComment.ToString() | should be 'Stupid Comment!'
    }
}

Describe "[$Class] Unit Tests" -Tag Unit {
    if (-not ($Class -as [Type])) {
        Write-Warning "'$class' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "[$Class] Build Tests" -Tag Build {
    MyTest
}