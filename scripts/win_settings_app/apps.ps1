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

Write-Output -InputObject 'Loading ''Win_settings_app\Apps'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\apps"



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

# Choose where to get apps
#---------------------------------------
# State: Anywhere (default) | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly
# GPO: Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured
Set-GeneralAppsSetting -ChooseWhereToGetApps 'Anywhere' -ChooseWhereToGetAppsGPO 'NotConfigured'

# Share across devices
#---------------------------------------
# Disabled | DevicesOnly (default) | EveryoneNearby
Set-GeneralAppsSetting -ShareAcrossDevices 'Disabled'

# Archive apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-GeneralAppsSetting -AutoArchiveApps 'Disabled' -AutoArchiveAppsGPO 'NotConfigured'

#endregion advanced app settings


#==========================================================
#                       Offline maps
#==========================================================
#region offline maps

Write-Section -Name 'Offline maps' -SubSection

# Metered connection
#---------------------------------------
# Disabled (default) | Enabled
Set-OfflineMapsSetting -DownloadOverMeteredConnection 'Disabled'

# Maps update
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-OfflineMapsSetting -AutoUpdateOnACAndWifi 'Disabled' -AutoUpdateOnACAndWifiGPO 'NotConfigured'

#endregion offline maps


#==========================================================
#                    Apps for websites
#==========================================================
#region apps for websites

Write-Section -Name 'Apps for websites' -SubSection

# Open links in an app instead of a browser
#---------------------------------------
# Disabled | NotConfigured
Set-GeneralAppsSetting -AppsOpenLinksInsteadOfBrowserGPO 'NotConfigured'

#endregion apps for websites


#==========================================================
#                          Resume
#==========================================================
#region resume

Write-Section -Name 'Resume' -SubSection

# Resume
#---------------------------------------
# Disabled | Enabled (default)
Set-GeneralAppsSetting -AppsResume 'Disabled'

#endregion resume


Stop-Transcript
