#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#==============================================================================
#                                Requirements
#==============================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Win_settings_app\Accessibility'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\accessibility"



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

# Always show scrollbars
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -VisualEffectsAlwaysShowScrollbars 'Disabled'

# Animation effects
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -VisualEffectsAnimation 'Enabled'

# Dismiss notifications after this amount of time
#---------------------------------------
# default (and minimum): 5 seconds
Set-AccessibilitySetting -VisualEffectsNotificationsDuration 5

#endregion visual effects


#==========================================================
#                     Contrast themes
#==========================================================
#region contrast themes

Write-Section -Name 'Contrast themes' -SubSection

# Keyboard shorcut for contrast themes
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -ContrastThemesKeyboardShorcut 'Disabled'

#endregion contrast themes


#==========================================================
#                         Narrator
#==========================================================
#region narrator

Write-Section -Name 'Narrator' -SubSection

# Keyboard shorcut for Narrator
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -NarratorKeyboardShorcut 'Disabled'

# Automatically send diagnostic and performance data
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -NarratorAutoSendTelemetry 'Disabled'

#endregion narrator


#==========================================================
#                          Speech
#==========================================================
#region speech

Write-Section -Name 'Speech' -SubSection

# Keyboard shorcut for Voice typing
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -VoiceTypingKeyboardShorcut 'Disabled'

#endregion speech


#==========================================================
#                         Keyboard
#==========================================================
#region keyboard

Write-Section -Name 'Keyboard' -SubSection

# Use the Print screen key to open screen capture
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardPrintScreenKeyOpenScreenCapture 'Disabled'

#              Sticky keys
#=======================================

# Sticky keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardStickyKeys 'Disabled'

# Keyboard shorcut for Sticky keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardStickyKeysShorcut 'Disabled'

#              Filter keys
#=======================================

# Filter keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardFilterKeys 'Disabled'

# Keyboard shorcut for Filter keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardFilterKeysShorcut 'Disabled'

#              Toggle keys
#=======================================

# Toggle keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardToggleKeysTone 'Disabled'

# Keyboard shorcut for Toggle keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardToggleKeysToneShorcut 'Disabled'

#endregion keyboard


#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# Mouse keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -MouseKeys 'Disabled'

# Keyboard shorcut for Mouse keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -MouseKeysShorcut 'Disabled'

#endregion mouse


Stop-Transcript
