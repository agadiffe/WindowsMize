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

Write-Output -InputObject 'Loading ''Win_settings_app\Apps'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\apps"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                     Apps
#==============================================================================

Write-Section -Name 'Windows Settings App - Apps'

#==========================================================
#                  Advanced app settings
#==========================================================
#region advanced app settings

Write-Section -Name 'Advanced app settings' -SubSection

# --- Choose where to get apps (default: Anywhere)
# State: Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly # GPO: State + NotConfigured
Set-GeneralAppsSetting -ChooseWhereToGetApps 'Anywhere' -ChooseWhereToGetAppsGPO 'NotConfigured'

# --- Share across devices (default: DevicesOnly)
# State: Disabled | DevicesOnly | EveryoneNearby
Set-GeneralAppsSetting -ShareAcrossDevices 'Disabled'

# --- Archive apps (default: Enabled)
Set-GeneralAppsSetting -AutoArchiveApps 'Disabled' -AutoArchiveAppsGPO 'NotConfigured'

#endregion advanced app settings

#==========================================================
#                       Offline maps
#==========================================================
#region offline maps

Write-Section -Name 'Offline maps' -SubSection

# --- Metered connection (default: Disabled)
Set-OfflineMapsSetting -DownloadOverMeteredConnection 'Disabled'

# --- Maps update (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-OfflineMapsSetting -AutoUpdateOnACAndWifi 'Disabled' -AutoUpdateOnACAndWifiGPO 'NotConfigured'

#endregion offline maps

#==========================================================
#                    Apps for websites
#==========================================================
#region apps for websites

Write-Section -Name 'Apps for websites' -SubSection

# --- Open links in an app instead of a browser
Set-GeneralAppsSetting -AppsOpenLinksInsteadOfBrowserGPO 'NotConfigured'

#endregion apps for websites

#==========================================================
#                          Resume
#==========================================================
#region resume

Write-Section -Name 'Resume' -SubSection

# --- Resume (default: Enabled)
Set-GeneralAppsSetting -AppsResume 'Disabled' -AppsResumeGPO 'NotConfigured'

#endregion resume


Stop-Transcript
