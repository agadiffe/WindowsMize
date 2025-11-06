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
Write-Output -InputObject 'Loading ''Win_settings_app\Privacy_&_security'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\privacy_&_security"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                              Privacy & security
#==============================================================================

Write-Section -Name 'Windows Settings App - Privacy & security'

#==========================================================
#                         Security
#==========================================================
#region security

Write-Section -Name 'Security' -SubSection

# --- Find my device (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-WinPermissionsSetting -FindMyDevice 'Disabled' -FindMyDeviceGPO 'NotConfigured'

#endregion security

#==========================================================
#                   Windows permissions
#==========================================================
#region windows permissions

Write-Section -Name 'Windows permissions' -SubSection

#                User Data
#=======================================
# aka: General / Recommendations & offers
#region user data

# --- Let apps show me personalized ads by using my advertising ID (default: Enabled)
Set-WinPermissionsSetting -AdvertisingID 'Disabled' -AdvertisingIDGPO 'NotConfigured'

# --- Let websites show me locally relevant content by accessing my language list (default: Enabled)
Set-WinPermissionsSetting -LanguageListAccess 'Disabled'

# --- Let Windows improve Start and search results by tracking app launches (default: Enabled)
Set-WinPermissionsSetting -TrackAppLaunches 'Disabled' -TrackAppLaunchesGPO 'NotConfigured'

# --- Show me suggested content in the Settings app (default: Enabled)
Set-WinPermissionsSetting -ShowAdsInSettingsApp 'Disabled' -ShowAdsInSettingsAppGPO 'NotConfigured'

# --- Show me notifications in the Settings app (default: Enabled)
Set-WinPermissionsSetting -ShowNotifsInSettingsApp 'Disabled'

# --- Activity history (default: Enabled) | old
#   Store my activity history on this device
#   Store my activity history to Microsoft
Set-WinPermissionsSetting -ActivityHistory 'Disabled' -ActivityHistoryGPO 'NotConfigured'

#endregion user data

#                  AI
#=======================================
# Recall / Speech / Typing
#region ai

# --- Recall: Save snapshots
Set-WinPermissionsSetting -RecallSnapshotsGPO 'Disabled'

# --- --- Help improve Recall snapshots filtering (default: Disabled)
Set-WinPermissionsSetting -RecallFilteringTelemetry 'Disabled'

# --- --- Recall shows a customized experience using your snapshots (default: Enabled)
Set-WinPermissionsSetting -RecallPersonalizedHomepage 'Disabled'

# --- Click to Do (default: Enabled)
Set-WinPermissionsSetting -ClickToDo 'Disabled' -ClickToDoGPO 'NotConfigured'

# --- Online speech recognition (default: Enabled)
Set-WinPermissionsSetting -SpeechRecognition 'Disabled' -SpeechRecognitionGPO 'NotConfigured'

# --- Custom inking and typing dictionary (default: Enabled)
Set-WinPermissionsSetting -InkingAndTypingPersonalization 'Disabled'

#endregion ai

#               Telemetry
#=======================================
# aka: Diagnostics & feedback
#region telemetry

# --- Diagnostic data
# State: Disabled | OnlyRequired | OptionalAndRequired (default)
# GPO: Disabled | OnlyRequired | OptionalAndRequired | NotConfigured
Set-WinPermissionsSetting -DiagnosticData 'Disabled' -DiagnosticDataGPO 'Disabled'

# --- Improve inking and typing (default: Enabled)
Set-WinPermissionsSetting -ImproveInkingAndTyping 'Disabled' -ImproveInkingAndTypingGPO 'Disabled'

# --- Tailored experiences (default: Enabled)
Set-WinPermissionsSetting -TailoredExperiences 'Disabled' -TailoredExperiencesGPO 'Disabled'

# --- View diagnostic data (default: Disabled)
Set-WinPermissionsSetting -DiagnosticDataViewer 'Disabled' -DiagnosticDataViewerGPO 'Disabled'

# --- Delete diagnostic data
Set-WinPermissionsSetting -DeleteDiagnosticDataGPO 'NotConfigured'

# --- Feedback frequency
# State: Never | Automatically (default) | Always | Daily | Weekly
Set-WinPermissionsSetting -FeedbackFrequency 'Never' -FeedbackFrequencyGPO 'Disabled'

#endregion telemetry

#                Search
#=======================================
#region search

# --- SafeSearch | old
# State: Disabled | Moderate (default) | Strict
#Set-WinPermissionsSetting -SafeSearch 'Disabled'

# --- Search history (default: Enabled)
Set-WinPermissionsSetting -SearchHistory 'Disabled'

# --- Show search highlights (default: Enabled)
Set-WinPermissionsSetting -SearchHighlights 'Disabled' -SearchHighlightsGPO 'NotConfigured'

# --- Search my accounts
#   Microsoft account (default: Enabled)
#   Work or School account (default: Enabled)
# CloudSearchGPO: disable both settings
Set-WinPermissionsSetting -CloudSearchGPO 'NotConfigured'
Set-WinPermissionsSetting -CloudSearchMicrosoftAccount 'Disabled' -CloudSearchWorkOrSchoolAccount 'Disabled'

# --- Search the contents of online files (default: Enabled)
Set-WinPermissionsSetting -CloudFileContentSearch 'Disabled'

# --- Let search apps show results (EEA only) (default: Enabled)
Set-WinPermissionsSetting -StartMenuWebSearch 'Disabled'

# --- Find my files
# State: Classic (default) | Enhanced
Set-WinPermissionsSetting -FindMyFiles 'Classic'

