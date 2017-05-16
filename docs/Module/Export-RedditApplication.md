---
external help file: PSRAW-help.xml
online version: https://psraw.readthedocs.io/en/latest/Module/Export-RedditApplication
schema: 2.0.0
---

# Export-RedditApplication

## SYNOPSIS
Exports a `RedditApplication` object to an XML file.

## SYNTAX

### ExportPath (Default)
```
Export-RedditApplication [-Encoding <String>] -Application <RedditApplication> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Path
```
Export-RedditApplication -Path <String> [-Encoding <String>] -Application <RedditApplication> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### LiteralPath
```
Export-RedditApplication -LiteralPath <String> [-Encoding <String>] -Application <RedditApplication> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Allows you to export a `RedditApplication` object to an XML file so that you can later import the object via `Import-RedditApplication`. This allows you to share the same Reddit application between multiple scripts. This function is a wraper for `Export-Clixml`. 

User Passwords and Client Secrets stored in the `RedditApplication` object are stored as secure strings and are not visible as plaintext in the export file. This also means that a `RedditApplication` object exported by one user cannot be imported by another user on the same computer nor can it be imported by the same user on a different computer. It can only be imported by the same user on the same computer.

The maximum depth will be set on `Export-Clixml`.

New `RedditApplication` objects can be created manually or with `New-RedditApplication`.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Application.ExportPath = 'c:\PSRAW\RedditApplication.xml'
$Application | Export-RedditApplication
```

This example uses the `ExportPath` property on the `RedditApplication` object to determine where to export the application. When a `RedditApplication` object is imported with `Import-RedditApplication`, the `ExportPath` of the object will be set with the path to the file it was imported from. This amkes it easy to import, make changes, and then re-export the application. The `ExportPath` property is treated as a `LiteralPath`.

### -------------------------- EXAMPLE 2 --------------------------
```
$Application | Export-RedditApplication -Path 'c:\PSRAW\RedditApplication.xml'
```

This example uses the `Path` parameter to either override the `ExportPath` property on the `RedditApplication` object or to set export location when an `ExportPath` is not present.

### -------------------------- EXAMPLE 3 --------------------------
```
$Application | Export-RedditApplication -LiteralPath 'c:\PSRAW\RedditApplication[1].xml'
```

This example uses the `LiteralPath` parameter to either override the `ExportPath` property on the `RedditApplication` object or to set export location with an `ExportPath` is not present. `LiteralPath` does not translate the special characters and instead translates them literally.

## PARAMETERS

### -Application
The `RedditApplication` object to be exported. This will be sent as the `InputObject` parameter to `Export-Clixml`.

```yaml
Type: RedditApplication
Parameter Sets: (All)
Aliases: App, RedditApplication

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Encoding
Specifies the type of encoding for the target file. The acceptable values for this parameter are:
        
- ASCII
- UTF8
- UTF7
- UTF32
- Unicode
- BigEndianUnicode
- Default
- OEM

The default value is `Unicode`.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LiteralPath
Specifies the path to the file where the XML representation of the `RedditApplication` object will be stored. Unlike `Path`, the value of the `LiteralPath` parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

```yaml
Type: String
Parameter Sets: LiteralPath
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the path to the file where the XML representation of the `RedditApplication` object will be stored.

```yaml
Type: String
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### RedditApplication

## OUTPUTS

### System.IO.FileInfo

## NOTES
For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Export-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Export-RedditApplication)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[Import-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Import-RedditApplication)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Export-Clixml](http://go.microsoft.com/fwlink/?LinkID=113297)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)