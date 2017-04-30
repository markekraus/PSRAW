---
external help file: PSRAW-help.xml
online version: https://github.com/markekraus/ConnectReddit/wiki/Export%E2%80%90RedditApplication
schema: 2.0.0
---

# Export-RedditApplication

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### ExportPath (Default)
```
Export-RedditApplication [-Encoding <String>] -Application <RedditApplication> [-WhatIf] [-Confirm]
```

### Path
```
Export-RedditApplication -Path <String> [-Encoding <String>] -Application <RedditApplication> [-WhatIf]
 [-Confirm]
```

### LiteralPath
```
Export-RedditApplication -LiteralPath <String> [-Encoding <String>] -Application <RedditApplication> [-WhatIf]
 [-Confirm]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Application
{{Fill Application Description}}

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
{{Fill Encoding Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ASCII, UTF8, UTF7, UTF32, Unicode, BigEndianUnicode, Default, OEM

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LiteralPath
{{Fill LiteralPath Description}}

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
{{Fill Path Description}}

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

## INPUTS

### System.String
RedditApplication


## OUTPUTS

### System.IO.FileInfo


## NOTES

## RELATED LINKS

[https://github.com/markekraus/ConnectReddit/wiki/Export%E2%80%90RedditApplication](https://github.com/markekraus/ConnectReddit/wiki/Export%E2%80%90RedditApplication)

