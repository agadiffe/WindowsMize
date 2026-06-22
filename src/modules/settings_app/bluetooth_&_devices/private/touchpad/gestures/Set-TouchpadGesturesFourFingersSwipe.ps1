#=================================================================================================================
#                         Bluetooth & Devices > Touchpad > Four-Finger Gestures > Swipes
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesFourFingersSwipe
        [-Mode] {Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop | ChangeAudioAndVolume | Custom}
        [-Up {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
              CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
              SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
              NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}]
        [-Down { same as Up }]
        [-Left { same as Up }]
        [-Right { same as Up }]
        [<CommonParameters>]
#>

function Set-TouchpadGesturesFourFingersSwipe
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesFourFingersSwipe -Mode 'SwitchAppsAndShowDesktop'

    .EXAMPLE
        PS> Set-TouchpadGesturesFourFingersSwipe -Mode 'Custom' -Up 'MaximizeWindow' -Down 'MinimizeWindow'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [TouchpadSwipesMode] $Mode,

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
        $TouchpadFourFingersSwipe = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FourFingerSlideEnabled'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Four-Finger Gestures Swipes' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TouchpadFourFingersSwipe


        $PSBoundParameters.Remove('Mode') | Out-Null
        if ($PSBoundParameters.Keys.Count)
        {
            Set-TouchpadGesturesAdvancedFingersSwipes -Name 'FourFinger' @PSBoundParameters
        }
    }
}
