#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\accessibility"


# Parameters values (if not specified):
#   State: Disabled | Enabled

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                Accessibility
#==============================================================================

Write-Section -Name 'Windows Settings App - Accessibility'

#==========================================================
#                      Visual effects
#==========================================================
#region visual effects

Write-Section -Name 'Visual effects' -SubSection

# --- Always show scrollbars (default: Disabled)
Set-AccessibilitySetting -VisualEffectsAlwaysShowScrollbars 'Disabled'

# --- Transparency effects (default: Enabled)
# See 'scripts > win_settings_app > personnalization.ps1'

# --- Animation effects (default: Enabled)
Set-AccessibilitySetting -VisualEffectsAnimation 'Enabled'

# --- Dismiss notifications after this amount of time
# Value (seconds): 5 (default) | 7 | 15 | 30 | 60 | 300
Set-AccessibilitySetting -VisualEffectsNotifsDurationSeconds 5

#endregion visual effects

#==========================================================
#                     Contrast themes
#==========================================================
#region contrast themes

Write-Section -Name 'Contrast themes' -SubSection

# --- Keyboard shortcut for contrast themes (default: Enabled)
Set-AccessibilitySetting -ContrastThemesKeyboardShortcut 'Disabled'

#endregion contrast themes

#==========================================================
#                         Narrator
#==========================================================
#region narrator

Write-Section -Name 'Narrator' -SubSection

# --- Start Narrator before sign-in (default: Disabled)
Set-AccessibilityNarratorSetting -StartBeforeSignin 'Disabled'

# --- Start Narrator after sign-in (default: Disabled)
Set-AccessibilityNarratorSetting -StartAfterSignin 'Disabled'

# --- Keyboard shortcut for Narrator (default: Enabled)
Set-AccessibilityNarratorSetting -KeyboardShortcut 'Disabled'

# --- Show Narrator Home when Narrator starts (default: Enabled)
Set-AccessibilityNarratorSetting -ShowHomeOnStartup 'Enabled'

#           Narrator's Voice
#=======================================

# --- Speed (default: 10 (range: 0-20))
Set-AccessibilityNarratorSetting -VoiceSpeed 10

# --- Pitch (default: 10 (range: 0-20))
Set-AccessibilityNarratorSetting -VoicePitchLevel 10

# --- Volume (default: 100 (range: 0-100))
Set-AccessibilityNarratorSetting -VoiceVolume 100

# --- Lower the volume of other apps when Narrator is speaking (default: Enabled)
Set-AccessibilityNarratorSetting -LowerOtherAppsVolume 'Enabled'

#            Verbosity Level
#=======================================

# --- Verbosity level
# State: TextOnly | SomeControlDetails | AllControlDetails (default) | SomeTextDetails | AllTextDetails
Set-AccessibilityNarratorSetting -VerbosityLevel 'AllControlDetails'

# --- Emphasize formatted text (default: Disabled)
Set-AccessibilityNarratorSetting -EmphasizeFormattedText 'Disabled'

# --- Read phonetically when reading by character (default: Disabled)
Set-AccessibilityNarratorSetting -ReadCharactersPhonetically 'Disabled'

# --- Pause slightly when reading punctuation (default: Enabled)
Set-AccessibilityNarratorSetting -PunctuationPause 'Enabled'

# --- Read advanced details, like help text, on buttons and other controls (default: Disabled)
Set-AccessibilityNarratorSetting -ReadAdvancedDetails 'Disabled'

# --- Change how capitalized text is read
# State: NoAnnounce (default) | IncreasePitch | SayCap
Set-AccessibilityNarratorSetting -CapitalizationReadingMode 'NoAnnounce'

#             Context Level
#=======================================

# --- Context level for buttons and controls
# State: NoContext | ImmediateContext | ImmediateContextNameAndType (default) | FullContextOfNewControl | FullContextOfOldAndNewControls
Set-AccessibilityNarratorSetting -ContextLevel 'ImmediateContextNameAndType'

# --- Read hints on how to interact with buttons and other controls (default: Enabled)
Set-AccessibilityNarratorSetting -ReadInteractionHints 'Enabled'

# --- Tell me why actions can't be performed (default: Enabled)
Set-AccessibilityNarratorSetting -ExplainActionFailures 'Enabled'

# --- Play sounds instead of announcements for common actions (default: Disabled)
Set-AccessibilityNarratorSetting -PlaySoundsForCommonActions 'Disabled'

# --- Tell me details about buttons and other controls
# State: AfterControls | BeforeControls (default)
Set-AccessibilityNarratorSetting -ContextDetailsOrder 'BeforeControls'

#         Announce When I Type
#=======================================

# --- Letters, numbers, and punctuation (default: Enabled)
Set-AccessibilityNarratorSetting -AnnounceTypedCharacters 'Enabled'

# --- Words (default: Enabled)
Set-AccessibilityNarratorSetting -AnnounceTypedWords 'Enabled'

# --- Function keys (default: Disabled)
Set-AccessibilityNarratorSetting -AnnounceTypedFunctionKeys 'Disabled'

