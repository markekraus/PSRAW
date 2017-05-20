---
external help file: PSRAW-help.xml
online version: https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest
schema: 2.0.0
---

# Invoke-RedditRequest

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Invoke-RedditRequest [-AccessToken] <RedditOAuthToken> [-Uri] <Uri> [[-Method] <WebRequestMethod>]
 [[-Body] <Object>] [[-Headers] <IDictionary>] [[-TimeoutSec] <Int32>] [[-ContentType] <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
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

### -AccessToken
{{Fill AccessToken Description}}

```yaml
Type: RedditOAuthToken
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Body
{{Fill Body Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ContentType
{{Fill ContentType Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Headers
{{Fill Headers Description}}

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Method
{{Fill Method Description}}

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases: 
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TimeoutSec
{{Fill TimeoutSec Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Uri
{{Fill Uri Description}}

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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
Microsoft.PowerShell.Commands.WebRequestMethod
System.Object
System.Collections.IDictionary
System.Int32
System.String

## OUTPUTS

### RedditApiResponse

## NOTES

## RELATED LINKS

[https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest](https://psraw.readthedocs.io/en/latest/Module/Invoke-RedditRequest)

