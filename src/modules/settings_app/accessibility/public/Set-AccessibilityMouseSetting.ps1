#=================================================================================================================
#                                        Accessibility > Mouse - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilityMouseSetting
        [-PointerIndicatorOnCtrl {Disabled | Enabled}]
        [-PointerTrailsLength <int>]
        [-SnapToDefaultButton {Disabled | Enabled}]
        [-HidePointerWhileTyping {Disabled | Enabled}]
        [-DoubleClickSpeed <int>]
        [-ClickLock {Disabled | Enabled}]
        [-ClickLockDelay <int>]
        [-ActivateOnHover {Disabled | Enabled}]
        [-ActivateOnHoverDelay <int>]
        [-ActivateOnHoverRaiseWindow {Disabled | Enabled}]
        [-MouseKeys {Disabled | Enabled}]
        [-MouseKeysKeyboardShortcut {Disabled | Enabled}]
        [-MouseKeysUseWhenNumLockOn {Disabled | Enabled}]
        [-MouseKeysShowTrayIcon {Disabled | Enabled}]
        [-MouseKeysCtrlShiftSpeedAdjust {Disabled | Enabled}]
        [-MouseKeysHotkeyActivationPrompt {Disabled | Enabled}]
        [-MouseKeysHotkeyToggleSound {Disabled | Enabled}]
        [-MouseKeysSpeed <int>]
        [-MouseKeysAcceleration <int>]
        [<CommonParameters>]
#>

function Set-AccessibilityMouseSetting
{
    <#
    .EXAMPLE
        PS> Set-AccessibilityMouseSetting -MouseKeysUseWhenNumLockOn 'Enabled' -DoubleClickSpeed 5
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # mouse pointer
        [state] $PointerIndicatorOnCtrl,

        [ValidateSet(0, 2, 3, 4, 5, 6, 7)]
        [int] $PointerTrailsLength,

        # mouse
        [state] $SnapToDefaultButton,
        [state] $HidePointerWhileTyping,

        [ValidateRange(1, 11)]
        [int] $DoubleClickSpeed,

        [state] $ClickLock,

        [ValidateRange(1, 11)]
        [int] $ClickLockDelay,

        [state] $ActivateOnHover,
        [state] $ActivateOnHoverRaiseWindow,

        [ValidateRange(1, 9)]
        [int] $ActivateOnHoverDelay,

        # mouse keys
        [state] $MouseKeys,
        [state] $MouseKeysKeyboardShortcut,
        [state] $MouseKeysUseWhenNumLockOn,
        [state] $MouseKeysShowTrayIcon,
        [state] $MouseKeysCtrlShiftSpeedAdjust,
        [state] $MouseKeysHotkeyActivationPrompt,
        [state] $MouseKeysHotkeyToggleSound,

        [ValidateRange(0, 100)]
        [int] $MouseKeysSpeed,

        [ValidateRange(0, 100)]
        [int] $MouseKeysAcceleration
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'PointerIndicatorOnCtrl'          { Set-MousePointerIndicatorOnCtrl -State $PointerIndicatorOnCtrl }
            'PointerTrailsLength'             { Set-MousePointerTrails -Length $PointerTrailsLength }

            'SnapToDefaultButton'             { Set-MouseSnapToDefaultButton -State $SnapToDefaultButton }
            'HidePointerWhileTyping'          { Set-MouseHidePointerWhileTyping -State $HidePointerWhileTyping }
            'DoubleClickSpeed'                { Set-MouseDoubleClickSpeed -Speed $DoubleClickSpeed }
            'ClickLock'                       { Set-MouseClickLock -State $ClickLock }
            'ClickLockDelay'                  { Set-MouseClickLockDelay -Level $ClickLockDelay }
            'ActivateOnHover'                 { Set-MouseActivateOnHover -State $ActivateOnHover }
            'ActivateOnHoverDelay'            { Set-MouseActivateOnHoverDelay -Level $ActivateOnHoverDelay }
            'ActivateOnHoverRaiseWindow'      { Set-MouseActivateOnHoverRaiseWindow -State $ActivateOnHoverRaiseWindow }

            'MouseKeys'                       { Set-MouseKeys -State $MouseKeys }
            'MouseKeysShortcut'               { Set-MouseKeys -KeyboardShortcut $MouseKeysShortcut }
            'MouseKeysUseWhenNumLockOn'       { Set-MouseKeys -UseWhenNumLockOn $MouseKeysUseWhenNumLockOn }
            'MouseKeysShowTrayIcon'           { Set-MouseKeys -ShowTrayIcon $MouseKeysShowTrayIcon }
            'MouseKeysCtrlShiftSpeedAdjust'   { Set-MouseKeys -CtrlShiftSpeedAdjust $MouseKeysCtrlShiftSpeedAdjust }
            'MouseKeysHotkeyActivationPrompt' { Set-MouseKeys -HotkeyActivationPrompt $MouseKeysHotkeyActivationPrompt }
            'MouseKeysHotkeyToggleSound'      { Set-MouseKeys -HotkeyToggleSound $MouseKeysHotkeyToggleSound }
            'MouseKeysSpeed'                  { Set-MouseKeysSpeed -Speed $MouseKeysSpeed }
            'MouseKeysAcceleration'           { Set-MouseKeysAcceleration -Speed $MouseKeysAcceleration }
        }
    }
}