# --- Arrow, Tab, and other navigation keys (default: Disabled)
Set-AccessibilityNarratorSetting -AnnounceTypedNavigationKeys 'Disabled'

# --- Toggle keys, like Caps lock and Num lock (default: Enabled)
Set-AccessibilityNarratorSetting -AnnounceTypedToggleKeys 'Enabled'

# --- Shift, Alt, and other modifier keys (default: Disabled)
Set-AccessibilityNarratorSetting -AnnounceTypedModifierKeys 'Disabled'

#          Mouse And Keyboard
#=======================================

# --- Narrator key
# State: CapsLock | Insert | CapsLockOrInsert (defeult)
Set-AccessibilityNarratorSetting -NarratorKey 'CapsLockOrInsert'

# --- --- Lock the Narrator key so I don't have to press it for each command (default: Disabled)
Set-AccessibilityNarratorSetting -LockNarratorKey 'Disabled'

# --- On touch keyboards, activate keys when i lift my finger (default: Disabled)
Set-AccessibilityNarratorSetting -TouchKeyboardActivateKeysOnLift 'Disabled'

# --- Read and interact with the screen using the mouse (default: Disabled)
Set-AccessibilityNarratorSetting -MouseInteraction 'Disabled'

# --- --- Have the Narrator cursor follow my mouse (default: Disabled)
Set-AccessibilityNarratorSetting -NarratorCursorFollowMouse 'Disabled'

# --- Keyboard layout
# State: Legacy | Standard (defeult)
Set-AccessibilityNarratorSetting -KeyboardLayout 'Standard'

#            Narrator Cursor
#=======================================

# --- Show the Narrator cursor (default: Enabled)
Set-AccessibilityNarratorSetting -ShowNarratorCursor 'Enabled'

# --- Move my text cursor with the Narrator cursor as Narrator reads text (default: Disabled)
Set-AccessibilityNarratorSetting -SyncNarratorCursorWithTextCursor 'Disabled'

# --- Sync the Narrator cursor and system focus (default: Enabled)
Set-AccessibilityNarratorSetting -SyncNarratorCursorWithSystemFocus 'Enabled'

# --- Navigation mode
# State: Normal (default) | Advanced
Set-AccessibilityNarratorSetting -NavigationMode 'Normal'

#              Extensions
#=======================================

# --- Enable Narrator extensions (default: Enabled)
Set-AccessibilityNarratorSetting -Extensions 'Enabled'

# --- --- Find and download new extensions on Narrator startup (default: Enabled)
Set-AccessibilityNarratorSetting -CheckForNewExtensionsOnStartup 'Disabled'

#           Data And Services
#=======================================

# --- Get image descriptions, page titles, and popular links (default: Enabled)
Set-AccessibilityNarratorSetting -ContentDescriptions 'Enabled'

# --- Automatically send diagnostic and performance data (default: Disabled)
Set-AccessibilityNarratorSetting -Telemetry 'Disabled'

#endregion narrator

#==========================================================
#                          Speech
#==========================================================
#region speech

Write-Section -Name 'Speech' -SubSection

#             Voice Access
#=======================================

# --- Start voice access before you sign in to your PC (default: Disabled)
Set-AccessibilitySetting -VoiceAccessStartBeforeSignin 'Disabled'

# --- Start voice access after you sign in to your PC (default: Disabled)
Set-AccessibilitySetting -VoiceAccessStartAfterSignin 'Disabled'

#endregion speech

#==========================================================
#                         Keyboard
#==========================================================
#region keyboard

Write-Section -Name 'Keyboard' -SubSection

# --- Underline access keys (default: Disabled)
Set-AccessibilityKeyboardSetting -UnderlineAccessKeys 'Disabled'

#              Sticky Keys
#=======================================

# --- Sticky keys (default: Disabled)
Set-AccessibilityKeyboardSetting -StickyKeys 'Disabled'

# --- --- Keyboard shortcut for Sticky keys (default: Enabled)
Set-AccessibilityKeyboardSetting -StickyKeysKeyboardShortcut 'Disabled'

# --- --- Show the Sticky keys icon on the taskbar (default: Enabled)
Set-AccessibilityKeyboardSetting -StickyKeysShowTrayIcon 'Enabled'

# --- --- Lock shortcut keys when pressed twice in a row (default: Enabled)
Set-AccessibilityKeyboardSetting -StickyKeysLockOnDoublePress 'Enabled'

# --- --- Turn off Sticky keys when two keys are pressed at the same time (default: Enabled)
Set-AccessibilityKeyboardSetting -StickyKeysDisableOnTwoKeypress 'Enabled'

# --- --- Play a sound when shortcut keys are pressed and released (default: Enabled)
Set-AccessibilityKeyboardSetting -StickyKeysKeypressSound 'Enabled'

#              Filter Keys
#=======================================

# --- Filter keys (default: Disabled)
Set-AccessibilityKeyboardSetting -FilterKeys 'Disabled'

