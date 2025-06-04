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

Write-Output -InputObject 'Loading ''Win_settings_app\Defender_security_center'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\defender_security_center"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                       Windows Security (aka Defender)
#==============================================================================

Write-Section -Name 'Windows Settings App - Windows Security (aka Defender)'

#==========================================================
#                Virus & threat protection
#==========================================================
#region virus & threat protection

Write-Section -Name 'Virus & threat protection' -SubSection

#               Settings
#=======================================

# Cloud-delivered protection
#---------------------------------------
# State: Disabled | Basic | Advanced (default)
# GPO: Disabled | Basic | Advanced | NotConfigured
Set-DefenderSetting -CloudDeliveredProtection 'Disabled' -CloudDeliveredProtectionGPO 'NotConfigured'

# Automatic sample submission
#---------------------------------------
# State: NeverSend | AlwaysPrompt | SendSafeSamples (default) | SendAllSamples
# GPO: NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured
Set-DefenderSetting -AutoSampleSubmission 'NeverSend' -AutoSampleSubmissionGPO 'NotConfigured'

#endregion virus & threat protection


#==========================================================
#                    Account Protection
#==========================================================
#region account protection

Write-Section -Name 'Account Protection' -SubSection

# Administrator Protection
#---------------------------------------
# Disabled (default) | Enabled
Set-DefenderSetting -AdminProtection 'Disabled'

#endregion account protection


#==========================================================
#                  App & browser control
#==========================================================
#region app & browser control

Write-Section -Name 'App & browser control' -SubSection

#      Reputation-based protection
#=======================================

# Check apps and files
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -CheckAppsAndFiles 'Disabled' -CheckAppsAndFilesGPO 'NotConfigured'

# Smartscreen for Microsoft Edge
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -SmartScreenForEdge 'Disabled' -SmartScreenForEdgeGPO 'NotConfigured'

# Phishing protection
#---------------------------------------
# Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -PhishingProtectionGPO 'Disabled'

# Potentially unwanted app blocking
#---------------------------------------
# State: Disabled | Enabled (default) | AuditMode
# GPO: Disabled | Enabled | AuditMode | NotConfigured
Set-DefenderSetting -UnwantedAppBlocking 'Disabled' -UnwantedAppBlockingGPO 'NotConfigured'

# Smartscreen for Microsoft Store apps
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderSetting -SmartScreenForStoreApps 'Disabled'

#endregion app & browser control


#==========================================================
#                      Notifications
#==========================================================
#region notifications

Write-Section -Name 'Notifications' -SubSection

#       Virus & threat protection
#=======================================

# Get informational notifications:
#   Recent activity and scan results
#   Threats found, but no immediate action is needed
#   Files or activities are blocked
#---------------------------------------
# Disabled | Enabled (default)
#Set-DefenderNotificationsSetting -VirusAndThreatAllNotifs 'Enabled'

# Recent activity and scan results
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderNotificationsSetting -RecentActivityAndScanResults 'Disabled'

# Threats found, but no immediate action is needed
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderNotificationsSetting -ThreatsFoundNoActionNeeded 'Enabled'

# Files or activities are blocked
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderNotificationsSetting -FilesOrActivitiesBlocked 'Enabled'

#          Account protection
#=======================================

# Get account protection notifications:
#   Problems with Windows Hello
#   Problems with Dynamic lock
#---------------------------------------
# Disabled | Enabled (default)
#Set-DefenderNotificationsSetting -AccountAllNotifs 'Enabled'

# Problems with Windows Hello
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderNotificationsSetting -WindowsHello 'Enabled'

# Problems with Dynamic lock
#---------------------------------------
# Disabled | Enabled (default)
Set-DefenderNotificationsSetting -DynamicLock 'Enabled'

#endregion notifications


#==========================================================
#                      Miscellaneous
#==========================================================
#region miscellaneous

Write-Section -Name 'Miscellaneous' -SubSection

# Watson events report
#---------------------------------------
# Disabled | NotConfigured
Set-DefenderSetting -WatsonEventsReportGPO 'Disabled'

#endregion miscellaneous


Stop-Transcript
