#=================================================================================================================
#                         Bluetooth & Devices > Touchpad > Three-Finger Gestures > Taps
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesThreeFingersTap
        [-Mode] {Nothing | OpenSearch | NotificationCenter | PlayPause |
                 MiddleMouseButton | MouseBackButton | MouseForwardButton}
        [<CommonParameters>]
#>

function Set-TouchpadGesturesThreeFingersTap
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesThreeFingersTap -Mode 'OpenSearch'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadTapMode] $Mode
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
                    Value = @('MouseBackButton', 'MouseForwardButton') -contains $Mode ? 65535 : [int]$Mode
                    Type  = 'DWord'
                }
                @{
                    Name  = 'CustomThreeFingerTap'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Three-Finger Gestures Taps' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TouchpadThreeFingersTap
    }
}
