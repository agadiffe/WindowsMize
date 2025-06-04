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

Write-Output -InputObject 'Loading ''Win_settings_app\System'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

$WindowsMizeModulesNames = @(
    'optional_features'
    'system'
)
Import-Module -Name $WindowsMizeModulesNames.ForEach({ "$PSScriptRoot\..\..\src\modules\settings_app\$_" })



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                    System
#==============================================================================

Write-Section -Name 'Windows Settings App - System'

#==========================================================
#                         Display
#==========================================================
#region display

Write-Section -Name 'Display' -SubSection

#              Brightness
#=======================================

# Brightness
#---------------------------------------
# available with a built-in display (e.g. Laptop)
# range: 0-100
Set-DisplayBrightnessSetting -Brightness 70

# Change brightness automatically when lighting changes
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayBrightnessSetting -AdjustOnLightingChanges 'Disabled'

# Change brightness based on content
#---------------------------------------
# Disabled | Enabled | BatteryOnly (default)
Set-DisplayBrightnessSetting -AdjustBasedOnContent 'Disabled'

#               Graphics
#=======================================

# Optimizations for windowed games
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -WindowedGamesOptimizations 'Disabled'

# Auto HDR
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -AutoHDR 'Disabled'

# Hardware-accelerated GPU scheduling
#---------------------------------------
# Disabled (default) | Enabled
Set-DisplayGraphicsSetting -GPUScheduling 'Enabled'

# Variable refresh rate
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -GamesVariableRefreshRate 'Disabled'

#endregion display


#==========================================================
#                          Sound
#==========================================================
#region sound

Write-Section -Name 'Sound' -SubSection

#          More sound settings
#=======================================

# Communications > when Windows detects communications activity
#---------------------------------------
# DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent (default) | ReduceOtherSoundsBy50Percent
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

#endregion sound


#==========================================================
#                      Notifications
#==========================================================
#region notifications

Write-Section -Name 'Notifications' -SubSection

#             Notifications
#=======================================

# Notifications
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

# Allow notifications to play sounds
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -PlaySounds 'Disabled'

# Show notifications on the lock screen
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -ShowOnLockScreen 'Disabled' -ShowOnLockScreenGPO 'NotConfigured'

# Show reminders and incoming VoIP calls on the lock screen
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -ShowRemindersAndIncomingCallsOnLockScreen 'Disabled'

# Show notifications bell icon
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -ShowBellIcon 'Disabled'

#  Notifs from apps and other senders
#=======================================

