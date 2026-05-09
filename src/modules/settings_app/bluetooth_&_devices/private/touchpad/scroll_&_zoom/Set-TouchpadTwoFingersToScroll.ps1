#=================================================================================================================
#                   Bluetooth & Devices > Touchpad > Scroll & Zoom > Drag Two Fingers To Scroll
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadTwoFingersToScroll
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadTwoFingersToScroll
{
    <#
    .EXAMPLE
        PS> Set-TouchpadTwoFingersToScroll -State 'Enabled'
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
        $TouchpadTwoFingersToScroll = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'PanEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Drag Two Fingers To Scroll' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadTwoFingersToScroll
    }
}
