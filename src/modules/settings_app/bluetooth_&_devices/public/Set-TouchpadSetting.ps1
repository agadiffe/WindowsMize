#=================================================================================================================
#                                    Bluetooth & Devices > Touchpad - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSetting
        [-Touchpad {Disabled | Enabled}]
        [-LeaveOnWithMouse {Disabled | Enabled}]
        [-CursorSpeed <int>]
        [-ClickSensitivity {Light | Medium | Heavy}]
        [-HapticFeedback {Disabled | Enabled}]
        [-HapticFeedbackIntensity <int>]
        [-Sensitivity {Max | High | Medium | Low}]
        [-TapToClick {Disabled | Enabled}]
        [-TwoFingersTapToRightClick {Disabled | Enabled}]
        [-TapTwiceAndDragToMultiSelect {Disabled | Enabled}]
        [-RightClickButton {Disabled | Enabled}]
        [-RightClickZoneSize {Default | Small | Medium | Large}]
        [-TwoFingersToScroll {Disabled | Enabled}]
        [-ScrollingDirection {DownMotionScrollsDown | DownMotionScrollsUp}]
        [-PinchToZoom {Disabled | Enabled}]
        [-ThreeFingersTap {Nothing | OpenSearch | NotificationCenter | PlayPause |
                           MiddleMouseButton | MouseBackButton | MouseForwardButton}]
        [-ThreeFingersSwipe {Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop |
                             ChangeAudioAndVolume | Custom}]
        [-ThreeFingersUp {Nothing | SwitchApps | TaskView | ShowDesktop | SwitchDesktops | HideAllExceptAppInFocus |
                          CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation |
                          SnapWindowToLeft | SnapWindowToRight | MaximizeWindow | MinimizeWindow |
                          NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute}]
        [-ThreeFingersDown { same as ThreeFingersUp }]
        [-ThreeFingersLeft { same as ThreeFingersUp }]
        [-ThreeFingersRight { same as ThreeFingersUp }]
        [-FourFingersTap { same as ThreeFingersTap }]
        [-FourFingersSwipe { same as ThreeFingersSwipes }]
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
        PS> Set-TouchpadSetting -FourFingersSwipe 'Custom' -FourFingersUp 'MaximizeWindow' -FourFingersDown 'MinimizeWindow'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # touchpad
        [state] $Touchpad,

        [state] $LeaveOnWithMouse,

        [ValidateRange(1, 10)]
        [int] $CursorSpeed,

        [TouchpadClickSensitivityMode] $ClickSensitivity,

        [state] $HapticFeedback,

        [ValidateRange(1, 5)]
        [int] $HapticFeedbackIntensity,

        # taps
        [TouchpadSensitivityMode] $Sensitivity,

        [state] $TapToClick,

        [state] $TwoFingersTapToRightClick,

        [state] $TapTwiceAndDragToMultiSelect,

        [state] $RightClickButton,

        [TouchpadRightClickZoneSize] $RightClickZoneSize,

        # scroll & zoom
        [state] $TwoFingersToScroll,

        [ScrollingDirectionMode] $ScrollingDirection,

        [state] $PinchToZoom,

        # gestures
        [TouchpadTapMode] $ThreeFingersTap,

        [TouchpadSwipesMode] $ThreeFingersSwipe,

        [TouchpadTapMode] $FourFingersTap,

        [TouchpadSwipesMode] $FourFingersSwipe
    )

    dynamicparam
    {
        if ($ThreeFingersSwipe -eq 'Custom' -or $FourFingersSwipe -eq 'Custom')
        {
            $DynamicParameters = @()
            if ($ThreeFingersSwipe -eq 'Custom')
            {
                $DynamicParameters += 'ThreeFingersUp', 'ThreeFingersDown', 'ThreeFingersLeft', 'ThreeFingersRight'
            }
            if ($FourFingersSwipe -eq 'Custom')
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
            'CursorSpeed'                  { Set-TouchpadCursorSpeed -Speed $CursorSpeed }
            'ClickSensitivity'             { Set-TouchpadClickSensitivity -Sensitivity $ClickSensitivity }
            'HapticFeedback'               { Set-TouchpadHapticFeedback -State $HapticFeedback }
            'HapticFeedbackIntensity'      { Set-TouchpadHapticFeedbackIntensity -Intensity $HapticFeedbackIntensity }

            'Sensitivity'                  { Set-TouchpadSensitivity -Sensitivity $Sensitivity }
            'TapToClick'                   { Set-TouchpadSingleFingerTapToClick -State $TapToClick }
            'TwoFingersTapToRightClick'    { Set-TouchpadTwoFingersTapToRightClick -State $TwoFingersTapToRightClick }
            'TapTwiceAndDragToMultiSelect' { Set-TouchpadTapTwiceAndDragToMultiSelect -State $TapTwiceAndDragToMultiSelect }
            'RightClickButton'             { Set-TouchpadRightClickButton -State $RightClickButton }
            'RightClickZoneSize'           { Set-TouchpadRightClickZoneSize -Size $RightClickZoneSize }

            'TwoFingersToScroll'           { Set-TouchpadTwoFingersToScroll -State $TwoFingersToScroll }
            'ScrollingDirection'           { Set-TouchpadScrollingDirection -Direction $ScrollingDirection }
            'PinchToZoom'                  { Set-TouchpadPinchToZoom -State $PinchToZoom }

            'ThreeFingersTap'              { Set-TouchpadGesturesThreeFingersTap -Mode $ThreeFingersTap }
            'ThreeFingersSwipe'
            {
                $HashtableSubsetParam = @{
                    Source            = $PSBoundParameters
                    DesiredKeys       = 'ThreeFingersUp', 'ThreeFingersDown', 'ThreeFingersLeft', 'ThreeFingersRight'
                    SubStringToRemove = 'ThreeFingers'
                }
                $ThreeFingersParam = Get-HashtableSubset @HashtableSubsetParam
                Set-TouchpadGesturesThreeFingersSwipe -Mode $ThreeFingersSwipe @ThreeFingersParam
            }
            'FourFingersTap'               { Set-TouchpadGesturesFourFingersTap -Mode $FourFingersTap }
            'FourFingersSwipe'
            {
                $HashtableSubsetParam = @{
                    Source            = $PSBoundParameters
                    DesiredKeys       = 'FourFingersUp', 'FourFingersDown', 'FourFingersLeft', 'FourFingersRight'
                    SubStringToRemove = 'FourFingers'
                }
                $FourFingersParam = Get-HashtableSubset @HashtableSubsetParam
                Set-TouchpadGesturesFourFingersSwipe -Mode $FourFingersSwipe @FourFingersParam
            }
        }
    }
}
