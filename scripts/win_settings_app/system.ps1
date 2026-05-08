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
#                         Display
#==========================================================
#region display

Write-Section -Name 'Display' -SubSection

#              Brightness
#=======================================

# --- Brightness (range: 0-100)
# available with a built-in display (e.g. Laptop)
Set-DisplayBrightnessSetting -Brightness 70

# --- Change brightness automatically when lighting changes (default: Enabled)
Set-DisplayBrightnessSetting -AdjustOnLightingChanges 'Disabled'

# --- Change brightness based on content
# State: Disabled | Enabled | BatteryOnly (default)
Set-DisplayBrightnessSetting -AdjustBasedOnContent 'Disabled'

#               Graphics
#=======================================

# --- Automatic super resolution (default: Enabled)
Set-DisplayGraphicsSetting -AutoSuperResolution 'Disabled'

# --- Auto HDR (default: Enabled)
Set-DisplayGraphicsSetting -AutoHDR 'Disabled'

# --- Optimizations for windowed games (default: Enabled)
Set-DisplayGraphicsSetting -WindowedGamesOptimizations 'Enabled'

# --- Hardware-accelerated GPU scheduling (default: Disabled)
Set-DisplayGraphicsSetting -GPUScheduling 'Enabled'

# --- Variable refresh rate (default: Enabled)
Set-DisplayGraphicsSetting -GamesVariableRefreshRate 'Disabled'

#endregion display

#==========================================================
#                          Sound
#==========================================================
#region sound

Write-Section -Name 'Sound' -SubSection

#          More sound settings
#=======================================

# --- Communications > when Windows detects communications activity
# State: DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent (default) | ReduceOtherSoundsBy50Percent
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

#endregion sound

#==========================================================
#                      Notifications
#==========================================================
#region notifications
# See 'scripts > telemetry_&_annoyances > notifications.ps1'
#endregion notifications

#==========================================================
#                    Power (& battery)
#==========================================================
#region power (& battery)
# See 'scripts > system_&_tweaks > power_&_Battery.ps1'
#endregion power (& battery)

#==========================================================
#                         Storage
#==========================================================
#region storage

Write-Section -Name 'Storage' -SubSection

#             Storage Sense
#=======================================

# --- Cleanup of temporary files (default: Disabled)
# Works even if the main "Storage Sense" toggle is disabled.
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -TempFilesCleanup 'Enabled' -TempFilesCleanupGPO 'NotConfigured'

# --- Automatic User content cleanup (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'

# --- --- Run Storage Sense
# State: OnLowFreeDiskSpace (default) | Daily | Weekly | Monthly
# GPO: OnLowFreeDiskSpace | Daily | Weekly | Monthly | NotConfigured
Set-StorageSenseSetting -Schedule 'OnLowFreeDiskSpace' -ScheduleGPO 'NotConfigured'

# --- --- Delete files in my recycle bin if have been there for over
# State: 0 (never) | 1 | 14 | 30 (default) | 60
# GPO: value in days (range 0-365) (never: 0) | NotConfigured
Set-StorageSenseSetting -RecycleBinRetentionDays 30 -RecycleBinRetentionDaysGPO 'NotConfigured'

# --- --- Delete files in my Downloads folder if they haven't been opened for more than
# State: 0 (never) (default) | 1 | 14 | 30 | 60
# GPO: value in days (range 0-365) (never: 0) | NotConfigured
Set-StorageSenseSetting -DownloadsFolderRetentionDays 0 -DownloadsFolderRetentionDaysGPO 'NotConfigured'

#endregion storage

#==========================================================
#                          Share
#==========================================================
#region share

Write-Section -Name 'Share' -SubSection

# --- Nearby sharing
# State: Disabled (default) | DevicesOnly | EveryoneNearby
Set-ShareSetting -NearbySharing 'Disabled'

# --- Save files I receive to
# default location: Downloads folder
#Set-ShareSetting -FileSaveLocation 'X:\MySharedFiles'

# --- Show me suggested apps in share surfaces (ads) (default: Enabled)
Set-ShareSetting -ShowSuggestedApps 'Disabled'

#endregion share

#==========================================================
#                       Multitasking
#==========================================================
#region multitasking

Write-Section -Name 'Multitasking' -SubSection

# --- Show tabs from apps when snapping or pressing Alt+Tab
# State: TwentyMostRecent | FiveMostRecent | ThreeMostRecent (default) | Disabled
# GPO: TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured
Set-MultitaskingSetting -ShowAppsTabsOnSnapAndAltTab 'ThreeMostRecent' -ShowAppsTabsOnSnapAndAltTabGPO 'NotConfigured'

# --- Title bar window shake (default: Disabled)
# GPO: prevent the setting from working but does not gray out the toggle.
Set-MultitaskingSetting -TitleBarWindowShake 'Disabled' -TitleBarWindowShakeGPO 'NotConfigured'

# --- Drop Tray (default: Enabled)
Set-MultitaskingSetting -DropTray 'Disabled'

#             Snap windows
#=======================================

# --- Snap windows (default: Enabled)
Set-SnapWindowsSetting -SnapWindows 'Enabled'

# --- When I snap a window, suggest what I can snap next to it (default: Enabled)
Set-SnapWindowsSetting -SnapSuggestions 'Enabled'

# --- Show snap layouts when I hover a window's maximize button (default: Enabled)
Set-SnapWindowsSetting -ShowLayoutOnMaxButtonHover 'Enabled'

