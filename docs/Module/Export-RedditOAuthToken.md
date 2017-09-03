---
external help file: PSRAW-help.xml
Module Name: PSRAW
online version: https://psraw.readthedocs.io/en/latest/Module/Export-RedditOAuthToken
schema: 2.0.0
---

# Export-RedditOAuthToken

## SYNOPSIS
Exports a `RedditOAuthToken` object to an XML file.

## SYNTAX

### ExportPath (Default)
```
Export-RedditOAuthToken [-Encoding <String>] [-AccessToken <RedditOAuthToken>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Path
```
Export-RedditOAuthToken -Path <String> [-Encoding <String>] [-AccessToken <RedditOAuthToken>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### LiteralPath
```
Export-RedditOAuthToken -LiteralPath <String> [-Encoding <String>] [-AccessToken <RedditOAuthToken>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Allows you to export a `RedditOAuthToken` object to an XML file so that you can later import the object via `Import-RedditOAuthToken`. This allows you to share the same Reddit application between multiple scripts. This function is a wrapper for `Export-Clixml`. 

User Password, Client Secret, Access Token, and Refresh Token stored in the `RedditOAuthToken` object are stored as secure strings and are not visible as plaintext in the export file. This also means that a `RedditOAuthToken` object exported by one user cannot be imported by another user on the same computer nor can it be imported by the same user on a different computer. It can only be imported by the same user on the same computer.

The maximum depth will be set on `Export-Clixml`.

New `RedditOAuthToken` objects can be created manually or with `Request-RedditOAuthToken`.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Token.ExportPath = 'c:\PSRAW\RedditOAuthToken.xml'
$Token | Export-RedditOAuthToken
```

This example uses the `ExportPath` property on the `RedditOAuthToken` object to determine where to export the application. When a `RedditOAuthToken` object is imported with `Import-RedditOAuthToken`, the `ExportPath` of the object will be set with the path to the file it was imported from. This makes it easy to import, make changes, and then re-export the application. The `ExportPath` property is treated as a `LiteralPath`.

### -------------------------- EXAMPLE 2 --------------------------
```
$Token | Export-RedditOAuthToken -Path 'c:\PSRAW\RedditOAuthToken.xml'
```

This example uses the `Path` parameter to either override the `ExportPath` property on the `RedditOAuthToken` object or to set export location when an `ExportPath` is not present.

### -------------------------- EXAMPLE 3 --------------------------
```
$Token | Export-RedditOAuthToken -LiteralPath 'c:\PSRAW\RedditOAuthToken[1].xml'
```

This example uses the `LiteralPath` parameter to either override the `ExportPath` property on the `RedditOAuthToken` object or to set export location with an `ExportPath` is not present. `LiteralPath` does not translate the special characters and instead translates them literally.

## PARAMETERS

### -AccessToken
The `RedditOAuthToken` object to be exported. This will be sent as the `InputObject` parameter to `Export-Clixml`.

```yaml
Type: RedditOAuthToken
Parameter Sets: (All)
Aliases: Token

Required: False
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
Default value: Unicode
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LiteralPath
Specifies the path to the file where the XML representation of the `RedditOAuthToken` object will be stored. Unlike `Path`, the value of the `LiteralPath` parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

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
Specifies the path to the file where the XML representation of the `RedditOAuthToken` object will be stored.

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

### RedditOAuthToken

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

[https://psraw.readthedocs.io/en/latest/Module/Export-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Export-RedditOAuthToken)

[about_RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/about_RedditOAuthToken)

[Import-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Import-RedditOAuthToken)

[Request-RedditOAuthToken](https://psraw.readthedocs.io/en/latest/Module/Request-RedditOAuthToken)

[Export-Clixml](http://go.microsoft.com/fwlink/?LinkID=113297)

[https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)