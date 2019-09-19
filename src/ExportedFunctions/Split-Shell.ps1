function Split-Shell {
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [Alias("Shell","ID","Key","GUID")]
        $Name,
        [switch]$Horizontal
    )
    begin {
        #We're going to change the default profile, note it now, restore at the end.
        $defaultProfile = (Get-MSTerminalSetting).defaultProfile
        #Save ourselves getting keybindings multiple times in the process block
        $kbHash     = @{}
        (Get-MSTerminalSetting).keybindings | ForEach-Object {$kbHash[$_.command] = $_.keys}
        #The normal way to send keys with system.windows.forms.sendkeys but this isn't available in PS Core (back in V7) so go old-school
        $wshShell = New-Object -ComObject "wscript.shell"
    }
    process {
        #get the key to send and transform notation from "Ctrl+/Alt+/Shift+" to "^/%/+"; if the key isn't found, bail out.
        if ($Horizontal)    { $SplitKey = $kbHash["splitHorizontal"] -replace "ctrl\+","^" -replace "Alt\+","%" -replace "shift\+","+" }
        else                { $SplitKey = $kbHash["splitVertical"]   -replace "ctrl\+","^" -replace "Alt\+","%" -replace "shift\+","+"
        }
        if (-not $SplitKey) {
            Write-Warning "You need to define a key for the splitHorizontal and/or splitVertical command(s) in settings."
            return
        }
        foreach ($s in $Name) {
            #figure out which shell the user meant, make it the default, send the split horizontal or split vertical key, allow things to catch up
            $p = Resolve-MSTerminalProfile  $S
            Set-MSTerminalProfile -MakeDefault -name $p.name
            Start-Sleep -Seconds 1
            $wshShell.SendKeys($SplitKey)
        }
    }
    end {
        #Restore the original default profile
        Get-MSTerminalProfile -Guid $defaultProfile| Set-MSTerminalProfile -MakeDefault
    }
}
