#=================================================================================================================
#                  Bluetooth & Devices > Touchpad > Leave Touchpad On When A Mouse Is Connected
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadLeaveOnWithMouse
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadLeaveOnWithMouse
{
    <#
    .EXAMPLE
        PS> Set-TouchpadLeaveOnWithMouse -State 'Enabled'
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
        $TouchpadLeaveOnWithMouse = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'LeaveOnWithMouse'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Leave Touchpad On When A Mouse Is Connected' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadLeaveOnWithMouse
    }
}
