#=================================================================================================================
#                                            Accessibility - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilitySetting
        # visual effects
        [-VisualEffectsAlwaysShowScrollbars {Disabled | Enabled}]
        [-VisualEffectsAnimation {Disabled | Enabled}]
        [-VisualEffectsNotifsDurationSeconds <int>]

        # contrast themes
        [-ContrastThemesKeyboardShortcut {Disabled | Enabled}]

        # speech
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
            # visual effects
            'VisualEffectsAlwaysShowScrollbars'  { Set-VisualEffectsAlwaysShowScrollbars -State $VisualEffectsAlwaysShowScrollbars }
            'VisualEffectsAnimation'             { Set-VisualEffectsAnimation -State $VisualEffectsAnimation }
            'VisualEffectsNotifsDurationSeconds' { Set-VisualEffectsNotificationsDuration -Seconds $VisualEffectsNotifsDurationSeconds }

            # contrast themes
            'ContrastThemesKeyboardShortcut'     { Set-ContrastThemes -KeyboardShortcut $ContrastThemesKeyboardShortcut }

            # speech
            'VoiceAccessStartBeforeSignin'        { Set-SpeechVoiceAccessStartBeforeSignin -State $VoiceAccessStartBeforeSignin }
            'VoiceAccessStartAfterSignin'         { Set-SpeechVoiceAccessStartAfterSignin -State $VoiceAccessStartAfterSignin }
        }
    }
}
