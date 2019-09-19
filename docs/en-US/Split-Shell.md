---
external help file: MSTerminalSettings-help.xml
Module Name: MSTerminalSettings
online version:
schema: 2.0.0
---

# Split-Shell

## SYNOPSIS
Splits the Terminal window horizontally or vertically and starts the chosen shell.

## SYNTAX

```
Split-Shell [-Name] <Object> [-Horizontal] [<CommonParameters>]
```

## DESCRIPTION
Windows terminal supports command keys to split and existing pane in two horizontally or vertically, and
to resize a pane, up, down, left or right. As of V0.4.2382 resize is not available from a mouse action, and
splitting only launches the default shell. Split-Shell changes the default shell, sends the Split keystroke
and restores the default.

## EXAMPLES

### Example 1
```powershell
PS C:\>  Split-Shell "Windows PowerShell 5.1"
```

Splits the current pane vertically, and starts the profile 'Windows PowerShell 5.1' in the new tab.
### Example 2
```powershell
PS C:\> Split-Shell ubuntu -Horizontal
```
Splits the current pane Horizontally, and starts the first profile which matches "ubuntu" in the new tab,
if there a profiles named "Bash on Ubuntu-18.04" and "Pwsh on Ubuntu-18.04" the first one found will be started.

### Example 2
```powershell
PS C:\> Split-Shell 7
```
Splits the current pane vertically
Here the terminal is configured so the Ctrl+Shift+5 starts Windows PowerShell 5,
Ctrl+Shift+6 starts Windows PowerShell core 6; and Ctrl+Shift+7 starts PowerShell 7;
A single digit looks at key bindings which end in a digit, and launch a new shell,
so this will find PowerShell 7's profile and launch it.

## PARAMETERS

### -Horizontal
If specified, the terminal window will be split horizonally - the default is a vertical split

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The shell(s) to open by name, guid or shortcut key digit.


```yaml
Type: Object
Parameter Sets: (All)
Aliases: Shell, ID Key,GUID

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
