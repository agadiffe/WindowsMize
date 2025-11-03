#=================================================================================================================
#                        Personnalization > Taskbar > System Tray Icons > Virtual Touchpad
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarVirtualTouchpad
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarVirtualTouchpad
{
    <#
    .EXAMPLE
        PS> Set-TaskbarVirtualTouchpad -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $TaskbarTrayIconsVirtualTouchpad = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Touchpad'
            Entries = @(
                @{
                    Name  = 'TouchpadDesiredVisibility'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Tray Icons - Virtual Touchpad' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarTrayIconsVirtualTouchpad
    }
}
