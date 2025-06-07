#=================================================================================================================
#                           Bluetooth & Devices > Touchpad > Advanced Gestures > Swipes
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadGesturesAdvancedFingersSwipes
        [-Name] {ThreeFinger | FourFinger}
        [-Up {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
              CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
              SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
              NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}]
        [-Down { same as Up }]
        [-Left { same as Up }]
        [-Right { same as Up }]
        [<CommonParameters>]
#>

function Set-TouchpadGesturesAdvancedFingersSwipes
{
    <#
    .EXAMPLE
        PS> Set-TouchpadGesturesAdvancedFingersSwipes -Name 'ThreeFinger' -Up 'MaximizeWindow' -Down 'MinimizeWindow'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('ThreeFinger', 'FourFinger')]
        [string] $Name,

        [TouchpadSwipesCustomMode] $Up,

        [TouchpadSwipesCustomMode] $Down,

        [TouchpadSwipesCustomMode] $Left,

        [TouchpadSwipesCustomMode] $Right
    )

    process
    {
        $FingerMode = $Name
        $PSBoundParameters.Remove('Name') | Out-Null

        foreach ($Key in $PSBoundParameters.Keys)
        {
            # Three/Four Finger Up/Down/Left/Right\ ignored if 'Three/Four FingerSlideEnabled' is NOT set to 'custom'
            #   nothing: 0 | switch apps: 1 | task view: 2 | show desktop: 3 | switch desktops: 4
            #   hide everything other than the app in focus: 5 | create desktop: 6 | remove desktop: 7
            #   forward navigation: 8 | backward navigation: 9 | snap window to the left: 10 | snap window to the right: 12
            #   maximize a window: 11 | minimize a window: 13 | next track: 14 | previous track: 15
            #   volume up: 16 | volume down: 17 | mute: 18
            $TouchpadThreeFingersSwipesCustom = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
                Entries = @(
                    @{
                        Name  = "$FingerMode$Key"
                        Value = [int]$PSBoundParameters.$Key
                        Type  = 'DWord'
                    }
                )
            }

            Write-Verbose -Message "Setting 'Touchpad - $FingerMode Gestures Swipes: $Key' to '$($PSBoundParameters.$Key)' ..."
            Set-RegistryEntry -InputObject $TouchpadThreeFingersSwipesCustom
        }
    }
}
