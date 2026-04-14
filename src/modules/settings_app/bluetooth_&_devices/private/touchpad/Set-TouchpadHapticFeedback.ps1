#=================================================================================================================
#                                  Bluetooth & Devices > Touchpad > Haptic Click
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadHapticFeedback
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadHapticFeedback
{
    <#
    .EXAMPLE
        PS> Set-TouchpadHapticFeedback -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 4294967295 (UINT_MAX) (default) | off: 0
        $TouchpadHapticFeedback = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FeedbackEnabled'
                    Value = $State -eq 'Enabled' ? [uint]::MaxValue : 0
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Haptic Click' to '$State' ..."
        Set-RegistryEntry -InputObject $TouchpadHapticFeedback
    }
}
