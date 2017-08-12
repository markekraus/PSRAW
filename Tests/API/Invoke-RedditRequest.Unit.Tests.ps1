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

$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$ModuleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

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
    $TokenBadUpdate = [RedditOAuthToken]@{
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
        TokenCredential    = $TokenCredential.psobject.copy()
    }

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
    $Global:Uri = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%0A%20%20%20%20%22comment_karma%22%3A%200%2C%20%0A%20%20%20%20%22created%22%3A%201389649907.0%2C%20%0A%20%20%20%20%22created_utc%22%3A%201389649907.0%2C%20%0A%20%20%20%20%22has_mail%22%3A%20false%2C%20%0A%20%20%20%20%22has_mod_mail%22%3A%20false%2C%20%0A%20%20%20%20%22has_verified_email%22%3A%20null%2C%20%0A%20%20%20%20%22id%22%3A%20%221%22%2C%20%0A%20%20%20%20%22is_gold%22%3A%20false%2C%20%0A%20%20%20%20%22is_mod%22%3A%20true%2C%20%0A%20%20%20%20%22link_karma%22%3A%201%2C%20%0A%20%20%20%20%22name%22%3A%20%22reddit_bot%22%2C%20%0A%20%20%20%20%22over_18%22%3A%20true%0A%7D'
    $Global:UriBad = 'http://urlecho.appspot.com/echo?status=404&Content-Type=text%2Fhtml&body=Bad%20Page!'
    $Global:UriRaw = 'http://urlecho.appspot.com/echo?status=200&Content-Type=text%2Fhtml&body=Hello%20world!'
    $Global:UriDefaultToken = 'https://httpbin.org/get'
    $ParameterSets = @(
        @{
            Name   = 'Uri Only'
            Params = @{
                AccessToken = $TokenScript
                Uri         = $Uri
            }
        }
        @{
            Name   = 'Get'
            Params = @{
                AccessToken = $TokenScript
                Uri         = $Uri
                Method      = 'Get'
            }
        }
        @{
            Name   = 'Post Body'
            Params = @{
                AccessToken = $TokenScript
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
                AccessToken = $TokenScript
                Uri         = $Uri
                Headers     = @{
                    'x-narwhals' = 'bacon'
                }
            }
        }
        @{
            Name   = 'Timeout'
            Params = @{
                AccessToken = $TokenScript
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
    
    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    $Params = @{
        CommandName = 'Wait-RedditApiRateLimit'
        ModuleName  = $ModuleName 
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
        $Global:TokenScript = $TokenScript
        & $Module { $PsrawSettings.AccessToken = $Global:TokenScript }
        { & $Command -Uri $UriDefaultToken } | Should Not Throw
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
            AccessToken = $TokenScript
            Uri         = $UriBad
        }
        Try { & $Command @LocalParams -ErrorAction Stop } 
        Catch {$Exception = $_}
        $Exception.ErrorDetails | Should match "Unable to query Uri"
    }
    It "Handles Handles non-JSON responses" {
        $LocalParams = @{
            AccessToken = $TokenScript
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