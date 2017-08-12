<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/18/2017 4:31 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Update-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
       Update-RedditOAuthToken Function unit tests
#>
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot\*\*.psd1")
$Global:moduleName = Split-Path $ModuleRoot -Leaf
Remove-Module -Force $ModuleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $ModuleRoot "$ModuleName.psd1") -force

$Global:Command = 'Update-RedditOAuthToken'
$Global:TypeName = 'RedditOAuthToken'



#region insanity
# For whatever reason, pester chokes trying to mock 
# Request-RedditOAuthTokenInstalled
# Request-RedditOAuthTokenPassword
# Request-RedditOAuthTokenClient 
# So, we remove them from the module and replace it with a script scope function
# We later mock that function too because it wont work without the mock either
$module = Get-Module $ModuleName
& $module {
    $Commands = @(
        'Request-RedditOAuthTokenInstalled'
        'Request-RedditOAuthTokenPassword' 
        'Request-RedditOAuthTokenClient'
    )
    foreach ($RemoveCom in $Commands) {
        Get-ChildItem function:\ | 
            Where-Object {$_.name -like $RemoveCom} | 
            Remove-Item -Force -Confirm:$false
        Get-ChildItem function:\ | 
            Where-Object {$_.name -like $RemoveCom} | 
            Remove-Item -Force -Confirm:$false
    }
}
function Request-RedditOAuthTokenInstalled {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [Object[]]
        $Params
    )
    process { }
}
function Request-RedditOAuthTokenPassword {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [Object[]]
        $Params
    )
    process {   }
}
function Request-RedditOAuthTokenClient {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [Object[]]
        $Params
    )
    process {   }
}
#endregion insanity


$Command = $Global:Command
$TypeName = $Global:TypeName
$ModuleName = $Global:moduleName
<#Mock -CommandName Request-RedditOAuthTokenInstalled -ModuleName $ModuleName -MockWith {
        return $Global:EchoResponseInstalled
    }
    Mock -CommandName Request-RedditOAuthTokenPassword -ModuleName $ModuleName -MockWith {
        return $Global:EchoResponsePassword
    }
    Mock -CommandName Request-RedditOAuthTokenClient -ModuleName $ModuleName -MockWith {
        return $Global:EchoResponseClient
    }#>
Function MyTest {
    Mock -CommandName Request-RedditOAuthTokenInstalled -ModuleName $ModuleName -MockWith {
        $EchoUriInstalled = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%22AABBCC%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22device_id%22%3A%20%22MyDeviceID%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriInstalled
        $Global:EchoResponseInstalled = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponseInstalled
    }
    Mock -CommandName Request-RedditOAuthTokenPassword -ModuleName $ModuleName -MockWith {
        $EchoUriPassword = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%22AABBCC%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriPassword
        $Global:EchoResponsePassword = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponsePassword 
    }
    Mock -CommandName Request-RedditOAuthTokenClient -ModuleName $ModuleName -MockWith {
        $EchoUriClient = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%22AABBCC%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriClient
        $Global:EchoResponseClient = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponseClient
    }
    $Command = $Global:Command
    $TypeName = $Global:TypeName
    $ModuleName = $Global:moduleName

    $ClientId = '54321'
    $ClientSecret = '12345'
    $SecClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $InstalledId = '54321'
    $SecInstalledSecret = [System.Security.SecureString]::new()
    $InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

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
    $ApplicationInstalled = [RedditApplication]@{
        Name             = 'TestApplication'
        Description      = 'This is only a test'
        RedirectUri      = 'https://localhost/'
        UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope            = 'read'
        ClientCredential = $InstalledCredential
        Type             = 'Installed'
    }
    $TokenInstalled = [RedditOAuthToken]@{
        Application        = $ApplicationInstalled
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationInstalled.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Installed_Client'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
        DeviceID           = 'MyDeviceID'
    }

    $TokenPassword = [RedditOAuthToken]@{
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

    $TokenClient = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = (Get-Date).AddHours(-2)
        ExpireDate         = (Get-Date).AddHours(-1)
        LastApiCall        = Get-Date
        Scope              = $ApplicationScript.Scope
        GUID               = [guid]::NewGuid()
        TokenType          = 'bearer'
        GrantType          = 'Client_Credentials'
        RateLimitUsed      = 0
        RateLimitRemaining = 60
        RateLimitRest      = 60
        TokenCredential    = $TokenCredential.psobject.copy()
    }

    $TokenWhatIf = [RedditOAuthToken]@{
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

    $TokenReturns = [RedditOAuthToken]@{
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

    $TokenForce = [RedditOAuthToken]@{
        Application        = $ApplicationScript
        IssueDate          = Get-Date
        ExpireDate         = (Get-Date).AddHours(1)
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

    $TokenPassThru = [RedditOAuthToken]@{
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

    $TokenDefault = [RedditOAuthToken]@{
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

    $TokenSetDefault = [RedditOAuthToken]@{
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

    $ParameterSets = @(
        @{
            Name   = 'Installed'
            Params = @{
                AccessToken = $TokenInstalled
            }
        }
        @{
            Name   = 'Password'
            Params = @{
                AccessToken = $TokenPassword
            }
        }
        @{
            Name   = 'Client'
            Params = @{
                AccessToken = $TokenClient
            }
        }
    )
        
    foreach ($ParameterSet in $ParameterSets) {
        It "'$($ParameterSet.Name)' Parameter set does not have errors" {
            $LocalParams = $ParameterSet.Params
            { & $Command @LocalParams -ErrorAction Stop } | Should not throw
        }
    }
    It "Emits a $TypeName Object" {
        (Get-Command $Command).OutputType.Name.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Returns a $TypeName Object" {
        $LocalParams = @{
            AccessToken = $TokenReturns
            PassThru    = $true
        }
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq $TypeName }) | Should be $TypeName
    }
    It "Supports WhatIf" {
        $TokenWhatIf | & $Command -WhatIf         
        $TokenWhatIf.GetAccessToken() | should be 34567
    }
    It "Supports PassThru" {
        $Result = & $Command -AccessToken $TokenPassThru -PassThru
        $Result.GetAccessToken() | should be AABBCC
    }
    It "Supports Force" {
        & $Command -Force -AccessToken $TokenForce
        $TokenForce.GetAccessToken() | Should be 'AABBCC'
    }
    It "Updates the Default Token if one is not provided" {
        $TokenDefault | Set-RedditDefaultOAuthToken
        (Get-RedditDefaultOAuthToken).GetAccessToken() | should be 34567
        {  & $Command -ErrorAction Stop } | Should Not Throw
        (Get-RedditDefaultOAuthToken).GetAccessToken() | should be AABBCC
    }
    It "Sets the Updated token to the Default Token with -SetAsDefault" {
        [RedditOAuthToken]::new() | Set-RedditDefaultOAuthToken
        $TokenSetDefault.GetAccessToken() | should be 34567
        {  & $Command -AccessToken  $TokenSetDefault -SetDefault -ErrorAction Stop } | Should Not Throw
        (Get-RedditDefaultOAuthToken).GUID | should be $TokenSetDefault.GUID
    }
}
Describe "$Command Unit" -Tags Unit {
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