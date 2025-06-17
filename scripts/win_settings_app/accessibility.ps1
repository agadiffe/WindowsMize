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

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)

Write-Output -InputObject 'Loading ''Win_settings_app\Accessibility'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\accessibility"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

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

# --- Animation effects (default: Enabled)
Set-AccessibilitySetting -VisualEffectsAnimation 'Enabled'

# --- Dismiss notifications after this amount of time (default (and minimum): 5 seconds)
Set-AccessibilitySetting -VisualEffectsNotificationsDuration 5

#endregion visual effects

#==========================================================
#                     Contrast themes
#==========================================================
#region contrast themes

Write-Section -Name 'Contrast themes' -SubSection

# --- Keyboard shorcut for contrast themes (default: Enabled)
Set-AccessibilitySetting -ContrastThemesKeyboardShorcut 'Disabled'

#endregion contrast themes

#==========================================================
#                         Narrator
#==========================================================
#region narrator

Write-Section -Name 'Narrator' -SubSection

# --- Keyboard shorcut for Narrator (default: Enabled)
Set-AccessibilitySetting -NarratorKeyboardShorcut 'Disabled'

# --- Automatically send diagnostic and performance data (default: Disabled)
Set-AccessibilitySetting -NarratorAutoSendTelemetry 'Disabled'

#endregion narrator

#==========================================================
#                          Speech
#==========================================================
#region speech

Write-Section -Name 'Speech' -SubSection

# --- Keyboard shorcut for Voice typing (default: Enabled)
Set-AccessibilitySetting -VoiceTypingKeyboardShorcut 'Disabled'

#endregion speech

#==========================================================
#                         Keyboard
#==========================================================
#region keyboard

Write-Section -Name 'Keyboard' -SubSection

# --- Use the Print screen key to open screen capture (default: Enabled)
Set-AccessibilitySetting -KeyboardPrintScreenKeyOpenScreenCapture 'Disabled'

#              Sticky keys
#=======================================

# --- Sticky keys (default: Disabled)
Set-AccessibilitySetting -KeyboardStickyKeys 'Disabled'

# --- Keyboard shorcut for Sticky keys (default: Enabled)
Set-AccessibilitySetting -KeyboardStickyKeysShorcut 'Disabled'

#              Filter keys
#=======================================

# --- Filter keys (default: Disabled)
Set-AccessibilitySetting -KeyboardFilterKeys 'Disabled'

# --- Keyboard shorcut for Filter keys (default: Enabled)
Set-AccessibilitySetting -KeyboardFilterKeysShorcut 'Disabled'

#              Toggle keys
#=======================================

# --- Toggle keys (default: Disabled)
Set-AccessibilitySetting -KeyboardToggleKeysTone 'Disabled'

# --- Keyboard shorcut for Toggle keys (default: Disabled)
Set-AccessibilitySetting -KeyboardToggleKeysToneShorcut 'Disabled'

#endregion keyboard

#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# --- Mouse keys (default: Disabled)
Set-AccessibilitySetting -MouseKeys 'Disabled'

# --- Keyboard shorcut for Mouse keys (default: Enabled)
Set-AccessibilitySetting -MouseKeysShorcut 'Disabled'

#endregion mouse


Stop-Transcript
