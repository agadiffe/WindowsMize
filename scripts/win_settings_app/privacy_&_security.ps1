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

Write-Output -InputObject 'Loading ''Win_settings_app\Privacy_&_security'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\privacy_&_security"



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

#            Find my device
#=======================================

# Find my device
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-WinPermissionsSetting -FindMyDevice 'Disabled' -FindMyDeviceGPO 'NotConfigured'

#endregion security


#==========================================================
#                   Windows permissions
#==========================================================
#region windows permissions

Write-Section -Name 'Windows permissions' -SubSection

#                General
#=======================================

# Let apps show me personalized ads by using my advertising ID
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -AdvertisingID 'Disabled' -AdvertisingIDGPO 'NotConfigured'

# Let websites show me locally relevant content by accessing my language list
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -LanguageListAccess 'Disabled'

# Let Windows improve Start and search results by tracking app launches
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -TrackAppLaunches 'Disabled' -TrackAppLaunchesGPO 'NotConfigured'

# Show me suggested content in the Settings app
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -ShowTipsInSettingsApp 'Disabled' -ShowTipsInSettingsAppGPO 'NotConfigured'

# Show me notifications in the Settings app
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -ShowNotifsInSettingsApp 'Disabled'

#          Recall & snapshots
#=======================================

# Save snapshots
#---------------------------------------
# Disabled | NotConfigured
Set-WinPermissionsSetting -RecallSnapshotsGPO 'Disabled'

# Help improve Recall snapshots filtering
#---------------------------------------
# Disabled (default) | Enabled
Set-WinPermissionsSetting -RecallFilteringTelemetry 'Disabled'

#              Click to Do
#=======================================

# Click to Do
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -ClickToDo 'Disabled' -ClickToDoGPO 'NotConfigured'

#                Speech
#=======================================

# Online speech recognition
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -SpeechRecognition 'Disabled' -SpeechRecognitionGPO 'NotConfigured'

#    Inking & typing personalization
#=======================================

# Custom inking and typing dictionary
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -InkingAndTypingPersonalization 'Disabled'

#        Diagnostics & feedback
#=======================================

# Diagnostic data
#---------------------------------------
# State: Disabled | OnlyRequired | OptionalAndRequired (default)
# GPO: Disabled | OnlyRequired | OptionalAndRequired | NotConfigured
Set-WinPermissionsSetting -DiagnosticData 'Disabled' -DiagnosticDataGPO 'Disabled'

# Improve inking and typing
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -ImproveInkingAndTyping 'Disabled' -ImproveInkingAndTypingGPO 'Disabled'

# Tailored experiences
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -TailoredExperiences 'Disabled' -TailoredExperiencesGPO 'Disabled'

# View diagnostic data
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -DiagnosticDataViewer 'Disabled' -DiagnosticDataViewerGPO 'Disabled'

# Delete diagnostic data
#---------------------------------------
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -DeleteDiagnosticDataGPO 'NotConfigured'

# Feedback frequency
#---------------------------------------
# State: Never | Automatically (default) | Always | Daily | Weekly
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -FeedbackFrequency 'Never' -FeedbackFrequencyGPO 'Disabled'

#           Activity history
#=======================================

# Activity history:
#   Store my activity history on this device
#   Store my activity history to Microsoft | old
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -ActivityHistory 'Disabled' -ActivityHistoryGPO 'NotConfigured'

#          Search permissions
#=======================================

# SafeSearch
#---------------------------------------
# Disabled | Moderate (default) | Strict
Set-WinPermissionsSetting -SafeSearch 'Disabled'

# Cloud content search:
#   Microsoft account
#   Work or School account
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -CloudSearchGPO 'NotConfigured'
Set-WinPermissionsSetting -CloudSearchMicrosoftAccount 'Disabled'
Set-WinPermissionsSetting -CloudSearchWorkOrSchoolAccount 'Disabled'

# Search history in this device
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -SearchHistory 'Disabled'

# Show search highlights
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-WinPermissionsSetting -SearchHighlights 'Disabled' -SearchHighlightsGPO 'NotConfigured'

# Enable deep content search of cloud content
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -CloudContentSearch 'Disabled'

# Let search apps show results
#---------------------------------------
# Disabled | Enabled (default)
Set-WinPermissionsSetting -WebSearch 'Disabled'

#           Searching Windows
#=======================================

# Find my files
#---------------------------------------
# Classic (default) | Enhanced
Set-WinPermissionsSetting -FindMyFiles 'Classic'

