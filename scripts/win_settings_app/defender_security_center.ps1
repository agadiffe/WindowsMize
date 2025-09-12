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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\helper_functions\general"

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\win_settings_app_$ScriptFileName.log"

Write-Output -InputObject 'Loading ''Win_settings_app\Defender_security_center'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\defender_security_center"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

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

# --- Cloud-delivered protection
# State: Disabled | Basic | Advanced (default)
# GPO: Disabled | Basic | Advanced | NotConfigured
Set-DefenderSetting -CloudDeliveredProtection 'Disabled' -CloudDeliveredProtectionGPO 'NotConfigured'

# --- Automatic sample submission
# State: NeverSend | AlwaysPrompt | SendSafeSamples (default) | SendAllSamples
# GPO: NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured
Set-DefenderSetting -AutoSampleSubmission 'NeverSend' -AutoSampleSubmissionGPO 'NotConfigured'

#endregion virus & threat protection

#==========================================================
#                    Account Protection
#==========================================================
#region account protection

Write-Section -Name 'Account Protection' -SubSection

# --- Administrator Protection (default: Disabled)
Set-DefenderSetting -AdminProtection 'Disabled'

#endregion account protection

#==========================================================
#                  App & browser control
#==========================================================
#region app & browser control

Write-Section -Name 'App & browser control' -SubSection

#      Reputation-based protection
#=======================================

# --- Check apps and files (default: Enabled)
# GPO: Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -CheckAppsAndFiles 'Disabled' -CheckAppsAndFilesGPO 'NotConfigured'

# --- Smartscreen for Microsoft Edge (default: Enabled)
# GPO: Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -SmartScreenForEdge 'Disabled' -SmartScreenForEdgeGPO 'NotConfigured'

# --- Phishing protection
# GPO: Disabled | Warn | Block | NotConfigured
Set-DefenderSetting -PhishingProtectionGPO 'Disabled'

# --- Potentially unwanted app blocking
# State: Disabled | Enabled (default) | AuditMode
# GPO: Disabled | Enabled | AuditMode | NotConfigured
Set-DefenderSetting -UnwantedAppBlocking 'Disabled' -UnwantedAppBlockingGPO 'NotConfigured'

# --- Smartscreen for Microsoft Store apps (default: Enabled)
Set-DefenderSetting -SmartScreenForStoreApps 'Disabled'

#endregion app & browser control

#==========================================================
#                      Notifications
#==========================================================
#region notifications

Write-Section -Name 'Notifications' -SubSection

#       Virus & threat protection
#=======================================

# --- Get informational notifications (i.e. All notifs) (default: Enabled)
#Set-DefenderNotificationsSetting -VirusAndThreatAllNotifs 'Enabled'

# --- --- Recent activity and scan results (default: Enabled)
Set-DefenderNotificationsSetting -RecentActivityAndScanResults 'Disabled'

# --- --- Threats found, but no immediate action is needed (default: Enabled)
Set-DefenderNotificationsSetting -ThreatsFoundNoActionNeeded 'Enabled'

# --- --- Files or activities are blocked (default: Enabled)
Set-DefenderNotificationsSetting -FilesOrActivitiesBlocked 'Enabled'

#          Account protection
#=======================================

# --- Get account protection notifications (i.e. All notifs) (default: Enabled)
#Set-DefenderNotificationsSetting -AccountAllNotifs 'Enabled'

# --- --- Problems with Windows Hello (default: Enabled)
Set-DefenderNotificationsSetting -WindowsHelloProblems 'Enabled'

# --- --- Problems with Dynamic lock (default: Enabled)
Set-DefenderNotificationsSetting -DynamicLockProblems 'Enabled'

#endregion notifications

#==========================================================
#                      Miscellaneous
#==========================================================
#region miscellaneous

Write-Section -Name 'Miscellaneous' -SubSection

# --- Watson events report
# GPO: Disabled | NotConfigured
Set-DefenderSetting -WatsonEventsReportGPO 'Disabled'

#endregion miscellaneous


Stop-Transcript
