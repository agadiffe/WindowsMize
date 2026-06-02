#=================================================================================================================
#                        Personnalization > Themes > Desktop Icon Settings > Desktop Icons
#=================================================================================================================

<#
.SYNTAX
    Set-ThemesDesktopIcons
        [-Icon] {ThisPC | UserFiles | Network | RecycleBin | ControlPanel}
        [<CommonParameters>]
#>

function Set-ThemesDesktopIcons
{
    <#
    .EXAMPLE
        PS> Set-ThemesDesktopIcons -Icon 'ThisPC', 'Network'

    .EXAMPLE
        PS> Set-ThemesDesktopIcons -Icon $null

    .EXAMPLE
        PS> Set-ThemesDesktopIcons -Icon @()
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [DesktopIcons[]] $Icon
    )

    process
    {
        $DesktopIconGuid = @{
            ThisPC       = '{20d04fe0-3aea-1069-a2d8-08002b30309d}'
            UserFiles    = '{59031a47-3f72-44a7-89c5-5595fe6b30ee}'
            Network      = '{f02c1a0d-be21-4350-88b0-7367fc96ef3c}'
            RecycleBin   = '{645ff040-5081-101b-9f08-00aa002f954e}'
            ControlPanel = '{5399e694-6cE5-4d6c-8fce-1d8870fdcba0}'
        }

        # on: 0 | off: 1
        $ThemesDesktopIcons = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
                Entries = [System.Collections.ArrayList]::new()
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
                Entries = $null
            }
        )

        foreach ($Key in $DesktopIconGuid.Keys)
        {
            $DesktopIcon = @{
                Name  = $DesktopIconGuid[$Key]
                Value = $Icon -contains $Key ? '0' : '1'
                Type  = 'DWord'
            }
            $ThemesDesktopIcons[0]['Entries'].Add($DesktopIcon) | Out-Null
        }
        $ThemesDesktopIcons[1]['Entries'] = $ThemesDesktopIcons[0]['Entries']

        $DesktopIconsShown = $Icon ? ($Icon | Join-String -Separator ', ') : 'HideAll'

        Write-Verbose -Message "Setting 'Themes - Desktop Icons' to '$DesktopIconsShown' ..."
        $ThemesDesktopIcons | Set-RegistryEntry
    }
}
