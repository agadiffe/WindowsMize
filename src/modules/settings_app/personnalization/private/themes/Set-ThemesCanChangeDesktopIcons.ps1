#=================================================================================================================
#            Personnalization > Themes > Desktop Icon Settings > Allow Themes To Change Desktop Icons
#=================================================================================================================

<#
.SYNTAX
    Set-ThemesCanChangeDesktopIcons
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ThemesCanChangeDesktopIcons
{
    <#
    .EXAMPLE
        PS> Set-ThemesCanChangeDesktopIcons -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $ThemesChangeDesktopIcons = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes'
            Entries = @(
                @{
                    Name  = 'ThemeChangesDesktopIcons'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Themes - Allow Themes To Change Desktop Icons' to '$State' ..."
        Set-RegistryEntry -InputObject $ThemesChangeDesktopIcons
    }
}
