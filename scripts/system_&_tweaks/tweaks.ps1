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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\tweaks"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                                     Tweaks
#=================================================================================================================

Write-Section -Name 'Tweaks'

#==============================================================================
#                       Security, privacy and networking
#==============================================================================
#region security

Write-Section -Name 'Security, privacy and networking' -SubSection

# --- Display last signed-in username
# GPO: Disabled | Enabled (Default)
Set-DisplayLastSignedinUserName -GPO 'Enabled'

# --- HomeGroup # old
Set-HomeGroup -GPO 'Disabled'

# --- Hotspot 2.0 (default: Enabled)
Set-Hotspot2 -State 'Disabled'

# --- Local Accounts Security Questions
Set-LocalAccountsSecurityQuestions -GPO 'Disabled'

# --- Lock screen camera access
Set-LockScreenCameraAccess -GPO 'Disabled'

# --- Messaging cloud sync
Set-MessagingCloudSync -GPO 'Disabled'

# --- Notification network usage
# Needed by Discord, Microsoft Teams, ... to get real-time notifs (if installed from MS Store).
#Set-NotificationsNetworkUsage -GPO 'NotConfigured'

# --- Password expiration (default: Enabled)
Set-PasswordExpiration -State 'Disabled'

# --- Password reveal button
Set-PasswordRevealButton -GPO 'Disabled'

# --- Printer drivers : Download over HTTP
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'

# --- Printing Over HTTP
Set-PrintingOverHttp -GPO 'Disabled'

# --- Wifi sense # old
Set-WifiSense -GPO 'Disabled'

# --- Windows Platform Binary Table (WPBT) (default: Enabled)
Set-Wpbt -State 'Disabled'

#endregion security

#==============================================================================
#                            System and performance
#==============================================================================
#region system

Write-Section -Name 'System and performance' -SubSection

# --- First sign-in animation
# GPO: Disabled | Enabled | NotConfigured
Set-FirstSigninAnimation -GPO 'NotConfigured'

# --- Fullscreen optimizations
# State: Disabled | Enabled | Default (default)
#Set-FullscreenOptimizations -State 'Disabled'

# --- NTFS Last Access Time
# default: System Enabled
#   Managed: User | System
#   State: Disabled | Enabled
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'

# --- Numlock at startup (default: Disabled)
Set-NumLockAtStartup -State 'Enabled'

# --- Service host splitting (default: Enabled)
# Recommended to keep Enabled.
Set-ServiceHostSplitting -State 'Enabled'

# --- Short 8.3 file names
# 'PROGRA~1', 'COMMON~1', and others, will not be stripped because they are in used (access denied).
# To remove them:
#   - Settings > System > Recovery > Advanced Startup: click on "Restart now".
#   - On the recovery Menu, choose: Troubleshoot > Commmand Prompt.
#   - Check the Windows drive letter with DISKPART: list disk, select disk 0, list volume
#   - On the Commmand Prompt, run: fsutil.exe 8Dot3Name strip /f /s /l C:\8dot3.log C:
#     Note: "/l C:\8dot3.log" will save the log file into your C: drive instead of the recovery partition.

# State: Disabled | Enabled | PerVolumeBasis (default) | DisabledExceptSystemVolume
# RemoveExisting8dot3FileNames (switch): Removes 8dot3 file names for all files in $env:SystemDrive (i.e. C:)
Set-Short8Dot3FileName -State 'Disabled'
#Set-Short8Dot3FileName -State 'Disabled' -RemoveExisting8dot3FileNames

# --- Startup Apps Delay (default: default)
# Default: about 10s and/or idle state defined by Windows.
# Value: second (range 0-45)
#Set-StartupAppsDelay -Value 2
#Set-StartupAppsDelay -Default

# --- Startup/Shutdown verbose status messages
# GPO: Enabled | NotConfigured
#Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured'

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

# --- Disable GameBar Links
# Fix error if XBox GameBar is uninstalled.
#Disable-GameBarLinks

