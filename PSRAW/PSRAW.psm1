<#	
    
     Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.139
     Created on:   	4/23/2017 9:22 AM
     Edited On:     8/03/2017
     Created by:   	Mark Kraus
     Organization: 	
     Filename:     	PSRAW.psm1
    -------------------------------------------------------------------------
     Module Name: PSRAW
    
#>

# v6 Invoke-WebRequest uses strict header validation by default and introduced a 
# SkipHeaderValidation Switch Parameter. Reddit requires a non-compliant 
# User-Agent format. Setting this Default Parameter value allows for backwards 
# compatibility with 5.1 without having to introduce version check logic before 
# each Invoke-WebRequest call.
$PSDefaultParameterValues['Invoke-WebRequest:SkipHeaderValidation'] = $True

$functionFolders = @('Enums','Classes','Public','Private' )
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $FunctionFiles = Get-ChildItem -Path $folderPath -Filter '*.ps1' -Recurse |
            Where-Object { $_.Name -notmatch '\.tests{0,1}\.ps1' }
        ForEach ($FunctionFile in $FunctionFiles)
        {
            Write-Verbose -Message "  Importing $($FunctionFile.BaseName)"
            . $($FunctionFile.FullName)
        }
    }    
}
$folderPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$FunctionFiles = Get-ChildItem $folderPath -Filter '*.ps1' -Recurse |
            Where-Object { $_.Name -notmatch '\.tests{0,1}\.ps1' }
foreach ($FunctionFile in $FunctionFiles) {
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)        
    $Functions = $AST.FindAll({
            $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
    if ($Functions.Name) {
        Export-ModuleMember -Function $Functions.Name
    }
    $Aliases = $AST.FindAll({
            $args[0] -is [System.Management.Automation.Language.AttributeAst] -and
            $args[0].parent -is [System.Management.Automation.Language.ParamBlockAst] -and
            $args[0].TypeName.FullName -eq 'alias'
        }, $true)
    if ($Aliases.PositionalArguments.value) {
        Export-ModuleMember -Alias $Aliases.PositionalArguments.value
    }        
}

[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    "PSUseDeclaredVarsMoreThanAssignments", 
    "",
    Justification = 'PsrawSettings is a module settings variable consumed in module functions'
)]
$PsrawSettings = @{
    AccessToken = [RedditOAuthToken]::new()
}