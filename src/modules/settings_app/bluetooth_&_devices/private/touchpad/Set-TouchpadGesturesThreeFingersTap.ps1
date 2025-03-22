#=================================================================================================================
#                          Bluetooth & Devices > Touchpad > Three-Finger Gestures > Tap
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesThreeFingersTap
        [-Value] {Nothing | OpenSearch | NotificationCenter | PlayPause |
                  MiddleMouseButton | MouseBackButton | MouseForwardButton}
        [<CommonParameters>]
#>

function Set-TouchpadGesturesThreeFingersTap
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesThreeFingersTap -Value 'OpenSearch'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadTapMode] $Value
    )

    process
    {
        # ThreeFingerTapEnabled\
        #   nothing: 0 | open search: 1 (default) | notification center: 2
        #   play/pause: 3 | middle mouse button: 4 | custom: 65535 (hex: ffff)
        #
        # CustomThreeFingerTap\ ignored if 'ThreeFingerTapEnabled' is NOT set to 'custom'
        #   mouse back button: 5 | mouse forward button: 6
        $TouchpadThreeFingersTap = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ThreeFingerTapEnabled'
                    Value = @('MouseBackButton', 'MouseForwardButton') -contains $Value ? 65535 : [int]$Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'CustomThreeFingerTap'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Three-Finger Gestures Taps' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadThreeFingersTap
    }
}
