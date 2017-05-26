function Get-ModulePrivateFunction {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.FunctionInfo])]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]
        $ModuleName
    )
    
    process {
        foreach ($Name in $ModuleName) {
            $Module = $null
            Write-Verbose "Processing Module '$Name'"
            $Module = Get-Module -Name $Name -ErrorAction SilentlyContinue
            if (-not $Module) {
                Write-Error "Module '$Name' not found"
                continue
            }
            $ScriptBlock = {
                $ExecutionContext.InvokeCommand.GetCommands('*', 'Function', $true)
            }
            $PublicFunctions = $Module.ExportedCommands.GetEnumerator() | 
                Select-Object -ExpandProperty Value | 
                Select-Object -ExpandProperty Name
            & $Module $ScriptBlock | Where-Object {$_.Source -eq $Name -and $_.Name -notin $PublicFunctions}
        }
    }
}

function Get-ModuleClass {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]
        $ModuleName
    )
    
    process {
        foreach ($Name in $ModuleName) {
            $Module = $null
            Write-Verbose "Processing Module '$Name'"
            $Module = Get-Module -Name $Name -ErrorAction SilentlyContinue
            if (-not $Module) {
                Write-Error "Module '$Name' not found"
                continue
            }
            [System.AppDomain]::CurrentDomain.
            GetAssemblies().
            gettypes().
            where( {$_.Assembly.Modules[0].ScopeName -match "$Name" -and $_.IsPublic })
        }
    }
}