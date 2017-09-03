$ClassHeader = @'
# $Name
## about_$Name

# SHORT DESCRIPTION
Describes the $Name Class

# LONG DESCRIPTION
{{ Long Description Placeholder }}
`r`n
'@

$EnumHeader = @'
# $Name
## about_$Name

# SHORT DESCRIPTION
Describes the $Name Enum

# LONG DESCRIPTION
{{ Long Description Placeholder }}
`r`n
'@

$ConstructorTemplate = @'
## $Heading
{{ Constructor Description Placeholder }}

``````powershell
[$ClassName]::new($PSParams)
``````
`r`n
'@

$PropertyTemplate = @'
## $Heading
{{ Property Description Placeholder }}

``````yaml
Name: $Name
Type: $Type
Hidden: $IsHidden
Static: $IsStatic
``````
`r`n
'@

$MethodTemplate = @'
## $Heading
{{ Method Description Placeholder }}

``````yaml
Name: $Name
Return Type: $ReturnType
Hidden: $IsHidden
Static: $IsStatic
Definition: $Definition
``````
`r`n
'@

$FieldTemplate = @'
## $Heading
{{ Field Description Placeholder }}
`r`n
'@

$Footer = @'
# EXAMPLES
{{ Code or descriptive examples of how to leverage the functions described. }}

# NOTE
{{ Note Placeholder - Additional information that a user needs to know.}}

# TROUBLESHOOTING NOTE
{{ Troubleshooting Placeholder - Warns users of bugs}}

{{ Explains behavior that is likely to change with fixes }}

# SEE ALSO
{{ See also placeholder }}

{{ You can also list related articles, blogs, and video URLs. }}

# KEYWORDS
{{List alternate names or titles for this topic that readers might use.}}

- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}
- {{ Keyword Placeholder }}    
`r`n
'@


Function MethodHeading {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Method
    )
    process {
        foreach ($MyMethod in $Method) {
            $Params = ($MyMethod.GetParameters() | ForEach-Object {
                    $Type = $_.ParameterType -replace '^System\.([^.]*)$', '$1'
                    "{0} {1}" -f $type, $_.name
                }) -Join ", "
            $Name = $MyMethod.Name
            "{0}({1})" -f $Name, $Params
        }
    }
}

Function MethodText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Method
    )
    process {
        foreach ($MyMethod in ($Method | Sort-Object Name ) ) {
            $Params = ($MyMethod.GetParameters() | ForEach-Object {
                    $Type = $_.ParameterType -replace '^System\.([^.]*)$', '$1'
                    "{0} {1}" -f $type, $_.name
                }) -Join ", "
            $Access = ''
            $IsHidden = $False
            if ($MyMethod.CustomAttributes.AttributeType.Name -contains 'HiddenAttribute') {
                $Access = 'hidden '
                $IsHidden = $true
            }
            $IsStatic = $MyMethod.IsStatic
            $Scope = ''
            if ($MyMethod.IsStatic) {
                $Scope = 'static '
            }
            $Name = $MyMethod.Name
            $ReturnType = $MyMethod.ReturnType.FullName -replace '^System\.([^.]*)$', '$1'
            $Definition = "{0}{1}{2} {3}({4})" -f $scope, $Access, $ReturnType, $Name, $Params
            $Heading = MethodHeading $MyMethod
    
            $ExecutionContext.InvokeCommand.ExpandString($MethodTemplate)
        }
    }
}

Function ClassMethodText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Class
    )
    begin {
        [string]$OutText = "# Methods`r`n"
    }
    process {
        foreach ($MyClass in $Class) {
            $Methods = $MyClass.DeclaredMembers.where( {$_.MemberType -eq 'Method' -and -not $_.IsSpecialname})
            foreach ($Method in ($Methods | Sort-Object Name ) ) {    
                $OutText += MethodText $Method
            }
        }        
    }
    End {
        $OutText -join "`r`n`r`n"
    }
}

Function ConstructorHeading {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Constructor
    )
    process {
        foreach ($MyConstructor in ($Constructor) ) {
            $Params = ($MyConstructor.GetParameters() | ForEach-Object {
                    $Type = $_.ParameterType -replace '^System\.([^.]*)$', '$1'
                    "{0} {1}" -f $type, $_.name
                }) -Join ", "
            $ClassName = $MyConstructor.DeclaringType.Name
            "{0}({1})" -f $ClassName, $Params
        }
    }
}

