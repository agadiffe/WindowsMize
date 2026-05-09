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
        [-SingleFingerToScroll {Disabled | LeftSide | RightSide}]
        [-AutoScrollingWithPressure {Disabled | Enabled}]
        [-AutoScrollingAtEdge {Disabled | Enabled}]
        [-AcceleratedScrolling {Disabled | Enabled}]
        [-ScrollSpeed <int>]
        [-ScrollingDirection {DownMotionScrollsDown | DownMotionScrollsUp}]
        [-PinchToZoom {Disabled | Enabled}]
        [-ZoomSpeed <int>]
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
        [-FourFingersSwipe { same as ThreeFingersSwipe }]
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
        Dynamic parameters: available when 'ThreeFingersSwipe' or 'FourFingersSwipe' are defined to 'Custom'.
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

        [SingleFingerScrollMode] $SingleFingerToScroll,

        [state] $AutoScrollingWithPressure,

        [state] $AutoScrollingAtEdge,

        [state] $AcceleratedScrolling,

        [ValidateRange(0, 10)]
        [int] $ScrollSpeed,

        [ScrollingDirectionMode] $ScrollingDirection,

        [state] $PinchToZoom,

        [ValidateRange(0, 10)]
        [int] $ZoomSpeed,

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
            'SingleFingerToScroll'         { Set-TouchpadSingleFingerToScroll -Mode $SingleFingerToScroll }
            'AutoScrollingWithPressure'    { Set-TouchpadAutoScrollingWithPressure -State $AutoScrollingWithPressure }
            'AutoScrollingAtEdge'          { Set-TouchpadAutoScrollingAtEdge -State $AutoScrollingAtEdge }
            'AcceleratedScrolling'         { Set-TouchpadAcceleratedScrolling -State $AcceleratedScrolling }
            'ScrollSpeed'                  { Set-TouchpadScrollSpeed -Speed $ScrollSpeed }
            'ScrollingDirection'           { Set-TouchpadScrollingDirection -Direction $ScrollingDirection }
            'PinchToZoom'                  { Set-TouchpadPinchToZoom -State $PinchToZoom }
            'ZoomSpeed'                    { Set-TouchpadPinchToZoomSpeed -Speed $ZoomSpeed }

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
