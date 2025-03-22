#=================================================================================================================
#                  Bluetooth & Devices > Mouse > Scroll Inactive Windows When Hovering Over Them
#=================================================================================================================

<#
.SYNTAX
    Set-MouseScrollInactiveWindowsOnHover
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseScrollInactiveWindowsOnHover
{
    <#
    .EXAMPLE
        PS> Set-MouseScrollInactiveWindowsOnHover -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 2 (default) | off: 0
        $MouseScrollInactiveWindowsOnHover = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'MouseWheelRouting'
                    Value = $State -eq 'Enabled' ? '2' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Scroll Inactive Windows When Hovering Over Them' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseScrollInactiveWindowsOnHover
    }
}
