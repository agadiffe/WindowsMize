#=================================================================================================================
#                                       Accessibility > Narrator - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AccessibilityNarratorSetting
        # general
        [-StartBeforeSignin {Disabled | Enabled}]
        [-StartAfterSignin {Disabled | Enabled}]
        [-NarratorKeyboardShortcut {Disabled | Enabled}]
        [-ShowHomeOnStartup {Disabled | Enabled}]

        # voice
        [-VoiceSpeed <int>]
        [-VoicePitchLevel <int>]
        [-VoiceVolume <int>]
        [-LowerOtherAppsVolume {Disabled | Enabled}]

        # verbosity
        [-VerbosityLevel {TextOnly | SomeControlDetails | AllControlDetails | SomeTextDetails | AllTextDetails}]
        [-EmphasizeFormattedText {Disabled | Enabled}]
        [-ReadCharactersPhonetically {Disabled | Enabled}]
        [-PunctuationPause {Disabled | Enabled}]
        [-ReadAdvancedDetails {Disabled | Enabled}]
        [-CapitalizationReadingMode {NoAnnounce | IncreasePitch | SayCap}]

        # context
        [-ContextLevel {NoContext | ImmediateContext | ImmediateContextNameAndType |
                        FullContextOfNewControl | FullContextOfOldAndNewControls}]
        [-ReadInteractionHints {Disabled | Enabled}]
        [-ExplainActionFailures {Disabled | Enabled}]
        [-PlaySoundsForCommonActions {Disabled | Enabled}]
        [-ContextDetailsOrder {AfterControls | BeforeControls}]

        # announce
        [-AnnounceTypedCharacters {Disabled | Enabled}]
        [-AnnounceTypedWords {Disabled | Enabled}]
        [-AnnounceTypedFunctionKeys {Disabled | Enabled}]
        [-AnnounceTypedNavigationKeys {Disabled | Enabled}]
        [-AnnounceTypedToggleKeys {Disabled | Enabled}]
        [-AnnounceTypedModifierKeys {Disabled | Enabled}]

        # mouse and keyboard
        [-NarratorKey {CapsLock | Insert | CapsLockOrInsert}]
        [-LockNarratorKey {Disabled | Enabled}]
        [-TouchKeyboardActivateKeysOnLift {Disabled | Enabled}]
        [-MouseInteraction {Disabled | Enabled}]
        [-NarratorCursorFollowMouse {Disabled | Enabled}]
        [-KeyboardLayout {Legacy | Standard}]

        # narrator cursor
        [-ShowNarratorCursor {Disabled | Enabled}]
        [-SyncNarratorCursorWithTextCursor {Disabled | Enabled}]
        [-SyncNarratorCursorWithSystemFocus {Disabled | Enabled}]
        [-NavigationMode {Normal | Advanced}]

        # extensions
        [-Extensions {Disabled | Enabled}]
        [-CheckForNewExtensionsOnStartup {Disabled | Enabled}]

        # data and services
        [-ContentDescriptions {Disabled | Enabled}]
        [-Telemetry {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AccessibilityNarratorSetting
{
    <#
    .EXAMPLE
        PS> Set-AccessibilityNarratorSetting -KeyboardShortcut 'Disabled' -Telemetry 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # general
        [state] $StartBeforeSignin,
        [state] $StartAfterSignin,
        [state] $KeyboardShortcut,
        [state] $ShowHomeOnStartup,

        # voice
        [ValidateRange(0, 20)]
        [int] $VoiceSpeed,

        [ValidateRange(0, 20)]
        [int] $VoicePitchLevel,

        [ValidateRange(0, 100)]
        [int] $VoiceVolume,

        [state] $LowerOtherAppsVolume,

        # verbosity
        [NarratorVerbosityLevel] $VerbosityLevel,
        [state] $EmphasizeFormattedText,
        [state] $ReadCharactersPhonetically,
        [state] $PunctuationPause,
        [state] $ReadAdvancedDetails,
        [NarratorCapitalizationReadingMode] $CapitalizationReadingMode,

        # context
        [NarratorContextLevel] $ContextLevel,
        [state] $ReadInteractionHints,
        [state] $ExplainActionFailures,
        [state] $PlaySoundsForCommonActions,
        [NarratorContextDetailsOrder] $ContextDetailsOrder,

        # announce
        [state] $AnnounceTypedCharacters,
        [state] $AnnounceTypedWords,
        [state] $AnnounceTypedFunctionKeys,
        [state] $AnnounceTypedNavigationKeys,
        [state] $AnnounceTypedToggleKeys,
        [state] $AnnounceTypedModifierKeys,

        # mouse and keyboard
        [NarratorKey] $NarratorKey,
        [state] $LockNarratorKey,
        [state] $TouchKeyboardActivateKeysOnLift,
        [state] $MouseInteraction,
        [state] $NarratorCursorFollowMouse,
        [NarratorKeyboardLayout] $KeyboardLayout,

        # narrator cursor
        [state] $ShowNarratorCursor,
        [state] $SyncNarratorCursorWithTextCursor,
        [state] $SyncNarratorCursorWithSystemFocus,
        [NarratorNavigationMode] $NavigationMode,

        # extensions
        [state] $Extensions,
        [state] $CheckForNewExtensionsOnStartup,

        # data and services
        [state] $ContentDescriptions,
        [state] $Telemetry
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
            # general
            'StartBeforeSignin'                 { Set-NarratorStartBeforeSignin -State $StartBeforeSignin }
            'StartAfterSignin'                  { Set-NarratorStartAfterSignin -State $StartAfterSignin }
            'KeyboardShortcut'                  { Set-NarratorKeyboardShortcut -State $KeyboardShortcut }
            'ShowHomeOnStartup'                 { Set-NarratorShowHomeOnStartup -State $ShowHomeOnStartup }

            # voice
            'VoiceSpeed'                        { Set-NarratorVoiceSpeed -Speed $VoiceSpeed }
            'VoicePitchLevel'                   { Set-NarratorVoicePitch -Level $VoicePitchLevel }
            'VoiceVolume'                       { Set-NarratorVoiceVolume -Volume $VoiceVolume }
            'LowerOtherAppsVolume'              { Set-NarratorLowerOtherAppsVolume -State $LowerOtherAppsVolume }

            # verbosity
            'VerbosityLevel'                    { Set-NarratorVerbosityLevel -Mode $VerbosityLevel }
            'EmphasizeFormattedText'            { Set-NarratorEmphasizeFormattedText -State $EmphasizeFormattedText }
            'ReadCharactersPhonetically'        { Set-NarratorReadCharactersPhonetically -State $ReadCharactersPhonetically }
            'PunctuationPause'                  { Set-NarratorPunctuationPause -State $PunctuationPause }
            'ReadAdvancedDetails'               { Set-NarratorReadAdvancedDetails -State $ReadAdvancedDetails }
            'CapitalizationReadingMode'         { Set-NarratorCapitalizationReadingMode -Mode $CapitalizationReadingMode }

            # context
            'ContextLevel'                      { Set-NarratorContextLevel -Mode $ContextLevel }
            'ReadInteractionHints'              { Set-NarratorReadInteractionHints -State $ReadInteractionHints }
            'ExplainActionFailures'             { Set-NarratorExplainActionFailures -State $ExplainActionFailures }
            'PlaySoundsForCommonActions'        { Set-NarratorPlaySoundsForCommonActions -State $PlaySoundsForCommonActions }
            'ContextDetailsOrder'               { Set-NarratorContextDetailsOrder -Order $ContextDetailsOrder }

            # announce
            'AnnounceTypedCharacters'           { Set-NarratorAnnounceTypedCharacters -State $AnnounceTypedCharacters }
            'AnnounceTypedWords'                { Set-NarratorAnnounceTypedWords -State $AnnounceTypedWords }
            'AnnounceTypedFunctionKeys'         { Set-NarratorAnnounceTypedFunctionKeys -State $AnnounceTypedFunctionKeys }
            'AnnounceTypedNavigationKeys'       { Set-NarratorAnnounceTypedNavigationKeys -State $AnnounceTypedNavigationKeys }
            'AnnounceTypedToggleKeys'           { Set-NarratorAnnounceTypedToggleKeys -State $AnnounceTypedToggleKeys }
            'AnnounceTypedModifierKeys'         { Set-NarratorAnnounceTypedModifierKeys -State $AnnounceTypedModifierKeys }

            # mouse and keyboard
            'NarratorKey'                       { Set-NarratorKey -Key $NarratorKey }
            'LockNarratorKey'                   { Set-NarratorLockKey -State $LockNarratorKey }
            'TouchKeyboardActivateKeysOnLift'   { Set-NarratorTouchKeyboardActivateKeysOnLift -State $TouchKeyboardActivateKeysOnLift }
            'MouseInteraction'                  { Set-NarratorMouseInteraction -State $MouseInteraction }
            'NarratorCursorFollowMouse'         { Set-NarratorCursorFollowMouse -State $NarratorCursorFollowMouse }
            'KeyboardLayout'                    { Set-NarratorKeyboardLayout -Layout $KeyboardLayout }

            # narrator cursor
            'ShowNarratorCursor'                { Set-NarratorShowNarratorCursor -State $ShowNarratorCursor }
            'SyncNarratorCursorWithTextCursor'  { Set-NarratorCursorSyncWithTextCursor -State $SyncNarratorCursorWithTextCursor }
            'SyncNarratorCursorWithSystemFocus' { Set-NarratorCursorSyncWithSystemFocus -State $SyncNarratorCursorWithSystemFocus }
            'NavigationMode'                    { Set-NarratorNavigationMode -Mode $NavigationMode }

            # extensions
            'Extensions'                        { Set-NarratorExtensions -State $Extensions }
            'CheckForNewExtensionsOnStartup'    { Set-NarratorCheckForNewExtensionsOnStartup -State $CheckForNewExtensionsOnStartup }

            # data and services
            'ContentDescriptions'               { Set-NarratorContentDescriptions -State $ContentDescriptions }
            'Telemetry'                         { Set-NarratorTelemetry -State $Telemetry }
        }
    }
}