Function ConstructorText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Constructor
    )
    process {
        foreach ($MyConstructor in $Constructor ) {
            $PSParams = ($MyConstructor.GetParameters() | ForEach-Object {
                    $Type = $_.ParameterType -replace '^System\.([^.]*)$', '$1'
                    '[{0}]${1}' -f $type, $_.name
                }) -Join ", "
            $ClassName = $MyConstructor.DeclaringType.Name
            $Definition = ConstructorHeading $MyConstructor
            $Heading = ConstructorHeading $MyConstructor
    
            $ExecutionContext.InvokeCommand.ExpandString($ConstructorTemplate)
        }
    }
}

Function ClassConstructorText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Class
    )
    begin {
        [string]$OutText = "# Constructors`r`n"
    }
    process {
        foreach ($MyClass in $Class) {
            $Constructors = $Class.GetConstructors() |
                ForEach-Object {
                [PSCustomObject]@{
                    Count       = $_.GetParameters().Count
                    Constructor = $_
                }
            } | Sort-Object Count | Select-Object -ExpandProperty Constructor
            foreach ($Constructor in ($Constructors) ) {    
                $OutText += ConstructorText $Constructor
            }
        }        
    }
    End {
        $OutText -join "`r`n`r`n"
    }
}
Function PropertyText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Property
    )
    process {
        foreach ($MyProperty in $Property ) {
            $IsHidden = $False
            if ($MyProperty.CustomAttributes.AttributeType.Name -contains 'HiddenAttribute') {
                $IsHidden = $true
            }
            $IsStatic = $MyProperty.GetMethod.IsStatic
            $Name = $MyProperty.Name
            $Type = $MyProperty.PropertyType.FullName -replace '^System\.([^.]*)$', '$1'
            $Heading = $MyProperty.Name

            $ExecutionContext.InvokeCommand.ExpandString($PropertyTemplate )
        }    
    }
}

Function ClassPropertyText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Class
    )
    begin {
        [string]$OutText = "# Properties`r`n"
    }
    process {
        foreach ($MyClass in $Class) {
            $Properties = $MyClass.DeclaredMembers.where( {$_.MemberType -eq 'Property' -and -not $_.IsSpecialname})
            foreach ($Property in ($Properties | Sort-Object Name ) ) {
                $OutText += PropertyText $Property
            }
        }        
    }
    End {
        $OutText -join "`r`n`r`n"
    }
}

function FieldText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Field
    )
    process {
        foreach ($MyField in $Field) {
            $Heading = $Field.Name
            $ExecutionContext.InvokeCommand.ExpandString($FieldTemplate )
        }
    }
}

function ClassFieldText {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Class
    )
    begin {
        [string]$OutText = "# Fields`r`n"
    }
    process {
        foreach ($MyClass in $Class) {
            $Fields = $MyClass.GetFields().where( {-not $_.IsSpecialName})
            foreach ($Field in ($Fields | Sort-Object Name )) {
                $OutText += FieldText $Field
            }
        }
    }
    End {
        $OutText -join "`r`n`r`n"
    }
}

Function ClassText {
    [cmdletbinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Class
    )
    process {
        foreach ($MyClass in $Class) {
            $Name = $MyClass.Name
            $ExecutionContext.InvokeCommand.ExpandString($ClassHeader)
            ClassConstructorText $MyClass
            ClassPropertyText $MyClass
            ClassMethodText $MyClass
            $ExecutionContext.InvokeCommand.ExpandString($Footer)
        }
    }
}

Function EnumText {
    [cmdletbinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Object[]]
        $Enum
    )
    process {
        foreach ($MyEnum in $Enum) {
            $Name = $MyEnum.Name
            $ExecutionContext.InvokeCommand.ExpandString($EnumHeader)
            ClassFieldText $MyEnum
            $ExecutionContext.InvokeCommand.ExpandString($Footer)
        }
    }
}

