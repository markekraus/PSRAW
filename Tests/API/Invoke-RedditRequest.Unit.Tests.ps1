<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/20/2017 1:34 PM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Invoke-RedditRequest.Unit.Tests.ps1
    
    .DESCRIPTION
        Invoke-RedditRequest Function unit tests
#>

$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force

#region insanity
# For whatever reason, pester chokes trying to mock Update-RedditOAuthToken
# So, we remove it from the module and replace it with a script scope function
# We later mock that function too because it wont work without the mock either
$module = Get-Module $moduleName
& $module {
    Get-ChildItem function:\ | 
        Where-Object {$_.name -like 'Update-RedditOAuthToken'} | 
        Remove-Item -Force -Confirm:$false
    Get-ChildItem function:\ | 
        Where-Object {$_.name -like 'Update-RedditOAuthToken'} | 
        Remove-Item -Force -Confirm:$false
}
function Update-RedditOAuthToken {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Object]
        $AccessToken
    )
    process {
        If ($AccessToken.Note -like 'badupdate') {
            Write-Error 'Bad'
        }
    }
}
#endregion insanity

$command = 'Invoke-RedditRequest'
$TypeName = 'RedditApiResponse'

$Global:JSON = @'
{
    "comment_karma": 0, 
    "created": 1389649907.0, 
    "created_utc": 1389649907.0, 
    "has_mail": false, 
    "has_mod_mail": false, 
    "has_verified_email": null, 
    "id": "1", 
    "is_gold": false, 
    "is_mod": true, 
    "link_karma": 1, 
    "name": "reddit_bot", 
    "over_18": true
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

    $RefreshId = 'refresh_token'
    $RefreshSecret = '76543'
    $SecRefreshSecret = $RefreshSecret | ConvertTo-SecureString -AsPlainText -Force 
    $RefreshCredential = [pscredential]::new($RefreshId, $SecRefreshSecret)

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
    $TokenCode = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Authorization_Code'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
        RefreshCredential  = $RefreshCredential.psobject.copy()
    }
    $TokenBadUpdate = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        Notes              = 'badupdate'
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Authorization_Code'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
        RefreshCredential  = $RefreshCredential.psobject.copy()
    }
    $Global:Uri = 'https://oauth.reddit.com/api/v1/me'
    $Global:UriBad = 'https://oauth.reddit.com/no/lo/existo'
    $Global:UriRaw = 'https://oauth.reddit.com/raw'
    $ParameterSets = @(
        @{
            Name   = 'Uri Only'
            Params = @{
                AccessToken = $TokenCode
                Uri         = $Uri
            }
        }
        @{
            Name   = 'Get'
            Params = @{
                AccessToken = $TokenCode
                Uri         = $Uri
                Method      = 'Get'
            }
        }
        @{
            Name   = 'Post Body'
            Params = @{
                AccessToken = $TokenCode
                Uri         = $Uri
                Method      = 'Post'
                Body        = @{
                    Test = "Testy"
                } | ConvertTo-Json
            }
        }
        @{
            Name   = 'Headers'
            Params = @{
                AccessToken = $TokenCode
                Uri         = $Uri
                Headers     = @{
                    'x-narwhals' = 'bacon'
                }
            }
        }
        @{
            Name   = 'Timeout'
            Params = @{
                AccessToken = $TokenCode
                Uri         = $Uri
                TimeoutSec  = '2'
            }
        }
    )
    $Global:InvokeWebRequest = Get-Command 'Invoke-WebRequest'
    $Params = @{
        CommandName     = 'Invoke-WebRequest'
        ModuleName      = $moduleName 
        ParameterFilter = {$Uri -eq $Global:Uri}
        MockWith        = {
            $Result = [PSCustomObject]@{
                Headers = @{
                    Date                    = Get-Date
                    'x-ratelimit-remaining' = 59
                    'x-ratelimit-used'      = 1
                    'x-ratelimit-reset'     = 30
                    'Content-Type'          = 'application/json'
                }
                Content = $Global:JSON
            }
            return $Result
        }
    }
    Mock @Params 

    $Params = @{
        CommandName     = 'Invoke-WebRequest'
        ModuleName      = $moduleName 
        ParameterFilter = {$Uri -eq $Global:UriRaw}
        MockWith        = {
            $Result = [PSCustomObject]@{
                Headers = @{
                    Date                    = Get-Date
                    'x-ratelimit-remaining' = 59
                    'x-ratelimit-used'      = 1
                    'x-ratelimit-reset'     = 30
                    'Content-Type'          = 'text/plain'
                }
                Content = 'This is some text; it is only some text.'
            }
            return $Result
        }
    }
    Mock @Params

    $Params = @{
        CommandName     = 'Invoke-WebRequest'
        ModuleName      = $moduleName 
        ParameterFilter = {$Uri -eq $Global:UriBad}
        MockWith        = {
            & $Global:InvokeWebRequest -Uri 'https://oauth.reddit.com/api/v1/me' -ErrorAction 'Stop'
        }
    }
    Mock @Params
    
    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $moduleName
        ParameterFilter = {$AccessToken.Notes -notlike 'badupdate'}
        MockWith        = { }
    }
    Mock @Params

    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $moduleName
        ParameterFilter = {$AccessToken.Notes -like 'badupdate'}
        MockWith        = { Write-Error 'Bad' }
    }
    Mock @Params
    
    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    $Params = @{
        CommandName = 'Wait-RedditApiRateLimit'
        ModuleName  = $moduleName 
    }
    Mock @Params -MockWith {
        $null = $null
    }
    It "Emits a $TypeName Object" {
        (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns a $TypeName Object" {
        $LocalParams = $ParameterSets[0].Params
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Supports WhatIf" {
        $LocalParams = $ParameterSets[0].Params
        {& $Command @LocalParams -WhatIf -ErrorAction Stop } | should not throw
    }
    It 'Handles Token Refresh errors gracefully' {
        $LocalParams = @{
            AccessToken = $TokenBadUpdate
            Uri         = $Uri
        }
        Try { & $Command @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match 'Unable to refresh Access Token'
    }
    It "Handles Invoke-WebRequest errors gracefully" {
        $LocalParams = @{
            AccessToken = $TokenCode
            Uri         = $UriBad
        }
        Try { & $Command @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match "Unable to query Uri"
    }
    It "Handles Handles non-JSON responses" {
        $LocalParams = @{
            AccessToken = $TokenCode
            Uri         = $UriRaw
        }
        { & $Command @LocalParams -ErrorAction Stop } | Should not Throw
    }
}
Describe "$command Unit" -Tags Unit {
    $CommandPresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
    if (-not $CommandPresent) {
        Write-Warning "'$command' was not found in '$moduleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "$command Build" -Tags Build {
    MyTest
}

Remove-Variable -Name JSON -Scope Global -Force -ErrorAction SilentlyContinue
Remove-Variable -Name Uri -Scope Global -Force -ErrorAction SilentlyContinue
Remove-Variable -Name UriBad -Scope Global -Force -ErrorAction SilentlyContinue
Remove-Variable -Name InvokeWebRequest -Scope Global -Force -ErrorAction SilentlyContinue