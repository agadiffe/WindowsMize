#=================================================================================================================
#                                             Character Map Shortcut
#=================================================================================================================

# After running the script, the 'character map' shortcut (all apps > windows tools) is shown in the Start Menu.
# Probably a Windows bug, as it is not visible in the Start Menu on a fresh install.

# Let's move this shortcut to the 'Windows Tools' folder.
# 'sfc /scannow' will show an error and bring back the 'character map' shortcut in the Start Menu ...

<#
.SYNTAX
    Move-CharacterMapShortcutToWindowsTools [<CommonParameters>]
#>

function Move-CharacterMapShortcutToWindowsTools
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message "Moving 'Character Map Shortcut' To 'Windows Tools Folder' ..."

        $ShortcutFilePath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk"
        $WindowsToolsPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools"
        Move-Item -Path $ShortcutFilePath -Destination $WindowsToolsPath -ErrorAction 'SilentlyContinue'
    }
}