# --- Show snap layouts when I drag a window to the top of my screen (default: Enabled)
Set-SnapWindowsSetting -ShowLayoutOnTopScreen 'Enabled'

# --- Show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab (default: Enabled)
Set-SnapWindowsSetting -ShowSnappedWindowGroup 'Enabled'

# --- When I drag a window, let me snap it without dragging all the way to the screen edge (default: Enabled)
Set-SnapWindowsSetting -SnapBeforeReachingScreenEdge 'Enabled'

#          Desktops (virtual)
#=======================================

# --- On the taskbar, show all the open windows
# State: AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnTaskbar 'CurrentDesktop'

# --- Show all open windows when I press Alt+Tab
# State: AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnAltTab 'CurrentDesktop'

#endregion multitasking

#==========================================================
#                         Advanced
#==========================================================
#region advanced

Write-Section -Name 'For developers' -SubSection

# --- End task (default: Disabled)
Set-SystemAdvancedSetting -EndTask 'Disabled'

# --- Modern Run Dialog (default: Disabled)
Set-SystemAdvancedSetting -ModernRunDialog 'Disabled'

# --- Enable long paths (default: Disabled)
Set-SystemAdvancedSetting -LongPaths 'Enabled'

# --- Enable sudo
# State: Disabled (default) | NewWindow | InputDisabled | Inline
Set-SystemAdvancedSetting -Sudo 'Disabled'

# --- Enable more agent connectors by reducing protections (default: Disabled)
Set-SystemAdvancedSetting -MoreAgentConnectors 'Disabled'

#endregion advanced

#==========================================================
#                       Troubleshoot
#==========================================================
#region troubleshoot

Write-Section -Name 'Troubleshoot' -SubSection

# --- Recommended troubleshooter preference
# State: Disabled | AskBeforeRunning (default) | AutoRunAndNotify | AutoRunSilently
Set-TroubleshooterPreference -RunMode 'Disabled'

#endregion troubleshoot

#==========================================================
#                         Recovery
#==========================================================
#region recovery

Write-Section -Name 'Recovery' -SubSection

#        Quick Machine Recovery
#=======================================

# --- Quick Machine Recovery
# default: Enabled on Home | Disabled on Pro/Enterprise
# Disabled: Also disables AutoRemediation.
Set-QuickMachineRecovery -State 'Disabled'

# --- --- Automatically check for solutions (AutoRemediation) (default: Disabled)
#   Look for solutions every (RetryIntervalMins)
# RetryIntervalMins\ value is in minutes, default: 0, range: 0-720
#   GUI values: Once (0) | 10 mins | 30 mins | 1 hour (60) | 2 hours (120) | 3 hours (180) | 6 hours (360) | 12 hours (720)
#Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryIntervalMins 0

#         Point-In-Time Restore
#=======================================

# --- Point-In-Time Restore (default: Enabled)
Set-PointInTimeRestoreSetting -PointInTimeRestore 'Disabled'

# --- --- Restore Point Frequency
# Every\ 4 hours | 6 hours | 12 hours | 16 hours | 24 hours (default)
Set-PointInTimeRestoreSetting -FrequencyHours 24

# --- --- Restore Point Retention
# 6 hours | 12 hours | 16 hours | 24 hours | 72 hours (default)
Set-PointInTimeRestoreSetting -RetentionHours 72

# --- --- Restore Point Disk Usage: Maximum usage limit (default: 2% of disk (range 2-50 GB))
Set-PointInTimeRestoreSetting -MaxDiskUsageGB 10

#endregion recovery

#==========================================================
#                  Projecting to this PC
#==========================================================
#region projecting to this PC

Write-Section -Name 'Projecting to this PC' -SubSection

# --- Projecting to this PC
# Disabled: The PC isn't discoverable unless Wireless Display app is manually launched.
Set-ProjectingToThisPC -GPO 'Disabled'

#endregion projecting to this PC

#==========================================================
#                      Remote desktop
#==========================================================
#region remote desktop

Write-Section -Name 'Remote desktop' -SubSection

# --- Remote desktop (default: Disabled)
Set-RemoteDesktopSetting -RemoteDesktop 'Disabled' -RemoteDesktopGPO 'NotConfigured'

# --- Require devices to use Network Level Authentication to connect (default: Enabled)
Set-RemoteDesktopSetting -NetworkLevelAuthentication 'Enabled'

# --- Remote desktop port (default: 3389)
#Set-RemoteDesktopSetting -PortNumber 3389

#endregion remote desktop

#==========================================================
#                        Clipboard
#==========================================================
#region clipboard

Write-Section -Name 'Clipboard' -SubSection

# --- Clipboard history (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -History 'Disabled' -HistoryGPO 'NotConfigured'

# --- Sync across your devices
# State: Disabled (default) | AutoSync | ManualSync
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -SyncAcrossDevices 'Disabled' -SyncAcrossDevicesGPO 'NotConfigured'

# --- Suggested actions (default: Enabled) | old
#Set-ClipboardSetting -SuggestedActions 'Disabled'

#endregion clipboard

#==========================================================
#                      AI Components
#==========================================================
#region ai components

Write-Section -Name 'AI Components' -SubSection

# --- Experimental Agentic Features (default: Disabled)
Set-AIComponentsSetting -AgenticFeatures 'Disabled'

#endregion ai components
