function Resolve-MSTerminalProfile {
    <#
    .synopsis
        Returns a single Shell Profile.
    #>
    param (
        #A shell profile by name, Guid or number used with ctrl-shift to open it.
        $P
    )
    switch -regex ($P) {
        #GUID
        "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}" {return (Get-MSTerminalProfile -Guid $P)}
        #Single Digit. Return the shell opened by pressing ctrl-shift-Digit. This may be the nth shell in the profile or may be customized
        #If the user has changed to (e.g.) Ctrl-alt-digit we still match.
        #If we have ctrl-alt-7 and ctrl-shift-7 both mapped to newTabProfileX we retrun the first one
        "^\d$"  {
            $index = (Get-MSTerminalSetting).keybindings.where({$_.command -like "newTabProfile*" -and $_.keys -like "*$P"},'First',1)
            if (-not $index) {Write-Warning "There isn't an new tab profile command for ctrl-shift-$P"}
            else  {
                $i = $index.command -replace '^.*?(\d+)$','$1'
                Write-Verbose "$($Index.keys) maps to $($index.command) - getting profile at postion $i "
                return (Get-MSTerminalProfile | Select-Object -Index $i)
            }
        }
        #For anything else, assume a string which matches a name. Return only one match.
        Default {(Get-MSTerminalProfile).Where({$_.Name -Like "*$P*"},'First',1)}
    }
}
