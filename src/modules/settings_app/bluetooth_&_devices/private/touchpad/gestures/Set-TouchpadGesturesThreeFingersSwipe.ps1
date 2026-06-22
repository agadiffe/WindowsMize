#=================================================================================================================
#                         Bluetooth & Devices > Touchpad > Three-Finger Gestures > Swipes
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesThreeFingersSwipe
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

function Set-TouchpadGesturesThreeFingersSwipe
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesThreeFingersSwipe -Mode 'SwitchAppsAndShowDesktop'

    .EXAMPLE
        PS> Set-TouchpadGesturesThreeFingersSwipe -Mode 'Custom' -Up 'MaximizeWindow' -Down 'MinimizeWindow'
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
        # ThreeFingerSlideEnabled\
        #   nothing: 0 | switch apps and show desktop: 1 (default) | switch desktops and show desktop: 2
        #   change audio and volume: 3 | custom: 65535 (hex: ffff)
        $TouchpadThreeFingersSwipe = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ThreeFingerSlideEnabled'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Three-Finger Gestures Swipes' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TouchpadThreeFingersSwipe


        $PSBoundParameters.Remove('Mode') | Out-Null
        if ($PSBoundParameters.Keys.Count)
        {
            Set-TouchpadGesturesAdvancedFingersSwipes -Name 'ThreeFinger' @PSBoundParameters
        }
    }
}
