[CmdletBinding()]
Param(
    [parameter(Position = 0)]
    [string]$ModuleManifest,
    [parameter(Position = 1)]
    [String]$ModuleName,
    [parameter(Position = 2)]
    [String]$HeaderMkDocsYml,
    [parameter(Position = 3)]
    [String]$ChangeLog,
    [parameter(Position = 4)]
    [String]$ProjectRoot,
    [parameter(Position = 5)]
    [String]$ModuleFolder,
    [parameter(Position = 6)]
    [String]$ReleaseNotes,
    [parameter(Position = 7)]
    [switch]$PrivateDocs,
    [parameter(Position = 8)]
    [switch]$ClassDocs,
    [parameter(Position = 9)]
    [switch]$EnumDocs
)

"ModuleManifest: $ModuleManifest"
"ModuleName: $ModuleName"
"HeaderMkDocsYml: $HeaderMkDocsYml"
"ChangeLog: $ChangeLog"
"ProjectRoot: $ProjectRoot"
"ModuleFolder: $ModuleFolder"
"ReleaseNotes: $ReleaseNotes"
"PrivateDocs: $PrivateDocs"
"ClassDocs: $ClassDocs"
"EnumDocs: $EnumDocs"
" "

$ModuleHelpPath = Join-Path $ProjectRoot "\docs\Module"
$PrivateHelpPath = Join-Path $ProjectRoot "\docs\PrivateFunctions"
$ExampleHelpPath = Join-Path $ProjectRoot "\docs\Examples"
"ModuleHelpPath: $ModuleHelpPath"
"PrivateHelpPath: $PrivateHelpPath"
"ExampleHelpPath: $ExampleHelpPath"
" "

$ModuleFunctions = get-Metadata -Path $ModuleManifest -PropertyName FunctionsToExport
if (-not $ModuleFunctions) {
    "Module '$ModuleName' has no functions to document"
    return
}
"Loading Module from $ModuleManifest"
Remove-Module $ModuleName -Force -ea SilentlyContinue
Import-Module $ModuleManifest -force -Global
Import-Module $ModuleManifest -Force

"Importing build.psm1 "
Import-Module "$ProjectRoot\build.psm1"


"Initializing YAML text..."
$YMLtext = (Get-Content $HeaderMkDocsYml) -join "`n"
$YMLtext = "$YMLtext`n"

"Populating Release Notes"
$parameters = @{
    Path        = $ReleaseNotes
    ErrorAction = 'SilentlyContinue'
}
$ReleaseText = (Get-Content @parameters) -join "`n"
if ($ReleaseText) {
    $ReleaseText | Set-Content "$ProjectRoot\docs\RELEASE.md"
    $YMLText = "$YMLtext  - Release Notes: RELEASE.md`n"
}

"Populating Change Log..."
if ((Test-Path -Path $ChangeLog)) {
    $YMLText = "$YMLtext  - Change Log: ChangeLog.md`n"
}

If ( -not (Test-Path "$ModuleHelpPath")) {
    "Initialize Module Help folder.."
    $Params = @{
        Module         = $ModuleName
        OutputFolder   = "$ModuleHelpPath"
        WithModulePage = $true
        Force          = $true
    }
    New-MarkdownHelp @Params
}

"Updating Module Help documentation..."
$Params = @{
    AlphabeticParamsOrder = $true
    Path                  = "$ModuleHelpPath"
    RefreshModulePage     = $true
}
Update-MarkdownHelpModule @Params

If ($PrivateDocs) {
    "Processing Private Functions..."
    $PrivateFunctions = Get-ModulePrivateFunction -ModuleName $ModuleName
    $PrivateHelp = Get-ChildItem $PrivateHelpPath -Filter '*.md' -ErrorAction SilentlyContinue
    foreach ($PrivateFunction in $PrivateFunctions) {
        $HelpDoc = $PrivateHelp | Where-Object {$_.basename -like $PrivateFunction.Name}
        $FunctionDefinition = "Function {0} {{ {1} }}" -f $PrivateFunction.name, $PrivateFunction.Definition
        . ([scriptblock]::Create($FunctionDefinition))
        if (-not $HelpDoc) {
            $Params = @{
                Command               = $PrivateFunction.name
                Force                 = $true
                AlphabeticParamsOrder = $true
                OutputFolder          = $PrivateHelpPath
                WarningAction         = 'SilentlyContinue'
            }
            New-MarkdownHelp @Params
        }
        $Params = @{
            Path                  = "$PrivateHelpPath\{0}.md" -f $PrivateFunction.Name
            AlphabeticParamsOrder = $true
            WarningAction         = 'SilentlyContinue'
        }
        Update-MarkdownHelp @Params
        Remove-Item "function:\$($PrivateFunction.name)" -ErrorAction SilentlyContinue
    }
}

