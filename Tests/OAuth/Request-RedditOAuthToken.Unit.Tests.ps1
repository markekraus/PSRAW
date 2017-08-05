<#	
    .NOTES
    
     Created with:  VSCode
     Created on:    5/07/2017 8:50 AM
     Edited on:     5/20/2017
     Created by:    Mark Kraus
     Organization: 	
     Filename:      Request-RedditOAuthToken.Unit.Tests.ps1
    
    .DESCRIPTION
        Request-RedditOAuthToken Function unit tests
#>
$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
$moduleName = Split-Path $moduleRoot -Leaf
Remove-Module -Force $moduleName  -ErrorAction SilentlyContinue
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force
Import-Module (Join-Path $moduleRoot "$moduleName.psd1") -force -Scope Global

$Command = 'Request-RedditOAuthToken'
$TypeName = 'RedditOAuthToken'

#region insanity
# For whatever reason, pester chokes trying to mock 
# Request-RedditOAuthTokenInstalled
# Request-RedditOAuthTokenPassword
# Request-RedditOAuthTokenClient 
# So, we remove them from the module and replace it with a script scope function
# We later mock that function too because it wont work without the mock either
$module = Get-Module $moduleName
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

$ApplicationWebApp = [RedditApplication]@{
    Name             = 'TestApplication'
    Description      = 'This is only a test'
    RedirectUri      = 'https://localhost/'
    UserAgent        = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
    Scope            = 'read'
    ClientCredential = $ClientCredential
    Type             = 'WebApp'
}
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
$ParameterSets = @(
    @{
        Name   = 'Script/Script'
        Params = @{
            Application = $ApplicationScript
            Script      = $True
        }
    }
    @{
        Name   = 'Client/Script'
        Params = @{
            Application = $ApplicationScript
            Client      = $True
        }
    }
    @{
        Name   = 'Client/WebApp'
        Params = @{
            Application = $ApplicationWebApp
            Client      = $True
        }
    }
    @{
        Name   = 'Installed/Installed'
        Params = @{
            Application = $ApplicationInstalled
            Installed   = $True
        }
    }
    @{
        Name   = 'Installed/Installed/DeviceID'
        Params = @{
            Application = $ApplicationInstalled
            Installed   = $True
            DeviceID    = 'MyDeviceID'
        }
    }
)
Function MyTest {
    Mock -CommandName Request-RedditOAuthTokenInstalled -ModuleName $moduleName -MockWith {
        # {"access_token": "34567", "token_type": "bearer", "device_id": "MyDeviceID", "expires_in": 3600, "scope": "*"}
        $EchoUriInstalled = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%2234567%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22device_id%22%3A%20%22MyDeviceID%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriInstalled
        $Global:EchoResponseInstalled = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponseInstalled
    }
    Mock -CommandName Request-RedditOAuthTokenPassword -ModuleName $moduleName -MockWith {
        # {"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "scope": "*"}
        $EchoUriPassword = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%2234567%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriPassword
        $Global:EchoResponsePassword = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponsePassword 
    }
    Mock -CommandName Request-RedditOAuthTokenClient -ModuleName $moduleName -MockWith {
        # '{"access_token": "34567", "token_type": "bearer", "expires_in": 3600, "scope": "*"}
        $EchoUriClient = 'http://urlecho.appspot.com/echo?status=200&Content-Type=application%2Fjson&body=%7B%22access_token%22%3A%20%2234567%22%2C%20%22token_type%22%3A%20%22bearer%22%2C%20%22expires_in%22%3A%203600%2C%20%22scope%22%3A%20%22*%22%7D'
        $Response = Invoke-WebRequest -UseBasicParsing -Uri $EchoUriClient
        $Global:EchoResponseClient = [RedditOAuthResponse]@{
            Response    = $Response
            RequestDate = $Response.Headers.Date[0]
            Content     = $Response.Content
            ContentType = 'application/json'
        } 
        return $Global:EchoResponseClient
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
        $LocalParams = $ParameterSets[0].Params.psobject.Copy()
        $Object = & $Command @LocalParams | Select-Object -First 1
        $Object.psobject.typenames.where( { $_ -eq $TypeName }) | Should be $TypeName
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
