#=================================================================================================================
#                                       Accessibility > Keyboard - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilityKeyboardSetting
        [-UnderlineAccessKeys {Disabled | Enabled}]
        [-StickyKeys {Disabled | Enabled}]
        [-StickyKeysKeyboardShortcut {Disabled | Enabled}]
        [-StickyKeysShowTrayIcon {Disabled | Enabled}]
        [-StickyKeysLockOnDoublePress {Disabled | Enabled}]
        [-StickyKeysDisableOnTwoKeypress {Disabled | Enabled}]
        [-StickyKeysKeypressSound {Disabled | Enabled}]
        [-StickyKeysHotkeyActivationPrompt {Disabled | Enabled}]
        [-StickyKeysHotkeyToggleSound {Disabled | Enabled}]
        [-FilterKeys {Disabled | Enabled}]
        [-FilterKeysKeyboardShortcut {Disabled | Enabled}]
        [-FilterKeysShowTrayIcon {Disabled | Enabled}]
        [-FilterKeysKeypressSound {Disabled | Enabled}]
        [-FilterKeysQuickDelay <double>]
        [-FilterKeysBounceDelay <double>]
        [-FilterKeysRepeatDelay <double>]
        [-FilterKeysHotkeyActivationPrompt {Disabled | Enabled}]
        [-FilterKeysHotkeyToggleSound {Disabled | Enabled}]
        [-ToggleKeys {Disabled | Enabled}]
        [-ToggleKeysKeyboardShortcut {Disabled | Enabled}]
        [-ToggleKeysHotkeyActivationPrompt {Disabled | Enabled}]
        [-ToggleKeysHotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AccessibilityKeyboardSetting
{
    <#
    .EXAMPLE
        PS> Set-AccessibilityKeyboardSetting -StickyKeysKeyboardShortcut 'Disabled' -FilterKeysShowTrayIcon 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # general
        [state] $UnderlineAccessKeys,

        # sticky keys
        [state] $StickyKeys,
        [state] $StickyKeysKeyboardShortcut,
        [state] $StickyKeysShowTrayIcon,
        [state] $StickyKeysLockOnDoublePress,
        [state] $StickyKeysDisableOnTwoKeypress,
        [state] $StickyKeysKeypressSound,
        [state] $StickyKeysHotkeyActivationPrompt,
        [state] $StickyKeysHotkeyToggleSound,

        # filter keys
        [state] $FilterKeys,
        [state] $FilterKeysKeyboardShortcut,
        [state] $FilterKeysShowTrayIcon,
        [state] $FilterKeysKeypressSound,
        [state] $FilterKeysHotkeyActivationPrompt,
        [state] $FilterKeysHotkeyToggleSound,

        [ValidateSet(0, 0.3, 0.5, 0.7, 1, 1.4, 2, 5, 10, 20)]
        [double] $FilterKeysQuickDelaySeconds,

        [ValidateSet(0, 0.3, 0.5, 0.7, 1, 1.5, 2)]
        [double] $FilterKeysBounceDelaySeconds,

        [ValidateSet(0, 0.3, 0.5, 0.7, 1, 1.5, 2)]
        [double] $FilterKeysRepeatDelaySeconds,

        # toggle keys
        [state] $ToggleKeys,
        [state] $ToggleKeysKeyboardShortcut,
        [state] $ToggleKeysHotkeyActivationPrompt,
        [state] $ToggleKeysHotkeyToggleSound
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
            'UnderlineAccessKeys'              { Set-KeyboardUnderlineAccessKeys -State $UnderlineAccessKeys }

            'StickyKeys'                       { Set-KeyboardStickyKeys -State $StickyKeys }
            'StickyKeysKeyboardShortcut'       { Set-KeyboardStickyKeys -KeyboardShortcut $StickyKeysKeyboardShortcut }
            'StickyKeysShowTrayIcon'           { Set-KeyboardStickyKeys -ShowTrayIcon $StickyKeysShowTrayIcon }
            'StickyKeysLockOnDoublePress'      { Set-KeyboardStickyKeys -LockOnDoublePress $StickyKeysLockOnDoublePress }
            'StickyKeysDisableOnTwoKeypress'   { Set-KeyboardStickyKeys -DisableOnTwoKeypress $StickyKeysDisableOnTwoKeypress }
            'StickyKeysKeypressSound'          { Set-KeyboardStickyKeys -KeypressSound $StickyKeysKeypressSound }
            'StickyKeysHotkeyActivationPrompt' { Set-KeyboardStickyKeys -HotkeyActivationPrompt $StickyKeysHotkeyActivationPrompt }
            'StickyKeysHotkeyToggleSound'      { Set-KeyboardStickyKeys -HotkeyToggleSound $StickyKeysHotkeyToggleSound }

            'FilterKeys'                       { Set-KeyboardFilterKeys -State $FilterKeys }
            'FilterKeysKeyboardShortcut'       { Set-KeyboardFilterKeys -KeyboardShortcut $FilterKeysKeyboardShortcut }
            'FilterKeysShowTrayIcon'           { Set-KeyboardFilterKeys -ShowTrayIcon $FilterKeysShowTrayIcon }
            'FilterKeysKeypressSound'          { Set-KeyboardFilterKeys -KeypressSound $FilterKeysKeypressSound }
            'FilterKeysQuickDelaySeconds'      { Set-KeyboardFilterKeysQuickDelay -Seconds $FilterKeysQuickDelaySeconds }
            'FilterKeysBounceDelaySeconds'     { Set-KeyboardFilterKeysBounceDelay -Seconds $FilterKeysBounceDelaySeconds }
            'FilterKeysRepeatDelaySeconds'     { Set-KeyboardFilterKeysRepeatDelay -Seconds $FilterKeysRepeatDelaySeconds }
            'FilterKeysHotkeyActivationPrompt' { Set-KeyboardFilterKeys -HotkeyActivationPrompt $FilterKeysHotkeyActivationPrompt }
            'FilterKeysHotkeyToggleSound'      { Set-KeyboardFilterKeys -HotkeyToggleSound $FilterKeysHotkeyToggleSound }

            'ToggleKeys'                       { Set-KeyboardToggleKeys -State $ToggleKeys }
            'ToggleKeysKeyboardShortcut'       { Set-KeyboardToggleKeys -KeyboardShortcut $ToggleKeysKeyboardShortcut }
            'ToggleKeysHotkeyActivationPrompt' { Set-KeyboardToggleKeys -HotkeyActivationPrompt $ToggleKeysHotkeyActivationPrompt }
            'ToggleKeysHotkeyToggleSound'      { Set-KeyboardToggleKeys -HotkeyToggleSound $ToggleKeysHotkeyToggleSound }
        }
    }
}