if ($ClassDocs) {
    "Processing Classes..."
    $Classes = Get-ModuleClass -ModuleName $ModuleName | Where-Object {$_.IsClass}
    $AboutHelpDocs = Get-ChildItem -Path $ModuleHelpPath -Filter 'about_*.md'
    foreach ($Class in $Classes) {
        $HelpDoc = $AboutHelpDocs | Where-Object {$_.basename -like "about_$($Class.Name)"}
        if ($HelpDoc) {
            Update-ClassMarkdown -Class $Class -Path $HelpDoc.FullName
            continue
        }
        $AboutPath = Join-Path $ModuleHelpPath "about_$($Class.Name).md"
        Classtext $Class | Set-Content -Path $AboutPath
    }
}

if ($EnumDocs) {
    "Processing Enums..."
    $Enums = Get-ModuleClass -ModuleName $ModuleName | Where-Object {$_.IsEnum}
    $AboutHelpDocs = Get-ChildItem -Path $ModuleHelpPath -Filter 'about_*.md'
    foreach ($Enum in $Enums) {
        $HelpDoc = $AboutHelpDocs | Where-Object {$_.basename -like "about_$($Enum.Name)"}
        if ($HelpDoc) {
            Update-EnumMarkdown -Enum $Enum -Path $HelpDoc.FullName
            continue
        }
        $AboutPath = Join-Path $ModuleHelpPath "about_$($Enum.Name).md"
        EnumText $Enum | Set-Content -Path $AboutPath
    }
}

$ModuleFiles = Get-ChildItem "$ModuleHelpPath" -ErrorAction SilentlyContinue
if ($ModuleFiles) {
    $YMLText = "$YMLtext  - Module Help:`n"
}
$Index = $ModuleFiles | Where-Object {$_.name -like "$ModuleName.md"}
if ($Index) {
    "Adding Index..."
    $Part = "    - {0}: Module/{1}" -f $ModuleName, $Index.Name
    $YMLText = "{0}{1}`n" -f $YMLText, $Part
}
"Populating YAML Module Documentation.."
$ModuleFiles |
    Where-Object {$_.Name -notlike "$ModuleName.md"} |
    Sort-Object -Property 'Name' |
    foreach-object {
    $Function = $_.Name -replace '\.md', ''
    $Part = "    - {0}: Module/{1}" -f $Function, $_.Name
    $YMLText = "{0}{1}`n" -f $YMLText, $Part
    $Part
}

if ($PrivateDocs) {
    "Populating YAML Private Function Documentation.."
    $PrivateFunctionFiles = Get-ChildItem "$PrivateHelpPath" -ErrorAction SilentlyContinue |
        Sort-Object -Property 'Name'
    if ($PrivateFunctionFiles) {
        $YMLText = "$YMLtext  - Private Functions:`n"
        $PrivateFunctionFiles |
            foreach-object {
            $Function = $_.Name -replace '\.md', ''
            $Part = "    - {0}: PrivateFunctions/{1}" -f $Function, $_.Name
            $YMLText = "{0}{1}`n" -f $YMLText, $Part
            $Part
        }
    }
}


"Populating YAML Examples Documentation.."
$ExampleFiles = Get-ChildItem "$ExampleHelpPath" -Filter '*.md' -ErrorAction SilentlyContinue |
    Sort-Object -Property 'Name'
if ($ExampleFiles) {
    $YMLText = "$YMLtext  - Examples:`n"
    $ExampleFiles |
        foreach-object {
        $Function = (Get-Content $_.FullName -Head 1) -replace '^# '
        $Part = "    - {0}: Examples/{1}" -f $Function, $_.Name
        $YMLText = "{0}{1}`n" -f $YMLText, $Part
        $Part
    }
}


"Setting $ProjectRoot\mkdocs.yml..."
$YMLtext | Set-Content -Path "$ProjectRoot\mkdocs.yml"

"Removing about Topics from external help..."

Get-ChildItem "$ModuleFolder\en-US" -Filter "about_*.txt" | Remove-Item -Force -Confirm:$false

"Generating External help..."
$Params = @{
    Path       = "$ModuleHelpPath"
    OutputPath = "$ModuleFolder\en-US"
    Force      = $true
}
New-ExternalHelp @Params