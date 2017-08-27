Class WebListener 
{
    [int]$HttpPort
    [System.Management.Automation.Job]$Job

    WebListener () { }

    [String] GetStatus() 
    {
        return $This.Job.JobStateInfo.State
    }
}

[WebListener]$WebListener

function Get-WebListener 
{
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([WebListener])]
    param()

    process 
    {
        return [WebListener]$Script:WebListener
    }
}

function Start-WebListener 
{
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([WebListener])]
    param 
    (
        [ValidateRange(1,65535)]
        [int]$HttpPort = 8080
    )
    
    process 
    {
        $runningListener = Get-WebListener
        if ($null -ne $runningListener -and $runningListener.GetStatus() -eq 'Running')
        {
            return $runningListener
        }

        $initTimeoutSeconds  = 30
        $appDll              = 'WebListener.dll'
        $initCompleteMessage = 'Now listening on'
        
        $binPath = Join-Path $MyInvocation.MyCommand.Module.ModuleBase 'bin'
        $timeOut = (get-date).AddSeconds($initTimeoutSeconds)        
        $Job = Start-Job {
            Push-Location $using:binPath
            dotnet $using:appDll $using:HttpPort
        }
        $Script:WebListener = [WebListener]@{
            HttpPort  = $HttpPort
            Job       = $Job
        }
        # Wait until the app is running or until the initTimeoutSeconds have been reached
        do
        {
            Start-Sleep -Milliseconds 100
            $initStatus = $Job.ChildJobs[0].Output | Out-String
            $isRunning = $initStatus -match $initCompleteMessage
        }
        while (-not $isRunning -and (get-date) -lt $timeOut)
    
        if (-not $isRunning) 
        {
            $Job | Stop-Job -PassThru | Receive-Job
            $Job | Remove-Job
            throw 'WebListener did not start before the timeout was reached.'
        }
        return $Script:WebListener
    }
}

function Stop-WebListener 
{
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([Void])]
    param()
    
    process 
    {
        $Script:WebListener.job | Stop-Job -PassThru | Remove-Job
        $Script:WebListener = $null
    }
}

function Get-WebListenerUrl {
    [CmdletBinding()]
    [OutputType([Uri])]
    param (
        [String]$Test
    )
    process {
        $runningListener = Get-WebListener
        if ($null -eq $runningListener -or $runningListener.GetStatus() -ne 'Running')
        {
            return $null
        }
        $Uri = [System.UriBuilder]::new()
        $Uri.Host = 'localhost'
        $Uri.Port = $runningListener.HttpPort
        $Uri.Scheme = 'Http'
        $Uri.Path = $Test
        return [Uri]$Uri.ToString()
    }
}
