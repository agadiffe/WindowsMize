#=================================================================================================================
#       Bluetooth & Devices > Touchpad > Taps > Press The Lower Right Corner Of The Touchpad To Right-Click
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadRightClickButton
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadRightClickButton
{
    <#
    .EXAMPLE
        PS> Set-TouchpadRightClickButton -State 'Enabled'
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
        $TouchpadRightClickZone = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'RightClickZoneEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Press The Lower Right Corner Of The Touchpad To Right-Click' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadRightClickZone
    }
}
