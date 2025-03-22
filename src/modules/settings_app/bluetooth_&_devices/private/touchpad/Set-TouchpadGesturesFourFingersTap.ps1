#=================================================================================================================
#                           Bluetooth & Devices > Touchpad > Four-Finger Gestures > Tap
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesFourFingersTap
        [-Value] {Nothing | OpenSearch | NotificationCenter | PlayPause |
                  MiddleMouseButton | MouseBackButton | MouseForwardButton}
        [<CommonParameters>]
#>

function Set-TouchpadGesturesFourFingersTap
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesFourFingersTap -Value 'OpenSearch'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadTapMode] $Value
    )

    process
    {
        # FourFingerTapEnabled\
        #   nothing: 0 | open search: 1 | notification center: 2 (default)
        #   play/pause: 3 | middle mouse button: 4 | custom: 65535 (hex: ffff)
        #
        # CustomFourFingerTap\ ignored if 'FourFingerTapEnabled' is NOT set to 'custom'
        #   mouse back button: 5 | mouse forward button: 6
        $TouchpadThreeFingersTap = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FourFingerTapEnabled'
                    Value = @('MouseBackButton', 'MouseForwardButton') -contains $Value ? 65535 : [int]$Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'CustomFourFingerTap'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Three-Finger Gestures Taps' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadThreeFingersTap
    }
}