# --- --- Keyboard shortcut for Filter keys (default: Enabled)
Set-AccessibilityKeyboardSetting -FilterKeysShortcut 'Disabled'

# --- --- Show the Filter keys icon on the taskbar (default: Enabled)
Set-AccessibilityKeyboardSetting -FilterKeysShowTrayIcon 'Enabled'

# --- --- Beep when keys are pressed or accepted (default: Enabled)
Set-AccessibilityKeyboardSetting -FilterKeysKeypressSound 'Enabled'

# --- --- Ignore quick keystrokes (slow keys)
#   Wait before accepting a keystroke
# Delay (seconds): 0 (disabled) (default) | 0.3 (default if enabled) | 0.5 | 0.7 | 1 | 1.4 | 2 | 5 | 10 | 20
Set-AccessibilityKeyboardSetting -FilterKeysQuickDelaySeconds 0

# --- --- Ignore unintended keystrokes (bounce keys)
#   Wait before accepting repeated keystrokes
# Delay (seconds): 0 (disabled) (default) | 0.3 | 0.5 (default if enabled) | 0.7 | 1 | 1.5 | 2
Set-AccessibilityKeyboardSetting -FilterKeysBounceDelaySeconds 0

# --- --- Ignore repeated keystrokes (repeat keys)
#   Wait before accepting the first repeated keystroke
#   Wait before accepting subsequent repeated keystrokes
# Delay (seconds): 0 (disabled) (default) | 0.3 (default if enabled) | 0.5 | 0.7 | 1 | 1.5 | 2
Set-AccessibilityKeyboardSetting -FilterKeysRepeatDelaySeconds 0

#              Toggle Keys
#=======================================

# --- Toggle keys (default: Disabled)
Set-AccessibilityKeyboardSetting -ToggleKeys 'Disabled'

# --- --- Keyboard shortcut for Toggle keys (default: Enabled)
Set-AccessibilityKeyboardSetting -ToggleKeysKeyboardShortcut 'Disabled'

#endregion keyboard

#==========================================================
#                     Mouse Pointer
#==========================================================
#region mouse pointer

Write-Section -Name 'Mouse' -SubSection

# --- Mouse indicator (default: Disabled)
Set-AccessibilityMouseSetting -PointerIndicatorOnCtrl 'Disabled'

# --- Mouse pointer trails
# Length: 0 (disabled) (default) | 2 | 3 | 4 | 5 | 6 | 7
Set-AccessibilityMouseSetting -PointerTrailsLength 0

# --- Enable mouse pointer shadow (default: Enabled)
# See 'scripts > system_&_tweaks > system_properties.ps1'

#endregion mouse pointer

#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# --- Snap to default button (default: Disabled)
Set-AccessibilityMouseSetting -SnapToDefaultButton 'Disabled'

# --- Hide pointer while typing (default: Enabled)
Set-AccessibilityMouseSetting -HidePointerWhileTyping 'Enabled'

# --- Double click speed (default: 5 (range: 1-11))
Set-AccessibilityMouseSetting -DoubleClickSpeed 5

#              Click Lock
#=======================================

# --- Click lock (default: Disabled)
Set-AccessibilityMouseSetting -ClickLock 'Disabled'

# --- Amount of time mouse button needs to be down to lock (default: 6 (range: 1-11))
Set-AccessibilityMouseSetting -ClickLockDelay 6

#           Activate On Hover
#=======================================

# --- Activate On Hover (default: Disabled)
Set-AccessibilityMouseSetting -ActivateOnHover 'Disabled'

# --- --- Move window to top when activating for mouse hover (default: Disabled)
Set-AccessibilityMouseSetting -ActivateOnHoverRaiseWindow 'Disabled'

# --- --- Amount of time mouse needs to be over a windows to activate it (default: 5 (range: 1-9))
Set-AccessibilityMouseSetting -ActivateOnHoverDelay 5

#              Mouse Keys
#=======================================

# --- Mouse keys (default: Disabled)
Set-AccessibilityMouseSetting -MouseKeys 'Disabled'

# --- --- Keyboard shortcut for Mouse keys (default: Enabled)
Set-AccessibilityMouseSetting -MouseKeysShortcut 'Disabled'

# --- --- Only use mouse keys when Num lock is on (default: Enabled)
Set-AccessibilityMouseSetting -MouseKeysUseWhenNumLockOn 'Enabled'

# --- --- Show the mouse keys icon on the taskbar (default: Disabled)
Set-AccessibilityMouseSetting -MouseKeysShowTrayIcon 'Disabled'

# --- --- Hold the Ctrl key to speed up and Shift key to slow down (default: Disabled)
Set-AccessibilityMouseSetting -MouseKeysCtrlShiftSpeedAdjust 'Disabled'

# --- --- Mouse keys speed (default: 21 (range: 0-100))
Set-AccessibilityMouseSetting -MouseKeysSpeed 90

# --- --- Mouse keys acceleration (default: 50 (range: 0-100))
Set-AccessibilityMouseSetting -MouseKeysAcceleration 90

#endregion mouse
