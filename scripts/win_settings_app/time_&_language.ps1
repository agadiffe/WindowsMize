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

Write-Output -InputObject 'Loading ''Win_settings_app\Time_&_language'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\time_&_language"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                               Time & language
#==============================================================================

Write-Section -Name 'Windows Settings App - Time & language'

#==========================================================
#                       Date & time
#==========================================================
#region date & time

Write-Section -Name 'Date & time' -SubSection

# Set time zone automatically
#---------------------------------------
# Already disabled if location permission is off.
# Disabled | Enabled (default)
Set-DateAndTimeSetting -AutoTimeZone 'Disabled'

# Set time automatically
#---------------------------------------
# Disabled | Enabled (default)
Set-DateAndTimeSetting -AutoTime 'Enabled'

# Show time and date in the System tray
#---------------------------------------
# Disabled | Enabled (default)
Set-DateAndTimeSetting -ShowInSystemTray 'Enabled'

# Show abbreviated time and date
#---------------------------------------
# Disabled (default) | Enabled
Set-DateAndTimeSetting -ShowAbbreviatedValue 'Disabled'

# Show seconds in system tray clock (uses more power)
#---------------------------------------
# Disabled (default) | Enabled
Set-DateAndTimeSetting -ShowSecondsInSystemClock 'Disabled'

# Internet time (NTP server)
#---------------------------------------
# Windows (default) | NistGov | PoolNtpOrg
Set-DateAndTimeSetting -TimeServer 'Windows'

#endregion date & time


#==========================================================
#                    Language & region
#==========================================================
#region language & region

Write-Section -Name 'Language & region' -SubSection

#          Preferred Languages
#=======================================

# Language Options
#---------------------------------------
# Windows 11 only.
# Basic typing, Handwriting, OCR, Text-To-Speech, Speech recognition
#Remove-LanguageFeatures

#            Regional format
#=======================================

# First day of week
#---------------------------------------
# Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
Set-LanguageAndRegionSetting -FirstDayOfWeek 'Monday'

# Short date
#---------------------------------------
# e.g. 05-Apr-42: dd-MMM-yy
Set-LanguageAndRegionSetting -ShortDateFormat 'dd-MMM-yy'

#   Administrative language settings
#=======================================

# Language for non-Unicode programs:
#   Beta: Use Unicode UTF-8 for worldwide language support
#---------------------------------------
# Disabled (default) | Enabled
Set-LanguageAndRegionSetting -Utf8ForNonUnicodePrograms 'Enabled'

#endregion language & region


#==========================================================
#                          Typing
#==========================================================
#region typing

Write-Section -Name 'Typing' -SubSection

# Show text suggestions when typing on the software keyboard
#---------------------------------------
# Only works on Windows 10 ? (setting not present on Windows 11)
# Disabled (default) | Enabled
Set-TypingSetting -ShowTextSuggestionsOnSoftwareKeyboard 'Disabled'

# Show text suggestions when typing on the physical keyboard
#---------------------------------------
# Disabled (default) | Enabled
Set-TypingSetting -ShowTextSuggestionsOnPhysicalKeyboard 'Disabled'

# Multilingual text suggestions
#---------------------------------------
# Disabled (default) | Enabled
Set-TypingSetting -MultilingualTextSuggestions 'Disabled'

# Autocorrect misspelled words
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -AutocorrectMisspelledWords 'Disabled'

# Highlight misspelled words
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -HighlightMisspelledWords 'Disabled'

# Typing insights
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -TypingAndCorrectionHistory 'Disabled'

#      Advanced keyboard settings
#=======================================

# Let me use a different input method for each app window
#---------------------------------------
# Disabled (default) | Enabled
Set-TypingSetting -UseDifferentInputMethodForEachApp 'Disabled'

# Language bar options
#---------------------------------------
# Shown if more than one language and/or keyboard layout are installed.
# FloatingOnDesktop | DockedInTaskbar (default) | Hidden
Set-TypingSetting -LanguageBar 'DockedInTaskbar'

# Input language hot keys
#---------------------------------------
# 'Win + Space' is not affected by the follwing settings.

# Switch Input Language
# NotAssigned | CtrlShift | LeftAltShift (default) | GraveAccent
Set-TypingSetting -SwitchInputLanguageHotKey 'NotAssigned'

# Switch Keyboard Layout
# NotAssigned | CtrlShift (default) | LeftAltShift | GraveAccent
Set-TypingSetting -SwitchKeyboardLayoutHotKey 'NotAssigned'

#endregion typing


Stop-Transcript
