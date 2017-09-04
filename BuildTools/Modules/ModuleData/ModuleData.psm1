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
            $ModulePattern = $Module.ModuleBase.
                Replace([System.IO.Path]::DirectorySeparatorChar, '.').
                Replace([System.IO.Path]::VolumeSeparatorChar, '.')
            $DynamicClassAttribute =
                [System.Management.Automation.DynamicClassImplementationAssemblyAttribute]
            [AppDomain]::
                CurrentDomain.
                GetAssemblies().
                where({
                    $_.GetCustomAttributes($true).TypeId -contains $DynamicClassAttribute -and
                    $_.FullName -match $ModulePattern
                }).
                GetTypes().
                where({ $_.IsPublic })
        }
    }
}