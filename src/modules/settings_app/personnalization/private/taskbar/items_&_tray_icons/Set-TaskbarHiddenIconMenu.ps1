#=================================================================================================================
#                     Personnalization > Taskbar > Other System Tray Icons > Hidden Icon Menu
#=================================================================================================================

# If disabled, don't forget to manually turn on icons you want to be visible.

<#
.SYNTAX
    Set-TaskbarHiddenIconMenu
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarHiddenIconMenu
{
    <#
    .EXAMPLE
        PS> Set-TaskbarHiddenIconMenu -State 'Disabled'
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
        $TaskbarTrayIconsHiddenMenu = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify'
            Entries = @(
                @{
                    Name  = 'SystemTrayChevronVisibility'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Tray Icons - Hidden Icon Menu' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarTrayIconsHiddenMenu
    }
}
