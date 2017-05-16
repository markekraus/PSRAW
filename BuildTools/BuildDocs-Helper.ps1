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