Using module '..\PSRAW\Classes\RedditApplication.psm1'

$Class = 'RedditApplication'

$ClientId = '54321'
$ClientSceret = '12345'
$SecClientSecret = $ClientSceret | ConvertTo-SecureString -AsPlainText -Force 
$ClientCredential = [pscredential]::new($ClientId,$SecClientSecret)

$UserId = 'reddituser'
$UserSceret = 'password'
$SecUserSecret = $UserSceret | ConvertTo-SecureString -AsPlainText -Force 
$UserCredential = [pscredential]::new($UserId,$SecUserSecret)

$EmptyCred = [System.Management.Automation.PSCredential]::Empty

$TestHashes = @(
    @{
        Name = 'WebApp'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            Type = 'WebApp'
        }
    }
    @{
        Name = 'Script'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            UserCredential = $UserCredential
            Type = 'Script'
        }
    }
    @{
        Name = 'Installed'
        Hash = @{
            Name = 'TestApplication'
            Description = 'This is only a test'
            RedirectUri = 'https://localhost/'
            UserAgent = 'windows:PSRAW-Unit-Tests:v1.0.0.0'
            Scope = 'read'
            ClientCredential = $ClientCredential
            Type = 'Installed'
        }
    }
)
$TestArrays = @(
    @{
        Name = 'WebApp'
        Array = 
            'TestApplication',
            'This is only a test',
            'https://localhost/',
            'windows:PSRAW-Unit-Tests:v1.0.0.0',
            'WebApp',
            [guid]::NewGuid(),
            'c:\RedditApplication.xml',
            'read',
            $ClientCredential,
            $EmptyCred
    }
    @{
        Name = 'Script'
        Array = @(
            'TestApplication'
            'This is only a test'
            'https://localhost/'
            'windows:PSRAW-Unit-Tests:v1.0.0.0'
            'Script'
            [guid]::NewGuid()
            'c:\RedditApplication.xml'
            'read'
            $ClientCredential
            $UserCredential
        )
    }
    @{
        Name = 'Installed'
        Array = @(
            'TestApplication'
            'This is only a test'
            'https://localhost/'
            'windows:PSRAW-Unit-Tests:v1.0.0.0'
            'Installed'
            [guid]::NewGuid()
            'c:\RedditApplication.xml'
            'read'
            $ClientCredential
            $EmptyCred
        )
    }
)

Describe "$Classs Class Tests" -Tag Unit, Build {
    foreach($TestHash in $TestHashes){
        It "Converts the '$($TestHash.Name)' hash"{
            {[RedditApplication]$TestHash.Hash} | should not throw
        }
    }
     It "Has a working Uber Constructor." {
        {
            [RedditApplication]::new(
                'TestApplication',
                'This is only a test',
                'https://localhost/',
                'windows:PSRAW-Unit-Tests:v1.0.0.0',
                'Script',
                [guid]::NewGuid(),
                'c:\RedditApplication.xml',
                'read',
                $ClientCredential,
                $UserCredential
            )
        } | should not throw
    }
    $Application = [RedditApplication]::new('TestApplication',
            'This is only a test',
            'https://localhost/',
            'windows:PSRAW-Unit-Tests:v1.0.0.0',
            'Script',
            [guid]::NewGuid(),
            'c:\RedditApplication.xml',
            'read',
            $ClientCredential,
            $UserCredential)
    It "Has a working GetClientSecret() method" {
        $Application.GetClientSecret() | should be $ClientSceret
    }
    It "Has a working GetClientSecret() method" {
        $Application.GetUserPassword() | should be $UserSceret
    }
    It "Throws an exception with the default constructor" {
        {[RedditApplication]::new()} | Should throw "The method or operation is not implemented."
    }
}