# --- Advanced indexing options > Index encrypted files
# GPO: Disabled | Enabled | NotConfigured
Set-WinPermissionsSetting -IndexEncryptedFilesGPO 'Disabled'

#endregion search

#endregion windows permissions

#==========================================================
#                     App permissions
#==========================================================
#region app permissions

Write-Section -Name 'App permissions' -SubSection

#                General
#=======================================
#region general

# --- Location (default: Enabled)
Set-AppPermissionsSetting -Location 'Disabled' -LocationGPO 'NotConfigured'

# --- --- Allow location override (default: Enabled)
Set-AppPermissionsSetting -LocationAllowOverride 'Disabled'

# --- --- Notify when apps request location (default: Enabled)
Set-AppPermissionsSetting -LocationAppsRequestNotif 'Disabled'

# --- Camera (default: Enabled)
Set-AppPermissionsSetting -Camera 'Disabled' -CameraGPO 'NotConfigured'

# --- Microphone (default: Enabled)
Set-AppPermissionsSetting -Microphone 'Disabled' -MicrophoneGPO 'NotConfigured'

# --- Voice activation (default: Enabled)
Set-AppPermissionsSetting -VoiceActivation 'Disabled' -VoiceActivationGPO 'NotConfigured'

# --- Notifications (default: Enabled)
Set-AppPermissionsSetting -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

# --- Text And Image Generation (default: Enabled)
Set-AppPermissionsSetting -TextAndImageGeneration 'Disabled' -TextAndImageGenerationGPO 'NotConfigured'

# --- Background apps (default: Enabled)
Set-AppPermissionsSetting -BackgroundApps 'Enabled' -BackgroundAppsGPO 'NotConfigured'

#endregion general

#               User Data
#=======================================
#region user data

# --- Account info (default: Enabled)
Set-AppPermissionsSetting -AccountInfo 'Disabled' -AccountInfoGPO 'NotConfigured'

# --- Contacts (default: Enabled)
Set-AppPermissionsSetting -Contacts 'Disabled' -ContactsGPO 'NotConfigured'

# --- Calendar (default: Enabled)
Set-AppPermissionsSetting -Calendar 'Disabled' -CalendarGPO 'NotConfigured'

# --- Phone calls (default: Enabled)
Set-AppPermissionsSetting -PhoneCalls 'Disabled' -PhoneCallsGPO 'NotConfigured'

# --- Call history (default: Enabled)
Set-AppPermissionsSetting -CallHistory 'Disabled' -CallHistoryGPO 'NotConfigured'

# --- Email (default: Enabled)
Set-AppPermissionsSetting -Email 'Disabled' -EmailGPO 'NotConfigured'

# --- Tasks (default: Enabled)
Set-AppPermissionsSetting -Tasks 'Disabled' -TasksGPO 'NotConfigured'

# --- Messaging (default: Enabled)
Set-AppPermissionsSetting -Messaging 'Disabled' -MessagingGPO 'NotConfigured'

# --- Radios (default: Enabled)
Set-AppPermissionsSetting -Radios 'Disabled' -RadiosGPO 'NotConfigured'

# --- Communicate with unpaired devices (Others devices) (default: Enabled)
Set-AppPermissionsSetting -SyncWithUnpairedDevices 'Disabled' -SyncWithUnpairedDevicesGPO 'NotConfigured'

# --- --- Use trusted devices (Others devices)
Set-AppPermissionsSetting -TrustedDevicesGPO 'NotConfigured'

# --- App diagnostics (default: Enabled)
Set-AppPermissionsSetting -AppDiagnostics 'Disabled' -AppDiagnosticsGPO 'NotConfigured'

#endregion user data

#              User Files
#=======================================
#region user files

# --- Documents (default: Enabled)
Set-AppPermissionsSetting -Documents 'Disabled'

# --- Downloads folder (default: Enabled)
Set-AppPermissionsSetting -DownloadsFolder 'Disabled'

# --- Music library (default: Enabled)
Set-AppPermissionsSetting -MusicLibrary 'Disabled'

# --- Pictures (default: Enabled)
Set-AppPermissionsSetting -Pictures 'Disabled'

# --- Videos (default: Enabled)
Set-AppPermissionsSetting -Videos 'Disabled'

# --- File system (default: Enabled)
Set-AppPermissionsSetting -FileSystem 'Disabled'

# --- Screenshot borders (default: Enabled)
Set-AppPermissionsSetting -ScreenshotBorders 'Disabled' -ScreenshotBordersGPO 'NotConfigured'

# --- Screenshots and screen recording (default: Enabled)
Set-AppPermissionsSetting -ScreenshotsAndRecording 'Disabled' -ScreenshotsAndRecordingGPO 'NotConfigured'

#endregion user files

#                Tablet
#=======================================
#region tablet

# --- Cellular data (default: Enabled)
#Set-AppPermissionsSetting -CellularData 'Disabled' -CellularDataGPO 'NotConfigured'

# --- Eye tracker (default: Enabled)
#Set-AppPermissionsSetting -EyeTracker 'Disabled' -EyeTrackerGPO 'NotConfigured'

# --- Motion (default: Enabled)
#Set-AppPermissionsSetting -Motion 'Disabled' -MotionGPO 'NotConfigured'

# --- Presence sensing (default: Enabled)
#Set-AppPermissionsSetting -PresenceSensing 'Disabled' -PresenceSensingGPO 'NotConfigured'

# --- User movement (default: Enabled)
#Set-AppPermissionsSetting -UserMovement 'Disabled' -UserMovementGPO 'NotConfigured'

#endregion tablet

#endregion app permissions
