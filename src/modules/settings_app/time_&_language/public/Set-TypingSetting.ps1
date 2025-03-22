#=================================================================================================================
#                                    Time & Language > Date & Time - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-TypingSetting
        [-ShowTextSuggestionsOnSoftwareKeyboard {Disabled | Enabled}]
        [-ShowTextSuggestionsOnPhysicalKeyboard {Disabled | Enabled}]
        [-MultilingualTextSuggestions {Disabled | Enabled}]
        [-AutocorrectMisspelledWords {Disabled | Enabled}]
        [-HighlightMisspelledWords {Disabled | Enabled}]
        [-TypingAndCorrectionHistory {Disabled | Enabled}]
        [-SwitchInputLanguageHotKey {NotAssigned | CtrlShift | LeftAltShift | GraveAccent}]
        [-SwitchKeyboardLayoutHotKey {NotAssigned | CtrlShift | LeftAltShift | GraveAccent}]
        [<CommonParameters>]
#>

function Set-TypingSetting
{
    <#
    .EXAMPLE
        PS> Set-TypingSetting -AutocorrectMisspelledWords 'Disabled' -TypingAndCorrectionHistory 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $ShowTextSuggestionsOnSoftwareKeyboard,

        [state] $ShowTextSuggestionsOnPhysicalKeyboard,

        [state] $MultilingualTextSuggestions,

        [state] $AutocorrectMisspelledWords,

        [state] $HighlightMisspelledWords,

        [state] $TypingAndCorrectionHistory,

        [SwitchInputHotKeys] $SwitchInputLanguageHotKey,

        [SwitchInputHotKeys] $SwitchKeyboardLayoutHotKey
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
            'ShowTextSuggestionsOnSoftwareKeyboard' { Set-TextSuggestionsOnSoftwareKeyboard -State $ShowTextSuggestionsOnSoftwareKeyboard }
            'ShowTextSuggestionsOnPhysicalKeyboard' { Set-TextSuggestionsOnPhysicalKeyboard -State $ShowTextSuggestionsOnPhysicalKeyboard }
            'MultilingualTextSuggestions'           { Set-TextSuggestionsMultilingual -State $MultilingualTextSuggestions }
            'AutocorrectMisspelledWords'            { Set-TypingAutocorrectMisspelledWords -State $AutocorrectMisspelledWords }
            'HighlightMisspelledWords'              { Set-TypingHighlightMisspelledWords -State $HighlightMisspelledWords }
            'TypingAndCorrectionHistory'            { Set-TypingInsights -State $TypingAndCorrectionHistory }
            'SwitchInputLanguageHotKey'             { Set-KeyboardHotKeySwitchInputLanguage -Value $SwitchInputLanguageHotKey }
            'SwitchKeyboardLayoutHotKey'            { Set-KeyboardHotKeySwitchKeyboardLayout -Value $SwitchKeyboardLayoutHotKey }
        }
    }
}
