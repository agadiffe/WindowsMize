#=================================================================================================================
#                   Bluetooth & Devices > Touchpad > Taps > Tap With Two Fingers To Right-Click
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadTwoFingersTapToRightClick
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadTwoFingersTapToRightClick
{
    <#
    .EXAMPLE
        PS> Set-TouchpadTwoFingersTapToRightClick -State 'Enabled'
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
        $TouchpadTwoFingersTapToRightClick = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'TwoFingerTapEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Tap With Two Fingers To Right-Click' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadTwoFingersTapToRightClick
    }
}
