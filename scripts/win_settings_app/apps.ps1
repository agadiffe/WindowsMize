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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\apps"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

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

# --- Choose where to get apps
# State: Anywhere (default) | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly
# GPO: Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured
Set-GeneralAppsSetting -ChooseWhereToGetApps 'Anywhere' -ChooseWhereToGetAppsGPO 'NotConfigured'

# --- Share across devices
# State: Disabled | DevicesOnly (default) | EveryoneNearby
Set-GeneralAppsSetting -ShareAcrossDevices 'Disabled'

# --- Archive apps (default: Enabled)
Set-GeneralAppsSetting -AutoArchiveApps 'Disabled' -AutoArchiveAppsGPO 'NotConfigured'

#endregion advanced app settings

#==========================================================
#                         Actions
#==========================================================
#region actions

# --- App actions (default: Enabled)
$AppActionsSettings = @{
    M365Copilot = 'Disabled'
    MSOffice    = 'Disabled'
    MSTeams     = 'Disabled'
    Paint       = 'Disabled'
    Photos      = 'Disabled'
}
#Set-AppActions -Setting $AppActionsSettings

#endregion actions

#==========================================================
#                       Offline maps
#==========================================================
#region offline maps

Write-Section -Name 'Offline maps' -SubSection

# --- Metered connection (default: Disabled) | old
Set-OfflineMapsSetting -DownloadOverMeteredConnection 'Disabled'

# --- Maps update (default: Enabled) | old
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