function ConvertFrom-MarkDown {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path
    )
    
    process {
        foreach ($MyPath in $Path) {
            $Object = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
            $Headingindex = -1
            Get-Content -Path $MyPath | ForEach-Object {
                $Line = $_
                if ($Line -match '^\s*#[^#]') {
                    $Object.add(@{
                            Heading     = $Line -replace '^\s*#\s*'
                            Text        = [System.Collections.Generic.List[System.String]]::new()
                            Subheadings = [System.Collections.Generic.List[System.Collections.Hashtable]]::new()
                        })
                    $SubheadingIndex = -1
                    $Headingindex++
                    return
                }
                if ($Line -match '^\s*##[^#]') {
                    $Object[$Headingindex].Subheadings.add(@{
                            Heading = $Line -replace '^\s*##\s*'
                            Text    = [System.Collections.Generic.List[System.String]]::new()
                        })
                    $SubheadingIndex++
                    return
                }
                if ($SubheadingIndex -ge 0) {
                    $Object[$Headingindex].Subheadings[$SubheadingIndex].Text += $Line 
                    return
                }
                $Object[$Headingindex].Text += $Line
            }
            $Object
        }
    }      
}

function ConvertTo-MarkDown {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Generic.List[System.Collections.Hashtable]]
        $InputObject
    )
    
    process {
        foreach ($Heading in $InputObject) {
            "# {0}" -f $Heading.Heading
            $Heading.Text
            $Subheadings = $Heading.Subheadings
            if ($Heading.Heading -match 'Properties|Methods|Fields') {
                $Subheadings = $Heading.Subheadings | Sort-Object {$_.Heading}
            }
            if ($Heading.Heading -match 'Constructors') {
                $Subheadings = $Heading.Subheadings | Sort-Object -Property @{ 
                    Expression = {
                        if ($_.Heading -match '\(\)') {-1}
                        else {($_.Heading -split ',').count}
                    }
                    Ascending  = $true
                }
            }
            foreach ($Subheading in $Subheadings) {
                "## {0}" -f $Subheading.Heading
                $Subheading.Text
            }
        }
    }
}

