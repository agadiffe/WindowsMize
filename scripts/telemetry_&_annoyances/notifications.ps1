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

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)
Write-Output -InputObject 'Loading ''Win_settings_app\System'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\system"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                    System
#==============================================================================

Write-Section -Name 'Windows Settings App - System'

#==========================================================
#                      Notifications
#==========================================================

Write-Section -Name 'Notifications' -SubSection

#             Notifications
#=======================================

# --- Notifications (default: Enabled)
Set-NotificationsSetting -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

# --- Allow notifications to play sounds (default: Enabled)
Set-NotificationsSetting -PlaySounds 'Disabled'

# --- Show notifications on the lock screen (default: Enabled)
Set-NotificationsSetting -ShowOnLockScreen 'Disabled' -ShowOnLockScreenGPO 'NotConfigured'

# --- Show reminders and incoming VoIP calls on the lock screen (default: Enabled)
Set-NotificationsSetting -ShowRemindersAndIncomingCallsOnLockScreen 'Disabled'

# --- Show notifications bell icon (default: Enabled)
Set-NotificationsSetting -ShowBellIcon 'Disabled'

#  Notifs from apps and other senders
#=======================================

$SenderNotifs = @(
    'Apps'
    'Autoplay'
    'BatterySaver'
    'MicrosoftStore'
    'NotificationSuggestions'
    'PrintNotification'
    'Settings'
    'StartupAppNotification'
    'Suggested'
    'WindowsBackup'
)
Set-NotificationsSetting -AppsAndOtherSenders $SenderNotifs -State 'Disabled'

#          Additional settings
#=======================================

# --- Show the Windows welcome experience after updates and when signed in to show what's new and suggested (default: Enabled)
Set-NotificationsSetting -ShowWelcomeExperience 'Disabled' -ShowWelcomeExperienceGPO 'NotConfigured'

# --- Suggest ways to get the most out of Windows and finish setting up this device (default: Enabled)
Set-NotificationsSetting -SuggestWaysToFinishConfig 'Disabled'

# --- Get tips and suggestions when using Windows (default: Enabled)
Set-NotificationsSetting -TipsAndSuggestions 'Disabled' -TipsAndSuggestionsGPO 'NotConfigured'

#   Indicators from keyboard actions
#=======================================

# --- Position of on-screen indicators
# State: BottomCenter (default) | TopLeft | TopCenter
Set-NotificationsSetting -ScreenIndicatorsPosition 'BottomCenter'
