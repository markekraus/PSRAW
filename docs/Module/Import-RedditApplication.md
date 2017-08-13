---
external help file: PSRAW-help.xml
Module Name: psraw
online version: https://psraw.readthedocs.io/en/latest/Module/Import-RedditApplication
schema: 2.0.0
---

# Import-RedditApplication

## SYNOPSIS
Imports a `RedditApplication` object from an XML file.

## SYNTAX

### Path (Default)
```
Import-RedditApplication -Path <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### LiteralPath
```
Import-RedditApplication -LiteralPath <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Allows you to import a `RedditApplication` object from an XML file that was previously exported via `Export-RedditApplication`. This allows you to share the same Reddit application between multiple scripts. This function is a wrapper for `Import-Clixml`. 

User Passwords and Client Secrets stored in the `RedditApplication` object are stored as secure strings and are not visible as plaintext in the export file. This also means that a `RedditApplication` object exported by one user cannot be imported by another user on the same computer nor can it be imported by the same user on a different computer. It can only be imported by the same user on the same computer.

The maximum depth will be set on `Export-Clixml`.

New `RedditApplication` objects can be created manually or with `New-RedditApplication`.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Application = Import-RedditApplication -Path 'c:\PSRAW\RedditApplication.xml'
```

### -------------------------- EXAMPLE 3 --------------------------
```
$Application = Import-RedditApplication -LiteralPath 'c:\PSRAW\RedditApplication[1].xml'
```

## PARAMETERS

### -LiteralPath
Specifies the XML files. Unlike `Path`, the value of the `LiteralPath` parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Specifies the XML files.

```yaml
Type: String[]
Parameter Sets: Path
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.String[]

## OUTPUTS

### RedditApplication

## NOTES
For complete documentation visit [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

For more information about registering Reddit Apps, Reddit's API, or Reddit OAuth see:

* [https://github.com/reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API)
* [https://github.com/reddit/reddit/wiki/OAuth2](https://github.com/reddit/reddit/wiki/OAuth2)
* [https://www.reddit.com/prefs/apps](https://www.reddit.com/prefs/apps)
* [https://www.reddit.com/wiki/api](https://www.reddit.com/wiki/api)

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Import-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Import-RedditApplication)

[about_RedditApplication](https://psraw.readthedocs.io/en/latest/Module/about_RedditApplication)

[Export-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/Export-RedditApplication)

[New-RedditApplication](https://psraw.readthedocs.io/en/latest/Module/New-RedditApplication)

[Import-Clixml](http://go.microsoft.com/fwlink/?LinkID=113340)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)