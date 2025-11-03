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
Write-Output -InputObject 'Loading ''Win_settings_app\Windows_update'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\windows_update"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                Windows Update
#==============================================================================

Write-Section -Name 'Windows Settings App - Windows Update'

# --- Get the latest updates as soon as they are available (default: Disabled)
Set-WinUpdateSetting -GetLatestAsSoonAsAvailable 'Disabled' -GetLatestAsSoonAsAvailableGPO 'NotConfigured'

# --- Pause updates
Set-WinUpdateSetting -PauseUpdatesGPO 'NotConfigured'

#           Advanced options
#=======================================

# --- Receive updates for other Microsoft products (default: Enabled)
# GPO: Enabled | NotConfigured
Set-WinUpdateSetting -UpdateOtherMicrosoftProducts 'Enabled' -UpdateOtherMicrosoftProductsGPO 'NotConfigured'

# --- Get me up to date (restart as soon as possible) (default: Disabled)
Set-WinUpdateSetting -GetMeUpToDate 'Disabled'

# --- Download updates over metered connections (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-WinUpdateSetting -DownloadOverMeteredConnections 'Disabled' -DownloadOverMeteredConnectionsGPO 'NotConfigured'

# --- Notify me when a restart is required to finish updating (default: Disabled)
# Disabled: also disable 'Get me up to date'
Set-WinUpdateSetting -RestartNotification 'Enabled' -RestartNotificationGPO 'NotConfigured'

# --- Active hours
# State: Automatically (default) | Manually
# GPO: Enabled | NotConfigured
# ActiveHoursStart/ActiveHoursEnd: value in 24H clock format (range 0-23)
#   Max range is 18 hours from the active hours start time.

#Set-WinUpdateSetting -ActiveHoursMode 'Automatically' -ActiveHoursGPO 'NotConfigured'
Set-WinUpdateSetting -ActiveHoursMode 'Manually' -ActiveHoursStart 7 -ActiveHoursEnd 1
#Set-WinUpdateSetting -ActiveHoursGPO 'Enabled' -ActiveHoursStart 7 -ActiveHoursEnd 1

#         Delivery Optimization
#=======================================

# --- Allow downloads from other PCs
# State: Disabled | LocalNetwork (default) | InternetAndLocalNetwork
# GPO: Disabled | LocalNetwork | InternetAndLocalNetwork | NotConfigured
Set-WinUpdateSetting -DeliveryOptimization 'Disabled' -DeliveryOptimizationGPO 'NotConfigured'

#        Windows Insider Program
#=======================================

# --- Setting page visibility (default: Enabled)
Set-WinUpdateSetting -InsiderProgramPageVisibility 'Disabled'
