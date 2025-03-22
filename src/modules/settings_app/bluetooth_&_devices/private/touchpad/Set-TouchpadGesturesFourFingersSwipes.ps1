#=================================================================================================================
#                         Bluetooth & Devices > Touchpad > Four-Finger Gestures > Swipes
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesFourFingersSwipes
        [-Value] {Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop | ChangeAudioAndVolume | Custom}
        [-Up {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
              CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
              SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
              NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}]
        [-Down { same as Up }]
        [-Left { same as Up }]
        [-Right { same as Up }]
        [<CommonParameters>]
#>

function Set-TouchpadGesturesFourFingersSwipes
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesFourFingersSwipes -Value 'SwitchAppsAndShowDesktop'

    .EXAMPLE
        PS> Set-TouchpadGesturesFourFingersSwipes -Value 'Custom' -Up 'MaximizeWindow' -Down 'MinimizeWindow'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [TouchpadSwipesMode] $Value,

        [TouchpadSwipesCustomMode] $Up,

        [TouchpadSwipesCustomMode] $Down,

        [TouchpadSwipesCustomMode] $Left,

        [TouchpadSwipesCustomMode] $Right
    )

    process
    {
        # FourFingerSlideEnabled\
        #   nothing: 0 | switch apps and show desktop: 1 (default) | switch desktops and show desktop: 2
        #   change audio and volume: 3 | custom: 65535 (hex: ffff)
        $TouchpadFourFingersSwipes = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FourFingerSlideEnabled'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Four-Finger Gestures Swipes' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadFourFingersSwipes


        $PSBoundParameters.Remove('Value') | Out-Null
        if ($PSBoundParameters.Keys.Count)
        {
            Set-TouchpadGesturesAdvancedFingersSwipes -Name 'FourFinger' @PSBoundParameters
        }
    }
}
