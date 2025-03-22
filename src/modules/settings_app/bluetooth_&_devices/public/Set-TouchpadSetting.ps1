#=================================================================================================================
#                                    Bluetooth & Devices > Touchpad - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSetting
        [-Touchpad {Disabled | Enabled}]
        [-LeaveOnWithMouse {Disabled | Enabled}]
        [-CursorSpeed <int>]
        [-Sensitivity {Max | High | Medium | Low}]
        [-TapToClick {Disabled | Enabled}]
        [-TwoFingersTapToRightClick {Disabled | Enabled}]
        [-TapTwiceAndDragToMultiSelect {Disabled | Enabled}]
        [-RightClickButton {Disabled | Enabled}]
        [-TwoFingersToScroll {Disabled | Enabled}]
        [-ScrollingDirection {DownMotionScrollsDown | DownMotionScrollsUp}]
        [-PinchToZoom {Disabled | Enabled}]
        [-ThreeFingersTap {Nothing | OpenSearch | NotificationCenter | PlayPause |
                           MiddleMouseButton | MouseBackButton | MouseForwardButton}]
        [-ThreeFingersSwipes {Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop |
                              ChangeAudioAndVolume | Custom}]
        [-ThreeFingersUp {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
                          CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
                          SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
                          NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}]
        [-ThreeFingersDown { same as ThreeFingersUp }]
        [-ThreeFingersLeft { same as ThreeFingersUp }]
        [-ThreeFingersRight { same as ThreeFingersUp }]
        [-FourFingersTap { same as ThreeFingersTap }]
        [-FourFingersSwipes { same as ThreeFingersSwipes }]
        [-FourFingersUp { same as ThreeFingersUp }]
        [-FourFingersDown { same as ThreeFingersUp }]
        [-FourFingersLeft { same as ThreeFingersUp }]
        [-FourFingersRight { same as ThreeFingersUp }]
        [<CommonParameters>]
#>

function Set-TouchpadSetting
{
    <#
    .DESCRIPTION
        Dynamic parameters: available when 'ThreeFingersSwipes' or 'FourFingersSwipes' are defined to 'Custom'.
            -ThreeFingersUp, -ThreeFingersDown, -ThreeFingersLeft, -ThreeFingersRight
            -FourFingersUp, -FourFingersDown, -FourFingersLeft, -FourFingersRight
        Accepted values: {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
                          CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
                          SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
                          NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}

    .EXAMPLE
        PS> Set-TouchpadSetting -LeaveOnWithMouse 'Disabled' -ScrollingDirection 'DownMotionScrollsUp'

    .EXAMPLE
        PS> Set-TouchpadSetting -FourFingersSwipes 'Custom' -FourFingersUp 'MaximizeWindow' -FourFingersDown 'MinimizeWindow'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # touchpad
        [state] $Touchpad,

        [state] $LeaveOnWithMouse,

        [ValidateRange(1, 10)]
        [int] $CursorSpeed,

        # taps
        [TouchpadSensitivityMode] $Sensitivity,

        [state] $TapToClick,

        [state] $TwoFingersTapToRightClick,

        [state] $TapTwiceAndDragToMultiSelect,

        [state] $RightClickButton,

        # scroll & zoom
        [state] $TwoFingersToScroll,

        [ScrollingDirectionMode] $ScrollingDirection,

        [state] $PinchToZoom,

        # gestures
        [TouchpadTapMode] $ThreeFingersTap,

        [TouchpadSwipesMode] $ThreeFingersSwipes,

        [TouchpadTapMode] $FourFingersTap,

        [TouchpadSwipesMode] $FourFingersSwipes
    )

    dynamicparam
    {
        if ($ThreeFingersSwipes -eq 'Custom' -or $FourFingersSwipes -eq 'Custom')
        {
            $DynamicParameters = @()
            if ($ThreeFingersSwipes -eq 'Custom')
            {
                $DynamicParameters += 'ThreeFingersUp', 'ThreeFingersDown', 'ThreeFingersLeft', 'ThreeFingersRight'
            }
            if ($FourFingersSwipes -eq 'Custom')
            {
                $DynamicParameters += 'FourFingersUp', 'FourFingersDown', 'FourFingersLeft', 'FourFingersRight'
            }

            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynamicParameters | ForEach-Object -Process {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = $_
                    Type       = [TouchpadSwipesCustomMode]
                }
                Add-DynamicParameter @DynamicParamProperties
            }
            $ParamDictionary
        }
    }

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'Touchpad'                     { Set-Touchpad -State $Touchpad }
            'LeaveOnWithMouse'             { Set-TouchpadLeaveOnWithMouse -State $LeaveOnWithMouse }
            'CursorSpeed'                  { Set-TouchpadCursorSpeed -Value $CursorSpeed }

            'Sensitivity'                  { Set-TouchpadSensitivity -Value $Sensitivity }
            'TapToClick'                   { Set-TouchpadSingleFingerTapToClick -State $TapToClick }
            'TwoFingersTapToRightClick'    { Set-TouchpadTwoFingersTapToRightClick -State $TwoFingersTapToRightClick }
            'TapTwiceAndDragToMultiSelect' { Set-TouchpadTapTwiceAndDragToMultiSelect -State $TapTwiceAndDragToMultiSelect }
            'RightClickButton'             { Set-TouchpadRightClickButton -State $RightClickButton }

            'TwoFingersToScroll'           { Set-TouchpadTwoFingersToScroll -State $TwoFingersToScroll }
            'ScrollingDirection'           { Set-TouchpadScrollingDirection -Value $ScrollingDirection }
            'PinchToZoom'                  { Set-TouchpadPinchToZoom -State $PinchToZoom }

            'ThreeFingersTap'              { Set-TouchpadGesturesThreeFingersTap -Value $ThreeFingersTap }
            'ThreeFingersSwipes'
            {
                $HashtableSubsetParam = @{
                    Source            = $PSBoundParameters
                    DesiredKeys       = 'ThreeFingersUp', 'ThreeFingersDown', 'ThreeFingersLeft', 'ThreeFingersRight'
                    SubStringToRemove = 'ThreeFingers'
                }
                $ThreeFingersParam = Get-HashtableSubset @HashtableSubsetParam
                Set-TouchpadGesturesThreeFingersSwipes -Value $ThreeFingersSwipes @ThreeFingersParam
            }
            'FourFingersTap'               { Set-TouchpadGesturesFourFingersTap -Value $FourFingersTap }
            'FourFingersSwipes'
            {
                $HashtableSubsetParam = @{
                    Source            = $PSBoundParameters
                    DesiredKeys       = 'FourFingersUp', 'FourFingersDown', 'FourFingersLeft', 'FourFingersRight'
                    SubStringToRemove = 'FourFingers'
                }
                $FourFingersParam = Get-HashtableSubset @HashtableSubsetParam
                Set-TouchpadGesturesFourFingersSwipes -Value $FourFingersSwipes @FourFingersParam
            }
        }
    }
}
