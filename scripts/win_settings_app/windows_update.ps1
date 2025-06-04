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

Write-Output -InputObject 'Loading ''Win_settings_app\Windows_update'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\windows_update"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                Windows Update
#==============================================================================

Write-Section -Name 'Windows Settings App - Windows Update'

# Get the latest updates as soon as they are available
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-WinUpdateSetting -GetLatestAsSoonAsAvailable 'Disabled' -GetLatestAsSoonAsAvailableGPO 'NotConfigured'

# Pause updates
#---------------------------------------
# Disabled | NotConfigured
Set-WinUpdateSetting -PauseUpdatesGPO 'NotConfigured'

#           Advanced options
#=======================================

# Receive updates for other Microsoft products
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Enabled | NotConfigured
Set-WinUpdateSetting -UpdateOtherMicrosoftProducts 'Enabled' -UpdateOtherMicrosoftProductsGPO 'NotConfigured'

# Get me up to date (restart as soon as possible)
#---------------------------------------
# Disabled (default) | Enabled
Set-WinUpdateSetting -GetMeUpToDate 'Disabled'

# Download updates over metered connections
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-WinUpdateSetting -DownloadOverMeteredConnections 'Disabled' -DownloadOverMeteredConnectionsGPO 'NotConfigured'

# Notify me when a restart is required to finish updating
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled (also disable 'Get me up to date') | NotConfigured
Set-WinUpdateSetting -RestartNotification 'Enabled' -RestartNotificationGPO 'NotConfigured'

# Active hours
#---------------------------------------
# State: Automatically (default) | Manually
# GPO: Enabled | NotConfigured
# ActiveHoursStart/ActiveHoursEnd: value in 24H clock format (range 0-23)
#   Max range is 18 hours from the active hours start time.

#Set-WinUpdateSetting -ActiveHoursMode 'Automatically' -ActiveHoursGPO 'NotConfigured'
Set-WinUpdateSetting -ActiveHoursMode 'Manually' -ActiveHoursGPO 'NotConfigured' -ActiveHoursStart 7 -ActiveHoursEnd 1

#         Delivery Optimization
#=======================================

# Allow downloads from other PCs
#---------------------------------------
# State: Disabled | LocalNetwork (default) | InternetAndLocalNetwork
# GPO: Disabled | LocalNetwork | InternetAndLocalNetwork | NotConfigured
Set-WinUpdateSetting -DeliveryOptimization 'Disabled' -DeliveryOptimizationGPO 'NotConfigured'

#        Windows Insider Program
#=======================================

# Setting page visibility
#---------------------------------------
# Disabled | Enabled (default)
Set-WinUpdateSetting -InsiderProgramPageVisibility 'Disabled'


Stop-Transcript
