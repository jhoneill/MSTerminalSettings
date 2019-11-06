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
        foreach ($shell in $Name) {
            #figure out which shell the user meant, make it the default, send the split horizontal or split vertical key, allow things to catch up
                        
            $TermProfile = switch -regex ($shell) {
                #GUID
                "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}" {Get-MSTerminalProfile -Guid $shell; break}
                #Single Digit. Return the shell opened by pressing ctrl-shift-Digit. This may be the nth shell in the profile or may be customized
                #If the user has changed to (e.g.) Ctrl-alt-digit we still match.
                #If we have ctrl-alt-7 and ctrl-shift-7 both mapped to newTabProfileX we retrun the first one
                "^\d$"  {
                    $index = (Get-MSTerminalSetting).keybindings.where({$_.command -like "newTabProfile*" -and $_.keys -like "*$shell"},'First',1)
                    if (-not $index) {Write-Warning "There isn't an new tab profile command for ctrl-shift-$shell";return}
                    else  {
                        $i = $index.command -replace '^.*?(\d+)$','$1'
                        Write-Verbose "$($Index.keys) maps to $($index.command) - getting profile at postion $i "
                        Get-MSTerminalProfile | Select-Object -Index $i
                        Break 
                    }
                }
                #For anything else, assume a string which matches a name. Return only one match.
                Default {(Get-MSTerminalProfile).Where({$_.Name -Like "*$Shell*"},'First',1)}
            }    
            if ($TermProfile) {
                set-MSTerminalSetting -DefaultProfile $TermProfile.guid-ErrorAction Stop
                Start-Sleep -Seconds 1
                $wshShell.SendKeys($SplitKey,$false) 
            }
        }
    }
    end {
        #Restore the original default profile
        set-MSTerminalSetting -DefaultProfile  $defaultProfile 
    }
}
