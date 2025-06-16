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
Start-Transcript -Path "$PSScriptRoot\..\log\$ScriptFileName.log"

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)

Write-Output -InputObject 'Loading ''Tweaks'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\tweaks"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

#=================================================================================================================
#                                                     Tweaks
#=================================================================================================================

Write-Section -Name 'Tweaks'

#==============================================================================
#                       Security, privacy and networking
#==============================================================================
#region security

Write-Section -Name 'Security, privacy and networking' -SubSection

# --- Hotspot 2.0 (default: Enabled)
Set-Hotspot2 -State 'Disabled'

# --- Lock screen camera access
Set-LockScreenCameraAccess -GPO 'Disabled'

# --- Messaging cloud sync
Set-MessagingCloudSync -GPO 'Disabled'

# --- Notification network usage
# Needed by Discord, Microsoft Teams, ... to get real-time notifs.
Set-NotificationsNetworkUsage -GPO 'NotConfigured'

# --- Password expiration (default: Enabled)
Set-PasswordExpiration -State 'Disabled'

# --- Password reveal button
Set-PasswordRevealButton -GPO 'Disabled'

# --- Printer drivers : Download over HTTP
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'

# --- Wifi sense
Set-WifiSense -GPO 'Disabled'

# --- Windows Platform Binary Table (WPBT) (default: Enabled)
Set-Wpbt -State 'Disabled'

#endregion security

#==============================================================================
#                            System and performance
#==============================================================================
#region system

Write-Section -Name 'System and performance' -SubSection

# --- First sign-in animation (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-FirstSigninAnimation -State 'Disabled' -GPO 'NotConfigured'

# --- Fullscreen optimizations (default: Enabled)
#Set-FullscreenOptimizations -State 'Disabled'

# --- Long paths (default: Disabled)
Set-LongPaths -State 'Enabled'

# --- NTFS Last Access Time
# default: System Enabled
#   Managed: User | System
#   State: Disabled | Enabled
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'

# --- Numlock at startup (default: Disabled)
Set-NumLockAtStartup -State 'Enabled'

# --- Service host splitting (default: Enabled)
Set-ServiceHostSplitting -State 'Enabled'

# --- Short 8.3 file names (default: Enabled)
# RemoveExisting8dot3FileNames (switch): Removes 8dot3 file names for all files in $env:SystemDrive (i.e. C:)
#   Might require manual editing of some registry entries (should not on a fresh install).
#   Read the comments in 'src > modules > tweaks > public > system_and_performance > Set-Short8Dot3FileName.ps1'.
Set-Short8Dot3FileName -State 'Disabled'
#Set-Short8Dot3FileName -State 'Disabled' -RemoveExisting8dot3FileNames

# --- Startup/Shutdown verbose status messages
# GPO: Enabled | NotConfigured
Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured'

#endregion system

#==============================================================================
#                        User interface and experience
#==============================================================================
#region ui

Write-Section -Name 'User interface and experience' -SubSection

# --- Action center layout
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

# --- Copy/Paste dialog : Show more details (default: Disabled)
Set-CopyPasteDialogShowMoreDetails -State 'Enabled'

# --- Help tips
Set-HelpTips -GPO 'Disabled'

# --- Online tips
Set-OnlineTips -GPO 'Disabled'

# --- Shortcut name suffix (e.g. "File - Shortcut") (default: Enabled)
Set-ShortcutNameSuffix -State 'Disabled'

# --- Start Menu recommended section | soon old
# Enterprise and Education only.
Set-StartMenuRecommendedSection -GPO 'NotConfigured'

# --- Suggested content (default: Enabled)
Set-SuggestedContent -State 'Disabled'

# --- Windows experimentation
Set-WindowsExperimentation -GPO 'Disabled'

# --- Windows input experience (default: Enabled)
Set-WindowsInputExperience -State 'Disabled'

# --- Windows privacy settings experience
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'

# --- Windows shared experience
# Disabled: also disable and gray out:
#   'settings > system > nearby sharing'
#   'settings > apps > advanced app settings > share across devices'
Set-WindowsSharedExperience -GPO 'NotConfigured'

# --- Windows Spotlight
Set-WindowsSpotlight -GPO 'NotConfigured'

# --- Windows Spotlight : Learn about this picture (Desktop icon) (default: Enabled)
Set-WindowsSpotlight -LearnAboutPictureDesktopIcon 'Disabled'

#endregion ui

#==============================================================================
#                        Windows features and settings
#==============================================================================
#region settings

Write-Section -Name 'Windows features and settings' -SubSection

# --- Move character map shorcut
Move-CharacterMapShortcutToWindowsTools

# --- Set event log location
# Path: path where to save the windows event logs.
# Default: restore to the default location ("$env:SystemRoot\system32\winevt\Logs").
#Set-EventLogLocation -Path 'X:\MyEventsLogs'
#Set-EventLogLocation -Default

# --- Ease of access : Always read/scan this section (default: Enabled)
Set-EaseOfAccessReadScanSection -State 'Disabled'

# --- File History
Set-FileHistory -GPO 'NotConfigured'

# --- Font providers
# GPO: Disabled | Enabled | NotConfigured
Set-FontProviders -GPO 'Disabled'

# --- Home setting page visibility
Set-HomeSettingPageVisibility -GPO 'Disabled'

# --- 'Open With' dialog : Look for an app in the Store
Set-OpenWithDialogStoreAccess -GPO 'Disabled'

# --- Windows help and support : F1Key (default: Enabled)
Set-WindowsHelpSupportSetting -F1Key 'Disabled'

# --- Windows help and support : Feedback
Set-WindowsHelpSupportSetting -FeedbackGPO 'Disabled'

# --- Windows media digital rights management (DRM)
Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'

# --- Windows update drivers
# GPO: Disabled | Enabled | NotConfigured
Set-WindowsUpdateSearchDrivers -GPO 'NotConfigured'

#endregion settings


Stop-Transcript