$SendersNotifs = @(
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
# State: Disabled | Enabled
Set-NotificationsSetting -AppsAndOtherSenders $SendersNotifs -State 'Disabled'

#          Additional settings
#=======================================

# Show the Windows welcome experience after updates and when signed in to show what's new and suggested
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -ShowWelcomeExperience 'Disabled' -ShowWelcomeExperienceGPO 'NotConfigured'

# Suggest ways to get the most out of Windows and finish setting up this device
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -SuggestWaysToFinishConfig 'Disabled'

# Get tips and suggestions when using Windows
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -TipsAndSuggestions 'Disabled' -TipsAndSuggestionsGPO 'NotConfigured'

#endregion notifications


#==========================================================
#                    Power (& battery)
#==========================================================
#region power (& battery)

Write-Section -Name 'Power (& battery)' -SubSection

# Power Mode
#---------------------------------------
# Available only when using the Balanced power plan.
# Applies only to the active power state (e.g. Laptop: PluggedIn or OnBattery).
# BestPowerEfficiency | Balanced (default) | BestPerformance
Set-PowerSetting -PowerMode 'Balanced'

# Screen, sleep, & hibernate timeouts
#=======================================

# Turn my screen off after
# Make my device sleep after
# Make my device hibernate after
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# PowerState: Screen | Sleep | Hibernate
# Timeout: value in minutes | never: 0

Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Sleep'     -Timeout 10
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Hibernate' -Timeout 60

Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Sleep'     -Timeout 5
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Hibernate' -Timeout 30

#             Energy saver
#=======================================

# Always use energy saver
#---------------------------------------
# Disabled (default) | Enabled
Set-EnergySaverSetting -AlwaysOn 'Disabled'

# Turn energy saver on automatically when battery level is at
#---------------------------------------
# default: 30 | never: 0 | always: 100
Set-EnergySaverSetting -TurnOnAtBatteryLevel 30

# Lower screen brightness when using energy saver
#---------------------------------------
# If you use a custom value and turn off the feature in the GUI,
# when you turn it back on, the default value will be used.
# Enabled: 70 (default) (range 0-99) | Disabled: 100
Set-EnergySaverSetting -LowerBrightness 70

#  Lid, power & sleep button controls
#=======================================

# Pressing the power button will make my PC
# Pressing the sleep button will make my PC
# Closing the lid will make my PC
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# ButtonControls: PowerButton | SleepButton | LidClose
# Action: DoNothing | Sleep (default) | Hibernate | ShutDown | DisplayOff

Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'LidClose'    -Action 'Sleep'

Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'LidClose'    -Action 'Sleep'

#endregion power (& battery)


#==========================================================
#                         Storage
#==========================================================
#region storage

Write-Section -Name 'Storage' -SubSection

#             Storage Sense
#=======================================

# Automatic User content cleanup
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'

# Cleanup of temporary files
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -CleanupTempFiles 'Enabled' -CleanupTempFilesGPO 'NotConfigured'

#endregion storage


#==========================================================
#                      Nearby sharing
#==========================================================
#region nearby sharing

Write-Section -Name 'Nearby sharing' -SubSection

# Nearby sharing
#---------------------------------------
# Disabled (default) | DevicesOnly | EveryoneNearby
Set-NearbySharingSetting -NearbySharing 'Disabled'

# Save files I receive to
#---------------------------------------
# default location: Downloads folder
#Set-NearbySharingSetting -FileSaveLocation 'X:\MySharedFiles'

#endregion nearby sharing


#==========================================================
#                       Multitasking
#==========================================================
#region multitasking

Write-Section -Name 'Multitasking' -SubSection

# Show tabs from apps when snapping or pressing Alt+Tab
#---------------------------------------
# State: TwentyMostRecent | FiveMostRecent | ThreeMostRecent (default) | Disabled
# GPO: TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured
Set-MultitaskingSetting -ShowAppsTabsOnSnapAndAltTab 'ThreeMostRecent' -ShowAppsTabsOnSnapAndAltTabGPO 'NotConfigured'

# Title bar window shake
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-MultitaskingSetting -TitleBarWindowShake 'Disabled' -TitleBarWindowShakeGPO 'NotConfigured'

#             Snap windows
#=======================================

# Snap windows
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapWindows 'Enabled'

# When I snap a window, suggest what I can snap next to it
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapSuggestions 'Enabled'

# Show snap layouts when I hover a window's maximize button
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowLayoutOnMaxButtonHover 'Enabled'

# Show snap layouts when I drag a window to the top of my screen
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowLayoutOnTopScreen 'Enabled'

# Show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowSnappedWindowGroup 'Enabled'

# When I drag a window, let me snap it without dragging all the way to the screen edge
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapBeforeReachingScreenEdge 'Enabled'

#          Desktops (virtual)
#=======================================

# On the taskbar, show all the open windows
#---------------------------------------
# AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnTaskbar 'CurrentDesktop'

# Show all open windows when I press Alt+Tab
#---------------------------------------
# AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnAltTab 'CurrentDesktop'

#endregion multitasking


#==========================================================
#                      For developers
#==========================================================
#region for developers

Write-Section -Name 'For developers' -SubSection

# End task
#---------------------------------------
# Disabled (default) | Enabled
Set-ForDevelopersSetting -EndTask 'Disabled'

# Enable sudo
#---------------------------------------
# Disabled (default) | NewWindow | InputDisabled | Inline
Set-ForDevelopersSetting -Sudo 'Disabled'

#endregion for developers


#==========================================================
#                       Troubleshoot
#==========================================================
#region troubleshoot

Write-Section -Name 'Troubleshoot' -SubSection

# Recommended troubleshooter preference
#---------------------------------------
# Disabled | AskBeforeRunning (default) | AutoRunAndNotify | AutoRunSilently
Set-TroubleshooterPreference -Value 'Disabled'

#endregion troubleshoot


#==========================================================
#                  Projecting to this PC
#==========================================================
#region projecting to this PC

Write-Section -Name 'Projecting to this PC' -SubSection

# Projecting to this PC
#---------------------------------------
# Disabled: The PC isn't discoverable unless Wireless Display app is manually launched.
# Disabled | NotConfigured
Set-ProjectingToThisPC -GPO 'Disabled'

#endregion projecting to this PC


#==========================================================
#                      Remote desktop
#==========================================================
#region remote desktop

Write-Section -Name 'Remote desktop' -SubSection

# Remote desktop
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-RemoteDesktopSetting -RemoteDesktop 'Disabled' -RemoteDesktopGPO 'NotConfigured'

# Require devices to use Network Level Authentication to connect
#---------------------------------------
# Disabled | Enabled (default)
Set-RemoteDesktopSetting -NetworkLevelAuthentication 'Enabled'

# Remote desktop port
#---------------------------------------
# default: 3389
#Set-RemoteDesktopSetting -PortNumber 3389

#endregion remote desktop


#==========================================================
#                        Clipboard
#==========================================================
#region clipboard

Write-Section -Name 'Clipboard' -SubSection

# Clipboard history
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -History 'Disabled' -HistoryGPO 'NotConfigured'

# Sync across your devices
#---------------------------------------
# State: Disabled (default) | AutoSync | ManualSync
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -SyncAcrossDevices 'Disabled' -SyncAcrossDevicesGPO 'NotConfigured'

# Suggested actions | deprecated
#---------------------------------------
# Disabled | Enabled (default)
Set-ClipboardSetting -SuggestedActions 'Disabled'

#endregion clipboard


#==========================================================
#                    Optional features
#==========================================================
#region optional features

Write-Section -Name 'Optional features' -SubSection

Export-InstalledWindowsCapabilitiesNames
Export-EnabledWindowsOptionalFeaturesNames

$OptionalFeatures = @(
    # Features
    #-----------------
    'ExtendedThemeContent'
    'FacialRecognitionWindowsHello'
    'InternetExplorerMode'
    'MathRecognizer'
    'NotepadSystem'
    'OneSync'
    'OpenSSHClient'
    'PrintManagement'
    'StepsRecorder'
    'WMIC'
    'VBScript'
    'WindowsFaxAndScan'
    'WindowsMediaPlayerLegacy'
    'WindowsPowerShellISE'
    'WordPad'
    'XpsViewer'

    # More Windows features
    #-----------------
    'InternetPrintingClient'
    'MediaFeatures'
    'MicrosoftXpsDocumentWriter'
    'NetFramework48TcpPortSharing'
    'RemoteDesktopConnection'
    'RemoteDiffCompressionApiSupport'
    'SmbDirect'
    'WindowsPowerShell2'
    'WindowsRecall'
    'WorkFoldersClient'
)
$OptionalFeatures | Remove-PreinstalledOptionalFeature

#endregion optional features


Stop-Transcript
