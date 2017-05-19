<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/18/2017 4:31 AM
     Edited on:     5/18/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:     Update-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
       Update-RedditOAuthToken Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force -Scope Global

$Command = 'Update-RedditOAuthToken'
$TypeName = 'RedditOAuthToken'


Function MyTest {
    $ClientId = '54321'
    $ClientSceret = '12345'
    $SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
    $ClientCredential = [pscredential]::new($ClientId, $SecClientSecret)

    $InstalledId = '54321'
    $SecInstalledSecret = [System.Security.SecureString]::new()
    $InstalledCredential = [pscredential]::new($InstalledId, $SecInstalledSecret)

    $UserId = 'reddituser'
    $UserSceret = 'password'
    $SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
    $UserCredential = [pscredential]::new($UserId, $SecUserSecret)

    $TokenId = 'access_token'
    $TokenSceret = '34567'
    $SecTokenSecret = $TokenSceret | ConvertTo-SecureString -AsPlainText -Force 
    $TokenCredential = [pscredential]::new($TokenId, $SecTokenSecret)

    $RefreshId = 'refresh_token'
    $RefreshSceret = '76543'
    $SecRefreshSecret = $RefreshSceret | ConvertTo-SecureString -AsPlainText -Force 
    $RefreshCredential = [pscredential]::new($RefreshId, $SecRefreshSecret)

    $ApplicationScript = [RedditApplication]@{
        Name = 'TestApplication'
        Description = 'This is only a test'
        RedirectUri = 'https://localhost/'
        UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope = 'read'
        ClientCredential = $ClientCredential
        UserCredential = $UserCredential
        Type = 'Script'
    }
    $ApplicationInstalled = [RedditApplication]@{
        Name = 'TestApplication'
        Description = 'This is only a test'
        RedirectUri = 'https://localhost/'
        UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
        Scope = 'read'
        ClientCredential = $InstalledCredential
        Type = 'Installed'
    }
    $TokenInstalled = [RedditOAuthToken]@{
        Application = $ApplicationInstalled
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationInstalled.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Installed_Client'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        DeviceID = 'MyDeviceID'
    }

    $TokenCode = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Authorization_Code'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        RefreshCredential = $RefreshCredential.psobject.copy()
    }

    $TokenPassword = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Password'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
    }

    $TokenClient = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Client_Credentials'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
    }

    $TokenImplicit = [RedditOAuthToken]@{
        Application = $ApplicationInstalled
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationInstalled.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Implicit'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
    }

    $TokenWhatif = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Authorization_Code'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        RefreshCredential = $RefreshCredential.psobject.copy()
    }

    $TokenReturns = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Authorization_Code'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        RefreshCredential = $RefreshCredential.psobject.copy()
    }

    $TokenForce = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = Get-Date
        ExpireDate = (Get-Date).AddHours(1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Authorization_Code'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        RefreshCredential = $RefreshCredential.psobject.copy()
    }

    $TokenPassthru = [RedditOAuthToken]@{
        Application = $ApplicationScript
        IssueDate = (Get-Date).AddHours(-2)
        ExpireDate = (Get-Date).AddHours(-1)
        LastApiCall = Get-Date
        Scope = $ApplicationScript.Scope
        GUID = [guid]::NewGuid()
        TokenType = 'bearer'
        GrantType = 'Authorization_Code'
        RateLimitUsed = 0
        RateLimitRemaining = 60
        RateLimitRest = 60
        TokenCredential = $TokenCredential.psobject.copy()
        RefreshCredential = $RefreshCredential.psobject.copy()
    }

    $ParameterSets = @(
        @{
            Name = 'Code'
            Params = @{
                AccessToken = $TokenCode
            }
        }
        @{
            Name = 'Installed'
            Params = @{
                AccessToken = $TokenInstalled
            }
        }
        @{
            Name = 'Password'
            Params = @{
                AccessToken = $TokenPassword
            }
        }
        @{
            Name = 'Client'
            Params = @{
                AccessToken = $TokenClient
            }
        }
        @{
            Name   = 'Implicit'
            Params = @{
                AccessToken = $TokenImplicit
            }
        }
    )
    Mock -CommandName Request-RedditOAuthTokenInstalled -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "AABBCC", "token_type": "bearer", "device_id": "MyDeviceID", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenRefresh -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "AABBCC", "token_type": "bearer", "expires_in": 3600, "scope": "read"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenPassword -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "AABBCC", "token_type": "bearer", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenClient -ModuleName $moduleName -MockWith {
        $Result = [pscustomobject]@{
            Content = '{"access_token": "AABBCC", "token_type": "bearer", "expires_in": 3600, "scope": "*"}'
            Headers = @{
                'Content-Type' = 'application/json'
            }
        }
        return $Result
    }
    Mock -CommandName Request-RedditOAuthTokenImplicit -ModuleName $moduleName -MockWith {
        $Result = [System.Uri]('{0}#access_token=AABBCC&token_type=bearer&state={1}&expires_in=3600&scope=read' -f $Application.RedirectUri, $State)
        return $Result
    }
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
    It "Supports Whatif" {
        $TokenWhatif | & $Command -whatif         
        $TokenWhatif.GetAccessToken() | should be 34567
    }
    It "Supports PassThru" {
        $Result = & $Command -AccessToken $TokenPassthru -PassThru
        $Result.GetAccessToken() | should be AABBCC
    }
    It "Supports Force" {
        & $Command -Force -AccessToken $TokenForce
        $TokenForce.GetAccessToken() | Should be 'AABBCC'
    }
    
}
Describe "$command Unit" -Tags Unit {
    $commandpresent = Get-Command -Name $Command -Module $moduleName -ErrorAction SilentlyContinue
    if (-not $commandpresent) {
        Write-Warning "'$command' was not found in '$moduleName' during prebuild tests. It may not yet have been added the module. Unit tests will be skipped until after build."
        return
    }
    MyTest
}
Describe "$command Build" -Tags Build {
    MyTest
}
