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

#$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
#$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
#$ModuleName = Split-Path $ModuleRoot -Leaf
#Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
#Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force
$ProjectRoot = Get-ProjectRoot
$ModuleRoot  = Get-ModuleRoot
$ModulePath  = Get-ModulePath
$ModuleName  = Get-ModuleName
Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
Import-Module -force $ModulePath
$Null = Start-WebListener

#region insanity
# For whatever reason, pester chokes trying to mock Update-RedditOAuthToken
# So, we remove it from the module and replace it with a script scope function
# We later mock that function too because it wont work without the mock either
$module = Get-Module $ModuleName
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

function Get-ApplicationScript {
    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $UserId = 'reddituser'
    $UserSecret = 'password'
    $SecUserSecret = $UserSecret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)

    [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $ClientCredential
        UserCredential   = $UserCredential
        Type             = 'Script'
    }
}
Function Get-TokenScript {
   
    $ApplicationScript = Get-ApplicationScript
    
    $TokenId = 'access_token'
    $TokenSecret = '34567'
    $SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
    $TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

    [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = (Get-Date).AddMinutes(-13)
        ExpireDate         = (Get-Date).AddHours(1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Password'
        RateLimitUsed      = 0
        RateLimitRemaining = 300
        RateLimitRest      = 99999
        TokenCredential    = $TokenCredential
    }
}

function Get-TokenBad {

    $ApplicationScript = Get-ApplicationScript

    $TokenId = 'access_token'
    $TokenSecret = '34567'
    $SecTokenSecret = $TokenSecret | ConvertTo-SecureString -AsPlainText -Force 
    $TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

    [RedditOAuthToken]@{
        Application        = $ApplicationScript
        Notes              = 'badupdate'
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
        TokenCredential    = $TokenCredential
    }
}
Function MyTest {    
    
    

    <#
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
    #>
    $Global:Uri = Get-WebListenerUrl -Test 'User'
    $Global:UriBad = Get-WebListenerUrl -Test 'StatusCode' -Query @{StatusCode=404}
    $Global:UriRaw = Get-WebListenerUrl -Test 'Echo' -Query @{statuscode=200; 'Content-Type' = 'text/plain'; Body = 'Hello World'}
    $Global:UriDefaultToken = Get-WebListenerUrl -Test 'Get'
    $ParameterSets = @(
        @{
            Name   = 'Uri Only'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
            }
        }
        @{
            Name   = 'Get'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Method      = 'Get'
            }
        }
        @{
            Name   = 'Post Body'
            Params = @{
                AccessToken = Get-TokenScript
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
                AccessToken = Get-TokenScript
                Uri         = $Uri
                Headers     = @{
                    'x-narwhals' = 'bacon'
                }
            }
        }
        @{
            Name   = 'Timeout'
            Params = @{
                AccessToken = Get-TokenScript
                Uri         = $Uri
                TimeoutSec  = '2'
            }
        }
    )
    $Global:InvokeWebRequest = Get-Command 'Invoke-WebRequest'
    Mock -CommandName Invoke-WebRequest -ModuleName $ModuleName -MockWith {
        & $Global:InvokeWebRequest -Uri $Uri
    }
    
    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $ModuleName
        ParameterFilter = {$AccessToken.Notes -notlike 'badupdate'}
        MockWith        = { }
    }
    Mock @Params

    $Params = @{
        CommandName     = 'Update-RedditOAuthToken'
        ModuleName      = $ModuleName
        ParameterFilter = {$AccessToken.Notes -like 'badupdate'}
        MockWith        = { Write-Error 'Bad' }
    }
    Mock @Params
    
    $Params = @{
        CommandName = 'Wait-RedditApiRateLimit'
        ModuleName  = $ModuleName 
    }

    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
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
    It "Has an irr alias" {
        $LocalParams = $ParameterSets[0].Params
        { irr @LocalParams -ErrorAction Stop } | should not throw
    }
    It "Uses the Default token when one is not supplied" {
        $TokenScript = Get-TokenScript
        Set-RedditDefaultOAuthToken -AccessToken $TokenScript 
        { & $Command -Uri $UriDefaultToken } | Should Not Throw
    }
    It 'Handles Token Refresh errors gracefully' {
        $LocalParams = @{
            AccessToken = Get-TokenBad
            Uri         = $Uri
        }
        Try { & $Command @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match 'Unable to refresh Access Token'
    }
    It "Handles Invoke-WebRequest errors gracefully" {
        $LocalParams = @{
            AccessToken = Get-TokenScript
            Uri         = $UriBad
        }
        Try { & $Command @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match "Unable to query Uri"
    }
    It "Handles Handles non-JSON responses" {
        $LocalParams = @{
            AccessToken = Get-TokenScript
            Uri         = $UriRaw
        }
        { & $Command @LocalParams -ErrorAction Stop } | Should not Throw
    }
}
Describe "$command Unit" -Tags Unit {
    $CommandPresent = Get-Command -Name $Command -Module $ModuleName -ErrorAction SilentlyContinue
    if (-not $CommandPresent) {
        Write-Warning "'$command' was not found in '$ModuleName' during pre-build tests. It may not yet have been added the module. Unit tests will be skipped until after build."
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