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
# See "scripts > win_settings_app > notifications.ps1"
#endregion notifications

#==========================================================
#                    Power (& battery)
#==========================================================
#region power (& battery)
# See "scripts > power_&_Battery.ps1"
#endregion power (& battery)

#==========================================================
#                         Storage
#==========================================================
#region storage

Write-Section -Name 'Storage' -SubSection

#             Storage Sense
#=======================================

# --- Automatic User content cleanup (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'

# --- Cleanup of temporary files (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -CleanupTempFiles 'Enabled' -CleanupTempFilesGPO 'NotConfigured'

#endregion storage

#==========================================================
#                      Nearby sharing
#==========================================================
#region nearby sharing

Write-Section -Name 'Nearby sharing' -SubSection

# --- Drag Tray (default: Enabled)
Set-NearbySharingSetting -DragTray 'Disabled'

# --- Nearby sharing
# State: Disabled (default) | DevicesOnly | EveryoneNearby
Set-NearbySharingSetting -NearbySharing 'Disabled'

# --- Save files I receive to
# default location: Downloads folder
#Set-NearbySharingSetting -FileSaveLocation 'X:\MySharedFiles'

#endregion nearby sharing

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
Set-MultitaskingSetting -TitleBarWindowShake 'Disabled' -TitleBarWindowShakeGPO 'NotConfigured'

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
Set-TroubleshooterPreference -Value 'Disabled'

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
# Disabled: Also disable AutoRemediation.
Set-QuickMachineRecovery -State 'Enabled'

# --- --- Automatically check for solutions (AutoRemediation) (default: Disabled)
#   Look for solutions every (RetryInterval)
# RetryInterval\ value are in minutes, default: 0, range: 0-720
#   GUI values: Once (0) | 10 mins | 30 mins | 1 hour (60) | 2 hours (120) | 3 hours (180) | 6 hours (360) | 12 hours (720)
#Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryInterval 0

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