function Update-ClassMarkdown {
    [CmdletBinding()]
    param (
        [object]$Class,
        [string]$Path
    )
    process {
        "Updating $($class.name) in $Path"
        $Changed = $false
        $HelpObject = ConvertFrom-MarkDown -Path $Path

        $HelpProperties = $HelpObject | Where-Object {$_.Heading -eq 'Properties'}
        $ClassProperties = $Class.DeclaredMembers.where( {$_.MemberType -eq 'Property' -and -not $_.IsSpecialName})
        # Add missing to HelpDoc
        foreach ($ClassProperty in $ClassProperties) {
            if ($ClassProperty.Name -in $HelpProperties.Subheadings.Heading) {continue}
            "Adding Property {0}" -f $ClassProperty.Name
            $Changed = $true
            $HelpProperties.Subheadings.Add(
                @{
                    Heading = $ClassProperty.Name
                    Text    = (PropertyText $ClassProperty) -split "`r`n" | Select-Object -Skip 1
                }
            )
        }
        # Remove deleted from HelpDoc
        $RemoveIndexes = [System.Collections.Generic.List[System.Int32]]::new()
        foreach ($HelpProperty in $HelpProperties.Subheadings) {
            if ($HelpProperty.Heading -in $ClassProperties.Name) {continue}
            "Removing Property {0}" -f $HelpProperty.Heading
            $Changed = $true
            $RemoveIndexes.add($HelpProperties.Subheadings.IndexOf($HelpProperty))
        }
        foreach ($RemoveIndex in $RemoveIndexes) {
            $null = $HelpProperties.Subheadings.Remove($HelpProperties.Subheadings[$RemoveIndex])
        }


        $HelpMethods = $HelpObject | Where-Object {$_.Heading -eq 'Methods'}
        $ClassMethods = $Class.DeclaredMembers.where( {$_.MemberType -eq 'Method' -and -not $_.IsSpecialName})
        # Add missing to HelpDoc
        foreach ($ClassMethod in $ClassMethods) {
            $ClassMethodheading = MethodHeading $ClassMethod
            if ($ClassMethodheading -in $HelpMethods.Subheadings.Heading) {continue}
            "Adding Method {0}" -f $ClassMethodheading
            $Changed = $true
            $HelpMethods.Subheadings.Add(
                @{
                    Heading = $ClassMethodheading
                    Text    = (MethodText $ClassMethod) -split "`r`n" | Select-Object -Skip 1
                }
            )
        }
        # Remove deleted from HelpDoc
        try {
            $ClassMethodHeadings = MethodHeading $ClassMethods     
        }
        catch {
            $ClassMethodHeadings = $null
        }
        $RemoveIndexes = [System.Collections.Generic.List[System.Int32]]::new()
        foreach ($HelpMethod in $HelpMethods.Subheadings) {
            if ($HelpMethod.Heading -in $ClassMethodHeadings) {continue}
            "Removing Method {0}" -f $HelpMethod.Heading
            $Changed = $true
            $RemoveIndexes.add($HelpMethods.Subheadings.IndexOf($HelpMethod))
        }
        foreach ($RemoveIndex in $RemoveIndexes) {
            $null = $HelpMethods.Subheadings.Remove($HelpMethods.Subheadings[$RemoveIndex])
        }


        $HelpConstructors = $HelpObject | Where-Object {$_.Heading -eq 'Constructors'}
        $ClassConstructors = $Class.GetConstructors()
        # Add missing to HelpDoc
        foreach ($ClassConstructor in $ClassConstructors) {
            $ClassConstructorHeading = ConstructorHeading $ClassConstructor
            if ($ClassConstructorHeading -in $HelpConstructors.Subheadings.Heading) {continue}
            "Adding Constructor {0}" -f $ClassConstructorHeading
            $Changed = $true
            $HelpConstructors.Subheadings.Add(
                @{
                    Heading = $ClassConstructorHeading
                    Text    = (ConstructorText $ClassConstructor) -split "`r`n" | Select-Object -Skip 1
                }
            )
        }
        # Remove deleted from HelpDoc
        $ClassConstructorHeadings = ConstructorHeading $ClassConstructors 
        $RemoveIndexes = [System.Collections.Generic.List[System.Int32]]::new()
        foreach ($HelpConstructor in $HelpConstructors.Subheadings) {
            if ($HelpConstructor.Heading -in $ClassConstructorHeadings) {continue}
            "Removing Constructor {0}" -f $HelpConstructor.Heading
            $Changed = $true
            $RemoveIndexes.add($HelpConstructors.Subheadings.IndexOf($HelpConstructor))
        }
        foreach ($RemoveIndex in $RemoveIndexes) {
            $null = $HelpConstructors.Subheadings.Remove($HelpConstructors.Subheadings[$RemoveIndex])
        }
        if ($Changed) {
            $HelpObject | ConvertTo-MarkDown | Set-Content -Path $Path
        }
    }
}

function Update-EnumMarkdown {
    [CmdletBinding()]
    param (
        [object]$Enum,
        [string]$Path
    )
    process {
        "Updating $($Enum.name) in $Path"
        $Changed = $false
        $HelpObject = ConvertFrom-MarkDown -Path $Path

        $HelpFields = $HelpObject | Where-Object {$_.Heading -eq 'Fields'}
        $ClassFields = $Enum.GetFields().where( {-not $_.IsSpecialName}).name
        
        # Add missing to HelpDoc
        foreach ($ClassField in $ClassFields) {
            if ($ClassField -in $HelpFields.Subheadings.Heading) {continue}
            "Adding Field {0}" -f $ClassField
            $Changed = $true
            $HelpFields.Subheadings.Add(
                @{
                    Heading = $ClassField
                    Text    = (FieldText $ClassField) -split "`r`n" | Select-Object -Skip 1
                }
            )
        }
        
        # Remove deleted from HelpDoc
        $RemoveIndexes = [System.Collections.Generic.List[System.Int32]]::new()
        foreach ($HelpField in $HelpFields.Subheadings) {
            if ($HelpField.Heading -in $ClassFields) {continue}
            "Removing Field {0}" -f $HelpField.Heading
            $Changed = $true
            $RemoveIndexes.add($HelpFields.Subheadings.IndexOf($HelpField))
        }
        foreach ($RemoveIndex in $RemoveIndexes) {
            $null = $HelpFields.Subheadings.Remove($HelpFields.Subheadings[$RemoveIndex])
        }

        if ($Changed) {
            $HelpObject | ConvertTo-MarkDown | Set-Content -Path $Path
        }
    }
    
}
