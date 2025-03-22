#=================================================================================================================
#                Bluetooth & Devices > Touchpad > Taps > Tap With A Single Finger To Single-Click
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSingleFingerTapToClick
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadSingleFingerTapToClick
{
    <#
    .EXAMPLE
        PS> Set-TouchpadSingleFingerTapToClick -State 'Enabled'
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
        $TouchpadSingleFingerToClick = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'TapsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Tap With A Single Finger To Single-Click' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadSingleFingerToClick
    }
}
