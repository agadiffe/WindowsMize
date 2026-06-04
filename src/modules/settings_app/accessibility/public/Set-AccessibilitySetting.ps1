#=================================================================================================================
#                                            Accessibility - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilitySetting
        [-VisualEffectsAlwaysShowScrollbars {Disabled | Enabled}]
        [-VisualEffectsAnimation {Disabled | Enabled}]
        [-VisualEffectsNotifsDurationSeconds <int>]
        [-ContrastThemesKeyboardShortcut {Disabled | Enabled}]
        [-VoiceAccessStartBeforeSignin {Disabled | Enabled}]
        [-VoiceAccessStartAfterSignin {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AccessibilitySetting
{
    <#
    .EXAMPLE
        PS> Set-AccessibilitySetting -VisualEffectsAnimation 'Enabled' -VoiceTypingKeyboardShortcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # visual effects
        [state] $VisualEffectsAlwaysShowScrollbars,

        [state] $VisualEffectsAnimation,

        [ValidateSet(5, 7, 15, 30, 60, 300)]
        [int] $VisualEffectsNotifsDurationSeconds,

        # contrast themes
        [state] $ContrastThemesKeyboardShortcut,

        # speech
        [state] $VoiceAccessStartBeforeSignin,

        [state] $VoiceAccessStartAfterSignin
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
            'VisualEffectsAlwaysShowScrollbars'  { Set-VisualEffectsAlwaysShowScrollbars -State $VisualEffectsAlwaysShowScrollbars }
            'VisualEffectsAnimation'             { Set-VisualEffectsAnimation -State $VisualEffectsAnimation }
            'VisualEffectsNotifsDurationSeconds' { Set-VisualEffectsNotificationsDuration -Seconds $VisualEffectsNotifsDurationSeconds }

            'ContrastThemesKeyboardShortcut'     { Set-ContrastThemes -KeyboardShortcut $ContrastThemesKeyboardShortcut }

            'VoiceAccessStartBeforeSignin'        { Set-SpeechVoiceAccessStartBeforeSignin -State $VoiceAccessStartBeforeSignin }
            'VoiceAccessStartAfterSignin'         { Set-SpeechVoiceAccessStartAfterSignin -State $VoiceAccessStartAfterSignin }
        }
    }
}
