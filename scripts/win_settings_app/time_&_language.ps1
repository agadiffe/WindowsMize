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

Write-Output -InputObject 'Loading ''Win_settings_app\Time_&_language'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\time_&_language"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

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

# --- Set time zone automatically (default: Enabled)
# Already disabled if location permission is off.
Set-DateAndTimeSetting -AutoTimeZone 'Disabled'

# --- Set time automatically (default: Enabled)
Set-DateAndTimeSetting -AutoTime 'Enabled'

# --- Show time and date in the System tray (default: Enabled)
Set-DateAndTimeSetting -ShowInSystemTray 'Enabled'

# --- Show abbreviated time and date (default: Disabled)
Set-DateAndTimeSetting -ShowAbbreviatedValue 'Disabled'

# --- Show seconds in system tray clock (uses more power) (default: Disabled)
Set-DateAndTimeSetting -ShowSecondsInSystemClock 'Disabled'

# --- Internet time (NTP server) (default: Windows)
# State: Windows | NistGov | PoolNtpOrg
Set-DateAndTimeSetting -TimeServer 'Windows'

#endregion date & time

#==========================================================
#                    Language & region
#==========================================================
#region language & region

Write-Section -Name 'Language & region' -SubSection

#          Preferred Languages
#=======================================

# --- Language Options
# Windows 11 only.
# Basic typing, Handwriting, OCR, Text-To-Speech, Speech recognition
#Remove-LanguageFeatures

#            Regional format
#=======================================

# --- First day of week
# Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
Set-LanguageAndRegionSetting -FirstDayOfWeek 'Monday'

# --- Short date
# e.g. 05-Apr-42: dd-MMM-yy
Set-LanguageAndRegionSetting -ShortDateFormat 'dd-MMM-yy'

#   Administrative language settings
#=======================================

# --- Language for non-Unicode programs:
#   Beta: Use Unicode UTF-8 for worldwide language support (default: Disabled)
Set-LanguageAndRegionSetting -Utf8ForNonUnicodePrograms 'Enabled'

#endregion language & region

#==========================================================
#                          Typing
#==========================================================
#region typing

Write-Section -Name 'Typing' -SubSection

# --- Show text suggestions when typing on the software keyboard (default: Disabled)
# Only works on Windows 10 ? (setting not present on Windows 11)
Set-TypingSetting -ShowTextSuggestionsOnSoftwareKeyboard 'Disabled'

# --- Show text suggestions when typing on the physical keyboard (default: Disabled)
Set-TypingSetting -ShowTextSuggestionsOnPhysicalKeyboard 'Disabled'

# --- Multilingual text suggestions (default: Disabled)
Set-TypingSetting -MultilingualTextSuggestions 'Disabled'

# --- Autocorrect misspelled words (default: Enabled)
Set-TypingSetting -AutocorrectMisspelledWords 'Disabled'

# --- Highlight misspelled words (default: Enabled)
Set-TypingSetting -HighlightMisspelledWords 'Disabled'

# --- Typing insights (default: Enabled)
Set-TypingSetting -TypingAndCorrectionHistory 'Disabled'

#      Advanced keyboard settings
#=======================================

# --- Let me use a different input method for each app window (default: Disabled)
Set-TypingSetting -UseDifferentInputMethodForEachApp 'Disabled'

# --- Language bar options (default: DockedInTaskbar)
# Shown if more than one language and/or keyboard layout are installed.
# State: FloatingOnDesktop | DockedInTaskbar | Hidden
Set-TypingSetting -LanguageBar 'DockedInTaskbar'

# --- Input language hot keys
# 'Win + Space' is not affected by the follwing settings.

# --- --- Switch Input Language (default: LeftAltShift)
# State: NotAssigned | CtrlShift | LeftAltShift | GraveAccent
Set-TypingSetting -SwitchInputLanguageHotKey 'NotAssigned'

# --- --- Switch Keyboard Layout (default: CtrlShift)
# State: NotAssigned | CtrlShift | LeftAltShift | GraveAccent
Set-TypingSetting -SwitchKeyboardLayoutHotKey 'NotAssigned'

#endregion typing


Stop-Transcript
