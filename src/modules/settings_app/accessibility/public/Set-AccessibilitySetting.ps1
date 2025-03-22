#=================================================================================================================
#                                            Accessibility - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilitySetting
        [-VisualEffectsAlwaysShowScrollbars {Disabled | Enabled}]
        [-VisualEffectsAnimation {Disabled | Enabled}]
        [-VisualEffectsNotificationsDuration <int>]
        [-ContrastThemesKeyboardShorcut {Disabled | Enabled}]
        [-NarratorKeyboardShorcut {Disabled | Enabled}]
        [-NarratorAutoSendTelemetry {Disabled | Enabled}]
        [-VoiceTypingKeyboardShorcut {Disabled | Enabled}]
        [-KeyboardStickyKeys {Disabled | Enabled}]
        [-KeyboardStickyKeysShorcut {Disabled | Enabled}]
        [-KeyboardFilterKeys {Disabled | Enabled}]
        [-KeyboardFilterKeysShorcut {Disabled | Enabled}]
        [-KeyboardToggleKeysTone {Disabled | Enabled}]
        [-KeyboardToggleKeysToneShorcut {Disabled | Enabled}]
        [-KeyboardPrintScreenKeyOpenScreenCapture {Disabled | Enabled}]
        [-MouseKeys {Disabled | Enabled}]
        [-MouseKeysShorcut {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AccessibilitySetting
{
    <#
    .EXAMPLE
        PS> Set-AccessibilitySetting -KeyboardStickyKeysShorcut 'Disabled' -KeyboardFilterKeysShorcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # visual effects
        [state] $VisualEffectsAlwaysShowScrollbars,

        [state] $VisualEffectsAnimation,

        [ValidateSet(5, 7, 15, 30, 60, 300)]
        [int] $VisualEffectsNotificationsDuration,

        # contrast themes
        [state] $ContrastThemesKeyboardShorcut,

        # narrator
        [state] $NarratorKeyboardShorcut,

        [state] $NarratorAutoSendTelemetry,

        # speech
        [state] $VoiceTypingKeyboardShorcut,

        # keyboard
        [state] $KeyboardStickyKeys,

        [state] $KeyboardStickyKeysShorcut,

        [state] $KeyboardFilterKeys,

        [state] $KeyboardFilterKeysShorcut,

        [state] $KeyboardToggleKeysTone,

        [state] $KeyboardToggleKeysToneShorcut,

        [state] $KeyboardPrintScreenKeyOpenScreenCapture,

        # mouse
        [state] $MouseKeys,

        [state] $MouseKeysShorcut
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
            'VisualEffectsAlwaysShowScrollbars'       { Set-VisualEffectsAlwaysShowScrollbars -State $VisualEffectsAlwaysShowScrollbars }
            'VisualEffectsAnimation'                  { Set-VisualEffectsAnimation -State $VisualEffectsAnimation }
            'VisualEffectsNotificationsDuration'      { Set-VisualEffectsNotificationsDuration -Value $VisualEffectsNotificationsDuration }

            'NarratorKeyboardShorcut'                 { Set-NarratorKeyboardShorcut -State $NarratorKeyboardShorcut }
            'NarratorAutoSendTelemetry'               { Set-NarratorAutoSendTelemetry -State $NarratorAutoSendTelemetry }

            'VoiceTypingKeyboardShorcut'              { Set-VoiceTypingKeyboardShorcut -State $VoiceTypingKeyboardShorcut }

            'KeyboardStickyKeys'                      { Set-KeyboardStickyKeys -State $KeyboardStickyKeys }
            'KeyboardStickyKeysShorcut'               { Set-KeyboardStickyKeys -KeyboardShorcut $KeyboardStickyKeysShorcut }
            'KeyboardFilterKeys'                      { Set-KeyboardFilterKeys -State $KeyboardFilterKeys }
            'KeyboardFilterKeysShorcut'               { Set-KeyboardFilterKeys -KeyboardShorcut $KeyboardFilterKeysShorcut }
            'KeyboardToggleKeysTone'                  { Set-KeyboardToggleKeysTone -State $KeyboardToggleKeysTone }
            'KeyboardToggleKeysToneShorcut'           { Set-KeyboardToggleKeysTone -KeyboardShorcut $KeyboardToggleKeysToneShorcut }
            'KeyboardPrintScreenKeyOpenScreenCapture' { Set-KeyboardPrintScreenKeyOpenScreenCapture -State $KeyboardPrintScreenKeyOpenScreenCapture }

            'MouseKeys'                               { Set-MouseKeys -State $MouseKeys }
            'MouseKeysShorcut'                        { Set-MouseKeys -KeyboardShorcut $MouseKeysShorcut }
        }
    }
}