# --- Copy/Paste dialog : Show more details (default: Disabled)
Set-CopyPasteDialogShowMoreDetails -State 'Enabled'

# --- Help tips
Set-HelpTips -GPO 'Disabled'

# --- Menu Show Delay (default: 400)
# Value is in milliseconds (range 50-1000).
Set-MenuShowDelay -Value '200'

# --- Online tips
Set-OnlineTips -GPO 'Disabled'

# --- Shortcut name suffix (e.g. "File - Shortcut") (default: Enabled)
Set-ShortcutNameSuffix -State 'Disabled'

# --- Start Menu - All Apps View Mode
# State: Category (default) | Grid | List
Set-StartMenuAllAppsViewMode -Value 'Category'

# --- Start Menu - Recommended section
# Enterprise and Education only.
#Set-StartMenuRecommendedSection -GPO 'NotConfigured'

# --- Suggested content (default: Enabled)
Set-SuggestedContent -State 'Disabled'

# --- Taskbar calendar state
# State: Collapsed (default) | Expanded
Set-TaskbarCalendarState -Value 'Expanded'

# --- Windows experimentation
Set-WindowsExperimentation -GPO 'Disabled'

# --- Windows input experience (default: Enabled)
# Do not disable if device has a touchscreen.
Set-WindowsInputExperience -State 'Disabled'

# --- Windows privacy settings experience
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'

# --- Windows Settings Agentic Search Experience
Set-WindowsSettingsSearchAgent -GPO 'NotConfigured'

# --- Windows shared experience
# Disabled: also disable and gray out:
#   'settings > system > nearby sharing'
#   'settings > apps > advanced app settings > share across devices'
Set-WindowsSharedExperience -GPO 'NotConfigured'

# --- Windows Spotlight
Set-WindowsSpotlight -AllFeaturesGPO 'NotConfigured'

# --- --- Desktop
Set-WindowsSpotlight -DesktopGPO 'NotConfigured'

# --- --- Lock Screen (Enterprise only)
Set-WindowsSpotlight -LockScreenGPO 'NotConfigured'

# --- --- Ads Content
Set-WindowsSpotlight -AdsContentGPO 'Disabled'

# --- --- Learn about this picture (Desktop icon) (default: Enabled)
#Set-WindowsSpotlight -LearnAboutPictureDesktopIcon 'Disabled'

#endregion ui

#==============================================================================
#                        Windows features and settings
#==============================================================================
#region settings

Write-Section -Name 'Windows features and settings' -SubSection

# --- Move character map shorcut
# 'sfc /scannow' will show an error and restore the shorcut. 
#Move-CharacterMapShortcutToWindowsTools

# --- Display the lock screen
Set-DisplayLockScreen -GPO 'NotConfigured'

# --- Display Mode Change Animation (default: Enabled)
#Set-DisplayModeChangeAnimation -State 'Disabled'

# --- Event log location
# Path: path where to save the windows event logs.
# Default: restore to the default location ("$env:SystemRoot\system32\winevt\Logs").
#Set-EventLogLocation -Path 'X:\MyEventsLogs'
#Set-EventLogLocation -Default

# --- Ease of access : Always read/scan this section (default: Enabled)
Set-EaseOfAccessReadScanSection -State 'Disabled'

# --- File History
Set-FileHistory -GPO 'Disabled'

# --- Font providers
# GPO: Disabled | Enabled | NotConfigured
Set-FontProviders -GPO 'Disabled'

# --- Home setting page visibility
Set-HomeSettingPageVisibility -GPO 'Disabled'

# --- Location permission
Set-LocationPermission -GPO 'NotConfigured'

# --- Location Scripting permission
Set-LocationScriptingPermission -GPO 'NotConfigured'

# --- 'Open With' dialog : Look for an app in the Store
Set-OpenWithDialogStoreAccess -GPO 'Disabled'

# --- Sensors permission
# e.g. screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in)
Set-SensorsPermission -GPO 'NotConfigured'

# --- Taskbar : Last Active Click (default: Disabled)
#Set-TaskbarLastActiveClick -State 'Enabled'

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