# Advanced indexing options > Index encrypted files
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-WinPermissionsSetting -IndexEncryptedFilesGPO 'Disabled'

#endregion windows permissions


#==========================================================
#                     App permissions
#==========================================================
#region app permissions

Write-Section -Name 'App permissions' -SubSection

#               Location
#=======================================

# Location
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Location 'Disabled' -LocationGPO 'NotConfigured'

# Allow location override
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -LocationAllowOverride 'Disabled'

# Notify when apps request location
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -LocationAppsRequestNotif 'Disabled'

#                Camera
#=======================================

# Camera
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Camera 'Disabled' -CameraGPO 'NotConfigured'

#              Microphone
#=======================================

# Microphone
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Microphone 'Disabled' -MicrophoneGPO 'NotConfigured'

#           Voice activation
#=======================================

# Voice activation
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -VoiceActivation 'Disabled' -VoiceActivationGPO 'NotConfigured'

#             Notifications
#=======================================

# Notifications
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

#             Account info
#=======================================

# Account info
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -AccountInfo 'Disabled' -AccountInfoGPO 'NotConfigured'

#               Contacts
#=======================================

# Contacts
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Contacts 'Disabled' -ContactsGPO 'NotConfigured'

#               Calendar
#=======================================

# Calendar
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Calendar 'Disabled' -CalendarGPO 'NotConfigured'

#              Phone calls
#=======================================

# Phone calls
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -PhoneCalls 'Disabled' -PhoneCallsGPO 'NotConfigured'

#             Call history
#=======================================

# Call history
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -CallHistory 'Disabled' -CallHistoryGPO 'NotConfigured'

#                 Email
#=======================================

# Email
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Email 'Disabled' -EmailGPO 'NotConfigured'

#                 Tasks
#=======================================

# Tasks
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Tasks 'Disabled' -TasksGPO 'NotConfigured'

#               Messaging
#=======================================

# Messaging
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Messaging 'Disabled' -MessagingGPO 'NotConfigured'

#                Radios
#=======================================

# Radios
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Radios 'Disabled' -RadiosGPO 'NotConfigured'

#            Others devices
#=======================================

# Communicate with unpaired devices
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -SyncWithUnpairedDevices 'Disabled' -SyncWithUnpairedDevicesGPO 'NotConfigured'

# Use trusted devices
#---------------------------------------
# Disabled | NotConfigured
Set-AppPermissionsSetting -TrustedDevicesGPO 'NotConfigured'

#            App diagnostics
#=======================================

# App diagnostics
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -AppDiagnostics 'Disabled' -AppDiagnosticsGPO 'NotConfigured'

#               Documents
#=======================================

# Documents
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -Documents 'Disabled'

#           Downloads folder
#=======================================

# Downloads folder
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -DownloadsFolder 'Disabled'

#              Music library
#=======================================

# Music library
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -MusicLibrary 'Disabled'

#               Pictures
#=======================================

# Pictures
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -Pictures 'Disabled'

#                Videos
#=======================================

# Videos
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -Videos 'Disabled'

#              File system
#=======================================

# File system
#---------------------------------------
# Disabled | Enabled (default)
Set-AppPermissionsSetting -FileSystem 'Disabled'

#          Screenshot borders
#=======================================

# Screenshot borders
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -ScreenshotBorders 'Disabled' -ScreenshotBordersGPO 'NotConfigured'

#   Screenshots and screen recording
#=======================================

# Screenshots and screen recording
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -ScreenshotsAndRecording 'Disabled' -ScreenshotsAndRecordingGPO 'NotConfigured'

#             Generative AI
#=======================================

# Generative AI
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -GenerativeAI 'Disabled' -GenerativeAIGPO 'NotConfigured'

#              Eye tracker
#=======================================

# Eye tracker
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -EyeTracker 'Disabled' -EyeTrackerGPO 'NotConfigured'

#                Motion
#=======================================

# Motion
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -Motion 'Disabled' -MotionGPO 'NotConfigured'

#           Presence sensing
#=======================================

# Presence sensing
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -PresenceSensing 'Disabled' -PresenceSensingGPO 'NotConfigured'

#             User movement
#=======================================

# User movement
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -UserMovement 'Disabled' -UserMovementGPO 'NotConfigured'

#             Cellular data
#=======================================

# Cellular data
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -CellularData 'Disabled' -CellularDataGPO 'NotConfigured'

#            Background apps
#=======================================

# Background apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AppPermissionsSetting -BackgroundApps 'Enabled' -BackgroundAppsGPO 'NotConfigured'

#endregion app permissions


Stop-Transcript
