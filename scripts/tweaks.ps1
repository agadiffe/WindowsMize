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
Start-Transcript -Path "$PSScriptRoot\..\log\$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Tweaks'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\tweaks"



#=================================================================================================================
#                                                     Tweaks
#=================================================================================================================

Write-Section -Name 'Tweaks'

#==============================================================================
#                       Security, privacy and networking
#==============================================================================

Write-Section -Name 'Security, privacy and networking' -SubSection

# Hotspot 2.0
#---------------------------------------
# Disabled | Enabled (default)
Set-Hotspot2 -State 'Disabled'

# Lock screen camera access
#-------------------
# Disabled | NotConfigured
Set-LockScreenCameraAccess -GPO 'Disabled'

# Messaging cloud sync
#-------------------
# Disabled | NotConfigured
Set-MessagingCloudSync -GPO 'Disabled'

# Notification network usage
#---------------------------------------
# Needed by Discord, Microsoft Teams, ... to get real-time notifs.
# Disabled | NotConfigured
Set-NotificationsNetworkUsage -GPO 'NotConfigured'

# Password expiration
#---------------------------------------
# Disabled | Enabled (default)
Set-PasswordExpiration -State 'Disabled'

# Password reveal button
#---------------------------------------
# Disabled | NotConfigured
Set-PasswordRevealButton -GPO 'Disabled'

# Printer drivers : Download over HTTP
#---------------------------------------
# Disabled | NotConfigured
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'

# Wifi sense
#---------------------------------------
# Disabled | NotConfigured
Set-WifiSense -GPO 'Disabled'

# Windows Platform Binary Table (WPBT)
#---------------------------------------
# Disabled | Enabled (default)
Set-Wpbt -State 'Disabled'


#==============================================================================
#                            System and performance
#==============================================================================

Write-Section -Name 'System and performance' -SubSection

# First sign-in animation
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-FirstSigninAnimation -State 'Disabled' -GPO 'NotConfigured'

# Fullscreen optimizations
#---------------------------------------
# Disabled | Enabled (default)
#Set-FullscreenOptimizations -State 'Disabled'

# Long paths
#---------------------------------------
# Disabled (default) | Enabled
Set-LongPaths -State 'Enabled'

# NTFS Last Access Time
#---------------------------------------
# default: System Enabled
# Managed: User | System
# State: Disabled | Enabled
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'

# Numlock at startup
#---------------------------------------
# Disabled (default) | Enabled
Set-NumLockAtStartup -State 'Enabled'

# Service host splitting
#---------------------------------------
# Disabled | Enabled (default)
Set-ServiceHostSplitting -State 'Enabled'

# Short 8.3 filenames
#---------------------------------------
# See the comments in 'src > modules > tweaks > public > system_and_performance > Set-Short8Dot3FileName.ps1'
# Disabled | Enabled (default)
#Set-Short8Dot3FileName -State 'Disabled'

# Startup/Shutdown verbose status messages
#---------------------------------------
# Enabled | NotConfigured
Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured'


#==============================================================================
#                        User interface and experience
#==============================================================================

Write-Section -Name 'User interface and experience' -SubSection

# Action center layout
#---------------------------------------
# Windows 11 24H2+ only.
# Rearrange the order according to your preferences.
$ActionCenterLayout = @(
    'WiFi'
    'Bluetooth'
    'Cellular'
    'WindowsStudio'
    'AirplaneMode'
    'Accessibility'
    'Vpn'
    'RotationLock'
    'BatterySaver'
    'EnergySaverAcOnly'
    'LiveCaptions'
    'BlueLightReduction'
    'MobileHotspot'
    'NearShare'
    'ColorProfile'
    'Cast'
    'ProjectL2'
    'LocalBluetooth'
)
#Set-ActionCenterLayout -Value $ActionCenterLayout
#Set-ActionCenterLayout -Reset

# Copy/Paste dialog : Show more details
#---------------------------------------
# Disabled (default) | Enabled
Set-CopyPasteDialogShowMoreDetails -State 'Enabled'

# Help tips
#---------------------------------------
# Disabled | NotConfigured
Set-HelpTips -GPO 'Disabled'

# Online tips
#---------------------------------------
# Disabled | NotConfigured
Set-OnlineTips -GPO 'Disabled'

# Shortcut name suffix (e.g. "File - Shortcut")
#---------------------------------------
# Disabled | Enabled (default)
Set-ShortcutNameSuffix -State 'Disabled'

# Start Menu recommended section
#---------------------------------------
# Enterprise and Education only.
# Disabled | NotConfigured
Set-StartMenuRecommendedSection -GPO 'NotConfigured'

# Suggested content
#---------------------------------------
# Disabled | Enabled (default)
Set-SuggestedContent -State 'Disabled'

# Windows experimentation
#---------------------------------------
# Disabled | NotConfigured
Set-WindowsExperimentation -GPO 'Disabled'

# Windows input experience
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsInputExperience -State 'Disabled'

# Windows privacy settings experience
#---------------------------------------
# Disabled | NotConfigured
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'

# Windows shared experience
#---------------------------------------
# Disabled: also disable and gray out:
#   'settings > system > nearby sharing'
#   'settings > apps > advanced app settings > share across devices'
# Disabled | NotConfigured
Set-WindowsSharedExperience -GPO 'NotConfigured'

# Windows Spotlight
#---------------------------------------
# Disabled | NotConfigured
Set-WindowsSpotlight -GPO 'NotConfigured'

# Windows Spotlight : Learn about this picture (Desktop icon)
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSpotlight -LearnAboutPictureDesktopIcon 'Disabled'


#==============================================================================
#                        Windows features and settings
#==============================================================================

Write-Section -Name 'Windows features and settings' -SubSection

# Move character map shorcut
#---------------------------------------
Move-CharacterMapShortcutToWindowsTools

# Set event log location
#---------------------------------------
# Path: path where to save the windows event logs.
# Default: restore to the default location ("$env:SystemRoot\system32\winevt\Logs").
#Set-EventLogLocation -Path 'X:\MyEventsLogs'
#Set-EventLogLocation -Default

# Ease of access : Always read/scan this section
#---------------------------------------
# Disabled | Enabled (default)
Set-EaseOfAccessReadScanSection -State 'Disabled'

# File History
#---------------------------------------
# Disabled | NotConfigured
Set-FileHistory -GPO 'NotConfigured'

# Font providers
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-FontProviders -GPO 'Disabled'

# Home setting page visibility
#---------------------------------------
# Disabled | NotConfigured
Set-HomeSettingPageVisibility -GPO 'Disabled'

# 'Open With' dialog : Look for an app in the Store
#---------------------------------------
# Disabled | NotConfigured
Set-OpenWithDialogStoreAccess -GPO 'Disabled'

# Windows help and support : F1Key
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsHelpSupportSetting -F1Key 'Disabled'

# Windows help and support : Feedback
#---------------------------------------
# Disabled | NotConfigured
Set-WindowsHelpSupportSetting -FeedbackGPO 'Disabled'

# Windows media digital rights management (DRM)
#---------------------------------------
# Disabled | NotConfigured
Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'

# Windows update drivers
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-WindowsUpdateSearchDrivers -GPO 'NotConfigured'


Stop-Transcript
