#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================
#region windowsmmize

#==============================================================================
#                                    Usage
#==============================================================================
#region usage

<#
  To don't run a function, comment it (i.e. Add the "#" character before it).
  e.g. #Disable-PowerShellTelemetry
  To run a function, uncomment it (i.e. Remove the "#" character before it).
  e.g. Disable-PowerShellTelemetry

  Mostly all functions have a '-State' and/or '-GPO' parameters.
  Example:
  # Bing Search in Start Menu
  #---------------------------------------
  # State: Disabled | Enabled (default)
  # GPO: Disabled | NotConfigured
  Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'

  The 2 comments below the title are the accepted values for the parameters.
  Change the parameters value according to your preferences.
  e.g.
  Set-StartMenuBingSearch -State 'Enabled' -GPO 'NotConfigured'
#>

#endregion usage


#==============================================================================
#                                Requirements
#==============================================================================
#region requirements

<#
- PowerShell 7 (aka PowerShell Core).
  Open a terminal and run:
    winget install --exact --id 'Microsoft.PowerShell' --accept-source-agreements --accept-package-agreements
  Before running the script, sets the PowerShell execution policies:
    Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process' -Force

- Update
  Make sure your Windows is fully updated:
    settings > windows update > check for updates
    microsoft store > library (or downloads) > get updates

- Backup
  Make sure to backup all of your data.
  e.g. browser bookmarks, apps settings, personal files, passwords database
#>

#Requires -RunAsAdministrator
#Requires -Version 7.5

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\log\$ScriptFileName.log"

#endregion requirements


#==============================================================================
#                                   Modules
#==============================================================================
#region modules

Write-Output -InputObject 'Loading Modules ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\src\modules\helper_functions\general"
Import-Module -Name "$PSScriptRoot\src\modules\tweaks"
Import-Module -Name "$PSScriptRoot\src\modules\telemetry"
Import-Module -Name "$PSScriptRoot\src\modules\network"
Import-Module -Name "$PSScriptRoot\src\modules\power_options"
Import-Module -Name "$PSScriptRoot\src\modules\system_properties"
Import-Module -Name "$PSScriptRoot\src\modules\file_explorer"
Import-Module -Name "$PSScriptRoot\src\modules\applications\management"
Import-Module -Name "$PSScriptRoot\src\modules\applications\settings"
Import-Module -Name "$PSScriptRoot\src\modules\ramdisk"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\accessibility"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\accounts"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\apps"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\bluetooth_&_devices"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\defender_security_center"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\gaming"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\network_&_internet"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\optional_features"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\personnalization"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\privacy_&_security"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\system"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\time_&_language"
Import-Module -Name "$PSScriptRoot\src\modules\settings_app\windows_update"
Import-Module -Name "$PSScriptRoot\src\modules\services"
Import-Module -Name "$PSScriptRoot\src\modules\scheduled_tasks"

#endregion modules

#endregion windowsmize


#=================================================================================================================
#                                                     Tweaks
#=================================================================================================================
#region tweaks

Write-Section -Name 'Tweaks'

#==============================================================================
#                       Security, privacy and networking
#==============================================================================

Write-Section -Name 'Security, privacy and networking' -SubSection

# Hotspot 2.0
#---------------------------------------
# Disabled | Enabled (default)
Set-Hotspot2 -State 'Disabled'

# Indexing of encrypted files
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-IndexingEncryptedFiles -GPO 'Disabled'

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

# Move event log location
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

#endregion tweaks


#=================================================================================================================
#                                                    Telemetry
#=================================================================================================================
#region telemetry

Write-Section -Name 'Telemetry'

# .Net
#---------------------------------------
Disable-DotNetTelemetry

# Nvidia
#---------------------------------------
Disable-NvidiaTelemetry

# PowerShell
#---------------------------------------
Disable-PowerShellTelemetry

# App and device inventory
#---------------------------------------
# Windows 11 24H2+ only.
# Disabled | NotConfigured
Set-AppAndDeviceInventory -GPO 'Disabled'

# Application compatibility
#---------------------------------------
# Disabled | NotConfigured
Set-ApplicationCompatibility -GPO 'Disabled'

# Cloud content experiences
#---------------------------------------
# Disabled | NotConfigured
Set-CloudContent -GPO 'Disabled'

# Consumer experiences
#---------------------------------------
# Disabled: also disable and gray out: 'settings > bluetooth & devices > mobile devices'
# Disabled | NotConfigured
Set-ConsumerExperience -GPO 'NotConfigured'

# Customer Experience Improvement Program (CEIP)
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-Ceip -GPO 'Disabled'

# Diagnostic log and dump collection limit
#---------------------------------------
# Disabled | NotConfigured
Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'

# Diagnostic auto-logger (system boot log)
#---------------------------------------
# Name: DiagTrack-Listener
# State: Disabled | Enabled (default)
Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'

# Diagnostic tracing
#---------------------------------------
# Protected key. Need to be changed manually.
# See 'Set-DiagnosticTracing.ps1' in 'src > modules > telemetry > private'.

# Error reporting
#---------------------------------------
# Disabled | NotConfigured
Set-ErrorReporting -GPO 'Disabled'

# Group policy settings logging
#---------------------------------------
# Disabled | NotConfigured
Set-GroupPolicySettingsLogging -GPO 'Disabled'

# Handwriting personalization
#---------------------------------------
# Disabled | NotConfigured
Set-HandwritingPersonalization -GPO 'Disabled'

# Inventory collector
#---------------------------------------
# Disabled | NotConfigured
Set-InventoryCollector -GPO 'Disabled'

# KMS client activation data
#---------------------------------------
# Disabled | NotConfigured
Set-KmsClientActivationDataSharing -GPO 'Disabled'

# Microsoft Windows Malicious Software Removal Tool (MSRT) : Heartbeat report
#---------------------------------------
# Disabled | NotConfigured
Set-MsrtDiagnosticReport -GPO 'Disabled'

# OneSettings downloads
#---------------------------------------
# Disabled | NotConfigured
Set-OneSettingsDownloads -GPO 'Disabled'

# User info sharing
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-UserInfoSharing -GPO 'Disabled'

#endregion telemetry


#=================================================================================================================
#                                                     Network
#=================================================================================================================
#region network

Write-Section -Name 'Network'

#==============================================================================
#                                   Firewall
#==============================================================================

Write-Section -Name 'Firewall' -SubSection

# Connected Devices Platform service
#---------------------------------------
Block-NetFirewallInboundRule -Name 'CDP'

# DCOM service control manager (RPC)
#---------------------------------------
Block-NetFirewallInboundRule -Name 'DCOM'

# NetBIOS over TCP/IP
#---------------------------------------
Block-NetFirewallInboundRule -Name 'NetBiosTcpIP'

# Server Message Block (SMB) (e.g. File And Printer Sharing)
#---------------------------------------
Block-NetFirewallInboundRule -Name 'SMB'

# Miscellaneous programs/services
# lsass.exe, wininit.exe, Schedule, EventLog, services.exe
#---------------------------------------
Block-NetFirewallInboundRule -Name 'MiscProgSrv'


#==============================================================================
#                         IPv6 transition technologies
#==============================================================================

Write-Section -Name 'IPv6 transition technologies' -SubSection

# 6to4
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name '6to4' -State 'Disabled' -GPO 'Disabled'

# Teredo
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'Teredo' -State 'Disabled' -GPO 'Disabled'

# IP-HTTPS
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'IP-HTTPS' -State 'Disabled' -GPO 'Disabled'

# ISATAP
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'ISATAP' -State 'Disabled' -GPO 'Disabled'


#==============================================================================
#                           Network adapter protocol
#==============================================================================

Write-Section -Name 'Network adapter protocol' -SubSection

Export-DefaultNetAdapterProtocolsState

# Microsoft LLDP Protocol Driver (Link-Layer Discovery Protocol)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'LLDP' -State 'Disabled'

# Link-Layer Topology Discovery Responder
# Link-Layer Topology Discovery Mapper I/O Driver
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'LLTD' -State 'Disabled'

# Bridge Driver
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'BridgeDriver' -State 'Disabled'

# QoS Packet Scheduler
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'QosPacketScheduler' -State 'Disabled'

# Hyper-V Extensible Virtual Switch
#---------------------------------------
# Disabled (default) | Enabled
Set-NetAdapterProtocol -Name 'HyperVExtensibleVirtualSwitch' -State 'Disabled'

# Internet Protocol Version 4 (TCP/IPv4)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'IPv4' -State 'Enabled'

# Internet Protocol Version 6 (TCP/IPv6)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'IPv6' -State 'Enabled'

# Microsoft Network Adapter Multiplexor Protocol
#---------------------------------------
# Disabled (default) | Enabled
Set-NetAdapterProtocol -Name 'MicrosoftMultiplexor' -State 'Disabled'

# Client for Microsoft Networks
# File and Printer Sharing for Microsoft Networks
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'FileAndPrinterSharing' -State 'Disabled'


#==============================================================================
#                                Miscellaneous
#==============================================================================

Write-Section -Name 'Miscellaneous' -SubSection

# NetBIOS over TCP/IP
#---------------------------------------
# Disabled | Enabled | Default (default)
Set-NetBiosOverTcpIP -State 'Disabled'

# Internet Control Message Protocol (ICMP) redirects
#---------------------------------------
# Disabled | Enabled (default)
Set-NetIcmpRedirects -State 'Disabled'

# IP source routing
#---------------------------------------
# Disabled | Enabled (default)
Set-NetIPSourceRouting -State 'Disabled'

# Link Local Multicast Name Resolution (LLMNR)
#---------------------------------------
# Disabled | NotConfigured
Set-NetLlmnr -GPO 'Disabled'

# Smart Multi-Homed Name Resolution
#---------------------------------------
# Disabled | NotConfigured
Set-NetSmhnr -GPO 'Disabled'

# Web Proxy Auto-Discovery protocol (WPAD)
#---------------------------------------
# Disabled | Enabled (default)
#Set-NetWpad -State 'Disabled'

#endregion network


#=================================================================================================================
#                                                  Power Options
#=================================================================================================================
#region power options

Write-Section -Name 'Power Options'

# Fast startup
#---------------------------------------
# Disabled | Enabled (default)
Set-FastStartup -State 'Disabled'

# Hibernate
#---------------------------------------
# Disabled (also disable 'Fast startup') | Enabled (default)
Set-Hibernate -State 'Disabled'

# Turn off hard disk after idle time
#---------------------------------------
# default: 20 (PluggedIn), 10 (OnBattery)
# PowerSource: PluggedIn | OnBattery
# Timeout: value in minutes
Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60

# Modern standby (S0) : Network connectivity
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# State: Disabled | Enabled (default) | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

# Battery settings
#---------------------------------------
# default (depends): Low 10%, DoNothing | Reserve 7% | Critical 5%, Hibernate
# Battery: Low | Critical | Reserve
# Level: value in percent (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown
Set-AdvancedBatterySetting -Battery 'Low'      -Level 15 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 10
Set-AdvancedBatterySetting -Battery 'Critical' -Level 7  -Action 'ShutDown'

#endregion power options


#=================================================================================================================
#                                                System Properties
#=================================================================================================================
#region system properties

Write-Section -Name 'System Properties'

#==============================================================================
#                                   Hardware
#==============================================================================

Write-Section -Name 'Hardware' -SubSection

# Device installation settings:
#   Choose whether Windows downloads manufacters' apps and custom icons available for your devices.
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-ManufacturerAppsAutoDownload -State 'Disabled' -GPO 'NotConfigured'


#==============================================================================
#                                   Advanced
#==============================================================================

Write-Section -Name 'Advanced' -SubSection

#==========================================================
#                       Performance
#==========================================================

# Visual effects
#---------------------------------------
# State: ManagedByWindows (default) | BestAppearance | BestPerformance | Custom
# Setting: <VisualEffectsCustomSetting> (see below)

#Set-VisualEffects -State 'ManagedByWindows'

$VisualEffectsCustomSettings = @{
    'Animate controls and elements inside windows'    = 'Enabled'
    'Animate windows when minimizing and maximizing'  = 'Enabled'
    'Animations in the taskbar'                       = 'Enabled'
    'Enable Peek'                                     = 'Enabled'
    'Fade or slide menus into view'                   = 'Enabled'
    'Fade or slide ToolTips into view'                = 'Enabled'
    'Fade out menu items after clicking'              = 'Enabled'
    'Save taskbar thumbnail previews'                 = 'Disabled'
    'Show shadows under mouse pointer'                = 'Enabled'
    'Show shadows under windows'                      = 'Enabled'
    'Show thumbnails instead of icons'                = 'Enabled'
    'Show translucent selection rectangle'            = 'Enabled'
    'Show window contents while dragging'             = 'Enabled'
    'Slide open combo boxes'                          = 'Enabled'
    'Smooth edges of screen fonts'                    = 'Enabled'
    'Smooth-scroll list boxes'                        = 'Enabled'
    'Use drop shadows for icon labels on the desktop' = 'Enabled'
}
Set-VisualEffects -State 'Custom' -Setting $VisualEffectsCustomSettings

# Advanced > Virtual memory
#---------------------------------------
# AllDrivesAutoManaged: Disabled | Enabled (default)
# Drive: drive to config (e.g. 'C:')
# State: CustomSize | SystemManaged | NoPagingFile
# InitialSize/MaximumSize: size in MB

#Set-PagingFileSize -AllDrivesAutoManaged 'Enabled'
Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 512 -MaximumSize 2048
#Set-PagingFileSize -Drive 'X:', 'Y:' -State 'SystemManaged'

# Data execution prevention:
#   Essential Windows programs and services only (OptIn)
#   All programs and services except those I select (OptOut)
#---------------------------------------
# OptIn (default) | OptOut
Set-DataExecutionPrevention -State 'OptIn'


#==========================================================
#                   Startup and recovery
#==========================================================

#            System failure
#=======================================

# Automatically restart
#---------------------------------------
# Disabled | Enabled (default)
Set-SystemFailureSetting -AutoRestart 'Disabled'

# Write debugging information
#---------------------------------------
# Requires a minimum paging file size according to the selected setting.
# None | Complete (<YOUR_RAM> MB + 257 MB) | Kernel (800 MB) | Small (1 MB) | Automatic (800 MB) (default) | Active (800 MB)
Set-SystemFailureSetting -WriteDebugInfo 'None'


#==============================================================================
#                              System protection
#==============================================================================

Write-Section -Name 'System protection' -SubSection

# Protection settings
#---------------------------------------
# AllDrivesDisabled: turn off System Restore
# Drive: drive to config (e.g. 'C:')
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured

#Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
#Set-SystemRestore -Drive $env:SystemDrive -State 'Enabled'


#==============================================================================
#                                    Remote
#==============================================================================

Write-Section -Name 'Remote' -SubSection

# Remote assistance:
#   Allow remote assistance connections to this computer
#   Allow this computer to be controlled remotely
#---------------------------------------
# State: Disabled | FullControl | ViewOnly (default)
# GPO: Disabled | FullControl | ViewOnly | NotConfigured
# InvitationMaxTime: number (range 1-99), default: 6
# InvitationMaxTimeUnit: Minutes | Hours (default) | Days
# EncryptedOnly: Disabled (Windows default) | Enabled (script default)
# EncryptedOnlyGPO: Disabled | Enabled | NotConfigured (default)
# InvitationMethodGPO (ignored if 'GPO' is 'NotConfigured'): SimpleMAPI (default) | Mailto

Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured'

# advanced settings
$RemoteAssistanceProperties = @{
    State                 = 'ViewOnly'
    GPO                   = 'NotConfigured'
    InvitationMaxTime     = 6
    InvitationMaxTimeUnit = 'Hours'
    EncryptedOnly         = 'Enabled'
    EncryptedOnlyGPO      = 'NotConfigured'
    InvitationMethodGPO   = 'SimpleMAPI'
}
#Set-RemoteAssistance @RemoteAssistanceProperties

#endregion system properties


#=================================================================================================================
#                                                  File Explorer
#=================================================================================================================
#region file explorer

Write-Section -Name 'File Explorer'

#==============================================================================
#                                   General
#==============================================================================

Write-Section -Name 'General' -SubSection

# Open file explorer to
#---------------------------------------
# ThisPC | Home (default) | Downloads | OneDrive
Set-FileExplorerSetting -LaunchTo 'Home'

# Open each folder in same/new window
#---------------------------------------
# SameWindow (default) | NewWindow
Set-FileExplorerSetting -OpenFolder 'SameWindow'

# Open desktop folders and external folder links in new tab
#---------------------------------------
# Requires 'open each folder in the same window'
# Disabled | Enabled (default)
Set-FileExplorerSetting -OpenFolderInNewTab 'Enabled'

# Single/Double-click to open an item
#---------------------------------------
# SingleClick | DoubleClick (default)
Set-FileExplorerSetting -OpenItem 'DoubleClick'

# Show recently used files
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowRecentFiles 'Enabled'

# Show frequently used folders
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowFrequentFolders 'Disabled'

# Show files from Office.com
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowCloudFiles 'Disabled'


#==============================================================================
#                                     View
#==============================================================================

Write-Section -Name 'View' -SubSection

#           Files and Folders
#=======================================

# Decrease space between items (compact view)
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -CompactView 'Enabled'

# Hidden files, folders, and drives
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowHiddenItems 'Enabled'

# Hide extensions for known file types
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideFileExtensions 'Disabled'

# Hide folder merge conflicts
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideFolderMergeConflicts 'Disabled'

# Launch folder windows in a separate process
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -LaunchFolderInSeparateProcess 'Disabled'

# Show encrypted or compressed NTFS files in color
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ColorEncryptedAndCompressedFiles 'Disabled'

# Show sync provider notifications (OneDrive Ads)
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowSyncProviderNotifications 'Disabled'

# Use check boxes to select items
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ItemsCheckBoxes 'Enabled'

# Use sharing wizard
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -SharingWizard 'Disabled'

#            Navigation pane
#=======================================

# Expand to open folder
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ExpandToCurrentFolder 'Disabled'

# Show all folders
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowAllFolders 'Disabled'


#==============================================================================
#                                    Search
#==============================================================================

Write-Section -Name 'Search' -SubSection

# Don't use the index when searching in file folders for system files
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -DontUseSearchIndex 'Enabled'


#==============================================================================
#                                Miscellaneous
#==============================================================================

Write-Section -Name 'Miscellaneous' -SubSection

# Show gallery
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowGallery 'Disabled'

# Hide duplicate removable drives
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -HideDuplicateRemovableDrives 'Enabled'

# Max icon cache size
#---------------------------------------
# default: 512KB
Set-FileExplorerSetting -MaxIconCacheSize 4096

# Auto folder type detection
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -AutoFolderTypeDetection 'Disabled'

# Recycle Bin
#---------------------------------------
# Disabled: don't move files to the Recycle Bin. Remove files immediately when deleted.
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-FileExplorerSetting -RecycleBin 'Enabled' -RecycleBinGPO 'NotConfigured'

# Display delete confirmation dialog
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-FileExplorerSetting -ConfirmFileDelete 'Disabled' -ConfirmFileDeleteGPO 'NotConfigured'

#endregion file explorer


#=================================================================================================================
#                                             Applications Management
#=================================================================================================================
#region applications management

Write-Section -Name 'Applications Management'

#==============================================================================
#                                Installation
#==============================================================================

Write-Section -Name 'Installation' -SubSection

# Custom applications
#---------------------------------------
# Name: winget name of the app
# Scope (optional): Machine | User
# e.g. Install-ApplicationWithWinget -Name 'Valve.Steam' -Scope 'Machine'
$CustomAppsToInstall = @(
    'AppName1'
    'AppName2'
    'AppName3'
)
#$CustomAppsToInstall | Install-ApplicationWithWinget -Scope 'Machine'

# Predefined applications
#---------------------------------------
$AppsToInstall = @(
    # Development
    #-----------------
    #'Git'
    #'VSCode'

    # Multimedia
    #-----------------
    'VLC'

    # Password Manager
    #-----------------
    #'Bitwarden'
    #'KeePassXC'
    #'ProtonPass'

    # PDF Viewer
    #-----------------
    #'AcrobatReader'
    #'SumatraPDF'

    # Utilities
    #-----------------
    #'7zip'
    #'Notepad++'
    #'qBittorrent'

    # Web Browser
    #-----------------
    'Brave'
    #'Firefox'
    #'MullvadBrowser'

    # Microsoft DirectX (might be needed for older games)
    #-----------------
    #'DirectXEndUserRuntime'

    # Microsoft Visual C++ Redistributable
    #-----------------
    #'VCRedist2015+.ARM'
    'VCRedist2015+'
    #'VCRedist2013'
    #'VCRedist2012'
    #'VCRedist2010'
    #'VCRedist2008'
    #'VCRedist2005'
)
$AppsToInstall | Install-Application

# Desktop shortcuts
#---------------------------------------
Remove-AllDesktopShortcuts

# Windows Subsystem For Linux
#---------------------------------------
#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'


#==============================================================================
#                         Appx & provisioned packages
#==============================================================================

Write-Section -Name 'Appx & provisioned packages' -SubSection

# Bing Search in Start Menu
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'

# Copilot | deprecated
# This policy isn't for the new Copilot app experience.
#---------------------------------------
# Disabled | NotConfigured
Set-Copilot -GPO 'Disabled'

# Cortana | deprecated
#---------------------------------------
# Disabled | NotConfigured
Set-Cortana -GPO 'Disabled'

# Microsoft Edge
#---------------------------------------
Remove-MicrosoftEdge

# Microsoft Store : Push to install service
#---------------------------------------
# Disabled | NotConfigured
Set-MicrosoftStorePushToInstall -GPO 'Disabled'

# Microsoft Windows Malicious Software Removal Tool
#---------------------------------------
#Remove-MSMaliciousSoftwareRemovalTool

# OneDrive
#---------------------------------------
Remove-OneDrive

# OneDrive : Auto install for new user
#---------------------------------------
# Disabled | Enabled (default)
Set-OneDriveNewUserAutoInstall -State 'Disabled'

# Widgets
#---------------------------------------
# Disabled | NotConfigured
Set-Widgets -GPO 'Disabled'

# Promoted/Sponsored apps (e.g. Spotify, LinkedIn)
#---------------------------------------
# Windows 11 only.
Remove-StartMenuPromotedApps

# Preinstalled default apps
#---------------------------------------
Export-DefaultAppxPackagesNames

$PreinstalledAppsToRemove = @(
    'BingSearch'
    #'Calculator'
    'Camera'
    'Clipchamp'
    'Clock'
    'Compatibility'
    'Cortana'
    'CrossDevice'
    'DevHome'
    #'Extensions'
    'Family'
    'FeedbackHub'
    'GetHelp'
    'Journal'
    'MailAndCalendar'
    'Maps'
    'MediaPlayer'
    'Microsoft365'
    'MicrosoftCopilot'
    #'MicrosoftStore' # do not remove
    'MicrosoftTeams'
    'MoviesAndTV'
    'News'
    #'Notepad'
    'Outlook'
    #'Paint'
    'People'
    'PhoneLink'
    #'Photos'
    'PowerAutomate'
    'QuickAssist'
    #'SnippingTool'
    'Solitaire'
    'SoundRecorder'
    'StickyNotes'
    #'Terminal'
    'Tips'
    'Todo'
    'Weather'
    #'Whiteboard'
    'Widgets'
    'Xbox'
    '3DViewer'
    'MixedReality'
    'OneNote'
    'Paint3D'
    'Skype'
    'Wallet'
)
$PreinstalledAppsToRemove | Remove-PreinstalledAppPackage

#endregion applications management


#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================
#region applications settings

Write-Section -Name 'Applications Settings'

#==============================================================================
#                            Adobe Acrobat Reader
#==============================================================================
#region adobe acrobat reader

Write-Section -Name 'Adobe Acrobat Reader' -SubSection

#==========================================================
#                       Preferences
#==========================================================

#               Documents
#=======================================

# Show Tools Pane
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -ShowToolsPane 'Disabled'

#                General
#=======================================

# Show online storage when openings files
#---------------------------------------
# Disabled (default) | Enabled
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileOpen 'Disabled'

# Show online storage when saving files
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileSave 'Disabled'

# Show me messages when I launch Adobe Acrobat
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -ShowMessagesAtLaunch 'Disabled'

# Send crash reports
#---------------------------------------
# Ask (default) | Always | Never
Set-AdobeAcrobatReaderSetting -SendCrashReports 'Never'

#              Javascript
#=======================================

# Enable Acrobat Javascript
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -Javascript 'Disabled'

#          Security (enhanced)
#=======================================

# Protected mode at startup
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -ProtectedMode 'Enabled'

# Run in AppContainer
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -AppContainer 'Enabled'

# Protected view
#---------------------------------------
# Disabled (default) | Enabled
Set-AdobeAcrobatReaderSetting -ProtectedView 'Disabled'

# Enhanced security
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -EnhancedSecurity 'Enabled'

# Automatically trust documents with valid certification
#---------------------------------------
# Disabled (default) | Enabled
Set-AdobeAcrobatReaderSetting -TrustCertifiedDocuments 'Disabled'

# Automatically trust sites from my Win OS security zones
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -TrustOSTrustedSites 'Disabled'

#             Trust manager
#=======================================

# Allow opening of non-PDF file attachments with external applications
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -OpenFileAttachments 'Disabled'

#                 Units
#=======================================

# Page units
#---------------------------------------
# Points | Inches | Millimeters | Centimeters | Picas
Set-AdobeAcrobatReaderSetting -PageUnits 'Centimeters'


#==========================================================
#                      Miscellaneous
#==========================================================

# Home page : Collapse recommended tools for you
#---------------------------------------
# Expand (default) | Collapse
Set-AdobeAcrobatReaderSetting -RecommendedTools 'Collapse'

# First launch introduction and UI tutorial overlay
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -FirstLaunchExperience 'Disabled'

# Upsell (offers to buy extra tools)
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -Upsell 'Disabled'

# Usage statistics
#---------------------------------------
# Doesn't work for Acrobat DC ?
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -UsageStatistics 'Disabled'

# Online services and features (e.g. Sign, Sync)
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -OnlineServices 'Disabled'

# Adobe cloud
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -AdobeCloud 'Disabled'

# SharePoint
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -SharePoint 'Disabled'

# Webmail
#---------------------------------------
# Disabled | Enabled (default)
Set-AdobeAcrobatReaderSetting -Webmail 'Disabled'

#endregion adobe acrobat reader


#==============================================================================
#                                Brave Browser
#==============================================================================
#region brave browser

Write-Section -Name 'Brave Browser' -SubSection

# Meant to be used on a fresh Brave installation.

# If used on current install, it will override the current settings.
# Including your profiles if you have more than one (the data folder will not be deleted).

# For now, to customize the settings, open the file:
#   src > modules > applications > settings > private > New-BraveBrowserConfigData.ps1

# By default, it disable everythings: AI, Web3, Vpn, etc ...
# This is not done via policy, so you can customize everything afterward with the Brave GUI.

Set-BraveBrowserSettings

#endregion brave browser


#==============================================================================
#                                     Git
#==============================================================================
#region git

Write-Section -Name 'Git' -SubSection

# To customize the settings, open the file:
#   src > modules > applications > settings > config_files > Git.ini

Set-MyAppsSetting -Git

#endregion git


#==============================================================================
#                                  KeePassXC
#==============================================================================
#region keepassxc

Write-Section -Name 'KeePassXC' -SubSection

# To customize the settings, open the file:
#   src > modules > applications > settings > config_files > KeePassXC.ini

Set-MyAppsSetting -KeePassXC

# Disabled | Enabled
Set-KeePassXCRunAtStartup -State 'Disabled'

#endregion keepassxc


#==============================================================================
#                               Microsoft Edge
#==============================================================================
#region microsoft edge

Write-Section -Name 'Microsoft Edge' -SubSection

# Basic settings if you don't use Edge and didn't removed it.
# Prevent Edge to run all the time in the background.

# Prelaunch at startup
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-MicrosoftEdgePolicy -Prelaunch 'Disabled'

# Startup boost
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-MicrosoftEdgePolicy -StartupBoost 'Disabled'

# Continue running background extensions and apps when Microsoft Edge is closed
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-MicrosoftEdgePolicy -BackgroundMode 'Disabled'

#endregion microsoft edge


#==============================================================================
#                              Microsoft Office
#==============================================================================
#region microsoft office

Write-Section -Name 'Microsoft Office' -SubSection

#==========================================================
#                         Options
#==========================================================

#                General
#=======================================

# Privacy settings : Turn on optional connected experiences
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -ConnectedExperiences 'Disabled'

# Enable Linkedin features in my Office applications
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -LinkedinFeatures 'Disabled'

# Show the Start screen when this application starts
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -ShowStartScreen 'Disabled'


#==========================================================
#                         Privacy
#==========================================================

# Customer experience improvement program
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -Ceip 'Disabled'

# Feedback
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -Feedback 'Disabled'

# Logging
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -Logging 'Disabled'

# Telemetry
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftOfficeSetting -Telemetry 'Disabled'

#endregion microsoft office


#==============================================================================
#                               Microsoft Store
#==============================================================================
#region microsoft store

Write-Section -Name 'Microsoft Store' -SubSection

# App updates
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftStoreSetting -AutoAppsUpdates 'Enabled'

# Notifications for app installations
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftStoreSetting -AppInstallNotifications 'Enabled'

# Video autoplay
#---------------------------------------
# Disabled | Enabled (default)
Set-MicrosoftStoreSetting -VideoAutoplay 'Disabled'

#endregion microsoft store


#==============================================================================
#                                 qBittorrent
#==============================================================================
#region qbittorrent

Write-Section -Name 'qBittorrent' -SubSection

# To customize the settings, open the file:
#   src > modules > applications > settings > config_files > qBittorrent.ini

Set-MyAppsSetting -qBittorrent

#endregion qbittorrent


#==============================================================================
#                              VLC Media Player
#==============================================================================
#region vlc media player

Write-Section -Name 'VLC Media Player' -SubSection

# To customize the settings, open the file:
#   src > modules > applications > settings > config_files > VLC.ini

Set-MyAppsSetting -VLC

#endregion vlc media player


#==============================================================================
#                             Visual Studio Code
#==============================================================================
#region visual studio code

Write-Section -Name 'Visual Studio Code' -SubSection

# To customize the settings, open the file:
#   src > modules > applications > settings > config_files > VSCode.json

Set-MyAppsSetting -VSCode

#endregion visual studio code


#==============================================================================
#                               Windows Notepad
#==============================================================================
#region windows notepad

Write-Section -Name 'Windows Notepad' -SubSection

#==========================================================
#                        Appearance
#==========================================================

# Customize theme
#---------------------------------------
# System (default) | Light | Dark
Set-WindowsNotepadSetting -Theme 'System'


#==========================================================
#                     Text Formatting
#==========================================================

# Font family
#---------------------------------------
# example: Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman
Set-WindowsNotepadSetting -FontFamily 'Consolas'

# Font style
#---------------------------------------
# Regular (default) | Italic | Bold | Bold Italic
Set-WindowsNotepadSetting -FontStyle 'Regular'

# Font size
#---------------------------------------
# available GUI size: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48
# default: 11 (range 8-72)
Set-WindowsNotepadSetting -FontSize 11

# Word wrap
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -WordWrap 'Enabled'


#==========================================================
#                     Opening Notepad
#==========================================================

# Opening files
#---------------------------------------
# NewTab (default) | NewWindow
Set-WindowsNotepadSetting -OpenFile 'NewTab'

# When Notepad starts : Continue previous session
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -ContinuePreviousSession 'Disabled'


#==========================================================
#                         Spelling
#==========================================================

# Spell check
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -SpellCheck 'Disabled'

# Autocorrect
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -AutoCorrect 'Disabled'


#==========================================================
#                       AI Features
#==========================================================

# Copilot
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -Copilot 'Disabled'


#==========================================================
#                      Miscellaneous
#==========================================================

# First launch tip (tip: notepad automatically saves your progress)
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -FirstLaunchTip 'Disabled'

#endregion windows notepad


#==============================================================================
#                                Windows Photos
#==============================================================================
#region windows photos

Write-Section -Name 'Windows Photos' -SubSection

#==========================================================
#                         Settings
#==========================================================

# Customize theme
#---------------------------------------
# System | Light | Dark (default)
Set-WindowsPhotosSetting -Theme 'Dark'

# Show gallery tiles attributes
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsPhotosSetting -ShowGalleryTilesAttributes 'Enabled'

# Enable location based features
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsPhotosSetting -LocationBasedFeatures 'Disabled'

# Show iCloud photos
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsPhotosSetting -ShowICloudPhotos 'Disabled'

# Ask for permission to delete photos
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsPhotosSetting -DeleteConfirmationDialog 'Enabled'

# Mouse wheel
#---------------------------------------
# ZoomInOut (default) | NextPreviousItems
Set-WindowsPhotosSetting -MouseWheelBehavior 'ZoomInOut'

# Zoom preference (media smaller than window)
#---------------------------------------
# FitWindow | ViewActualSize (default)
Set-WindowsPhotosSetting -SmallMediaZoomPreference 'ViewActualSize'

# Performance (run in the background at startup)
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsPhotosSetting -RunAtStartup 'Disabled'

#==========================================================
#                      Miscellaneous
#==========================================================

# First Run Experience:
#   First Run Experience Dialog
#   OneDrive Promo flyout
#   Designer Editor flyout
#   ClipChamp flyout
#   AI Generative Erase tip
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsPhotosSetting -FirstRunExperience 'Disabled'

#endregion windows photos


#==============================================================================
#                            Windows Snipping Tool
#==============================================================================
#region windows snipping tool

Write-Section -Name 'Windows Snipping Tool' -SubSection

#==========================================================
#                         Snipping
#==========================================================

# Automatically copy changes
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSnippingToolSetting -AutoCopyScreenshotChangesToClipboard 'Enabled'

# Automatically save original screenshoots
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSnippingToolSetting -AutoSaveScreenshoots 'Enabled'

# Ask to save edited screenshots
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsSnippingToolSetting -AskToSaveEditedScreenshots 'Disabled'

# Multiple windows
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsSnippingToolSetting -MultipleWindows 'Disabled'

# Add border to each screenshot
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsSnippingToolSetting -ScreenshotBorder 'Disabled'

# HDR screenshot color corrector
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsSnippingToolSetting -HDRColorCorrector 'Disabled'


#==========================================================
#                     Screen recording
#==========================================================

# Automatically copy changes
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSnippingToolSetting -AutoCopyRecordingChangesToClipboard 'Enabled'

# Automatically save original screen recordings
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSnippingToolSetting -AutoSaveScreenshoots 'Enabled'

# Include microphone input by default when a screen recording starts
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsSnippingToolSetting -IncludeMicrophoneInRecording 'Disabled'

# Include system audio by default when a screen recording starts
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsSnippingToolSetting -IncludeSystemAudioInRecording 'Enabled'


#==========================================================
#                        Appearance
#==========================================================

# App theme
#---------------------------------------
# System (default) | Light | Dark
Set-WindowsSnippingToolSetting -Theme 'System'

#endregion windows snipping tool


#==============================================================================
#                               Windows Terminal
#==============================================================================
#region windows terminal

Write-Section -Name 'Windows Terminal' -SubSection

#==========================================================
#                         Startup
#==========================================================

# Default profile
#---------------------------------------
# WindowsPowerShell (default) | CommandPrompt | PowerShellCore
Set-WindowsTerminalSetting -DefaultProfile 'PowerShellCore'

# Default terminal application (e.g. command-line from Start Menu or Run dialog)
#---------------------------------------
# LetWindowsDecide | WindowsConsoleHost (default) | WindowsTerminal
Set-WindowsTerminalSetting -DefaultTerminalApp 'WindowsTerminal'

# Launch on machine startup
#---------------------------------------
# Disabled (default) | Enabled
Set-WindowsTerminalSetting -RunAtStartup 'Disabled'


#==========================================================
#                         Defaults
#==========================================================

#              Appearance
#=======================================

# Color scheme
#---------------------------------------
# CGA | Campbell (default) | Campbell Powershell | Dark+ | IBM 5153 | One Half Dark | One Half Light |
# Ottosson | Solarized Dark | Solarized Light | Tango Dark | Tango Light | Vintage
Set-WindowsTerminalSetting -DefaultColorScheme 'One Half Dark'

#               Advanced
#=======================================

# History size
#---------------------------------------
# default: 9001 | max: 32767 (even if higher value provided)
Set-WindowsTerminalSetting -DefaultHistorySize 32767

#endregion windows terminal

#endregion applications settings


#=================================================================================================================
#                                                     RamDisk
#=================================================================================================================
#region ramdisk

Write-Section -Name 'RamDisk'

# Advanced topic (a bit).

<#
  Brave (and web browsers in general) write a lot to the disk, wearing off SSD.

  Brave write a lot of temp files in the 'User Data' directory.
  It seems that everything is written to these temp files and then written to the cache ?
  e.g.
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\random-file-name.tmp"
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\random-file-name.tmp"

  Moving the Cache to a RamDisk reduce write disk, but that's not enought (because of the temp files).
  Lets move everything ('User Data' folder) to the RamDisk.
  Make some exceptions for extensions folders, bookmarks and preferences files.

  This should also make Brave (a bit) faster (will probably not be noticeable).

  SSD lifespan is pretty high nowday, so it should be fine even without a RamDisk.
  If you watch stream videos all day long, a RamDisk might be usefull.

  Let's do the same for VSCode (as it's somehow a web browser too).
#>

# Brave:
#   If you changed the user data directory with '--user-data-dir=',
#   you need to change the value of $BraveAppDataPath in
#     src > modules > ramdisk > private > Get-BraveBrowserPathInfo.ps1

# You can configure which folders/files are exclude from the RamDisk in:
#   src > modules > ramdisk > private > app_data > BraveBrowserData.ps1
#   src > modules > ramdisk > private > app_data > VSCodeData.ps1

# RamDisk application
#---------------------------------------
#Install-OSFMount

# RamDisk
#---------------------------------------
# If you have multiple Brave profile, make sure to allocate enought RAM.
# At least 512MB per profile.
# Size: number + M or G (e.g. 512M or 4G)
$AppToRamDisk = @(
    'Brave'
    #'VSCode'
)
#Set-RamDisk -Size '1G' -AppToRamDisk $AppToRamDisk

#endregion ramdisk


#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================
#region windows settings app

#==============================================================================
#                                    System
#==============================================================================
#region system

Write-Section -Name 'Windows Settings App - System'

#==========================================================
#                         Display
#==========================================================
#region display

Write-Section -Name 'Display' -SubSection

#              Brightness
#=======================================

# Brightness
#---------------------------------------
# available with a built-in display (e.g. Laptop)
# range: 0-100
Set-DisplayBrightnessSetting -Brightness 70

# Change brightness automatically when lighting changes
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayBrightnessSetting -AdjustOnLightingChanges 'Disabled'

# Change brightness based on content
#---------------------------------------
# Disabled | Enabled | BatteryOnly (default)
Set-DisplayBrightnessSetting -AdjustBasedOnContent 'Disabled'

#               Graphics
#=======================================

# Optimizations for windowed games
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -WindowedGamesOptimizations 'Disabled'

# Auto HDR
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -AutoHDR 'Disabled'

# Hardware-accelerated GPU scheduling
#---------------------------------------
# Disabled (default) | Enabled
Set-DisplayGraphicsSetting -GPUScheduling 'Enabled'

# Variable refresh rate
#---------------------------------------
# Disabled | Enabled (default)
Set-DisplayGraphicsSetting -GamesVariableRefreshRate 'Disabled'

#endregion display


#==========================================================
#                          Sound
#==========================================================
#region sound

Write-Section -Name 'Sound' -SubSection

#          More sound settings
#=======================================

# Communications > when Windows detects communications activity
#---------------------------------------
# DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent (default) | ReduceOtherSoundsBy50Percent
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

#endregion sound


#==========================================================
#                      Notifications
#==========================================================
#region notifications

Write-Section -Name 'Notifications' -SubSection

#             Notifications
#=======================================

# Notifications
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -Notifications 'Disabled' -NotificationsGPO 'NotConfigured'

# Allow notifications to play sounds
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -PlaySounds 'Disabled'

# Show notifications on the lock screen
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -ShowOnLockScreen 'Disabled' -ShowOnLockScreenGPO 'NotConfigured'

# Show reminders and incoming VoIP calls on the lock screen
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -ShowRemindersAndIncomingCallsOnLockScreen 'Disabled'

# Show notifications bell icon
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -ShowBellIcon 'Disabled'

#  Notifs from apps and other senders
#=======================================

$SendersNotifs = @(
    'Apps'
    'Autoplay'
    'BatterySaver'
    'MicrosoftStore'
    'NotificationSuggestions'
    'PrintNotification'
    'Settings'
    'StartupAppNotification'
    'Suggested'
    'WindowsBackup'
)
# State: Disabled | Enabled
Set-NotificationsSetting -AppsAndOtherSenders $SendersNotifs -State 'Disabled'

#          Additional settings
#=======================================

# Show the Windows welcome experience after updates and when signed in to show what's new and suggested
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -ShowWelcomeExperience 'Disabled' -ShowWelcomeExperienceGPO 'NotConfigured'

# Suggest ways to get the most out of Windows and finish setting up this device
#---------------------------------------
# Disabled | Enabled (default)
Set-NotificationsSetting -SuggestWaysToFinishConfig 'Disabled'

# Get tips and suggestions when using Windows
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-NotificationsSetting -TipsAndSuggestions 'Disabled' -TipsAndSuggestionsGPO 'NotConfigured'

#endregion notifications


#==========================================================
#                    Power (& battery)
#==========================================================
#region power (& battery)

Write-Section -Name 'Power (& battery)' -SubSection

# Power Mode
#---------------------------------------
# Available only when using the Balanced power plan.
# Applies only to the active power state (e.g. Laptop: PluggedIn or OnBattery).
# BestPowerEfficiency | Balanced (default) | BestPerformance
Set-PowerSetting -PowerMode 'Balanced'

# Screen, sleep, & hibernate timeouts
#=======================================

# Turn my screen off after
# Make my device sleep after
# Make my device hibernate after
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# PowerState: Screen | Sleep | Hibernate
# Timeout: value in minutes | never: 0

Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Sleep'     -Timeout 10
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Hibernate' -Timeout 60

Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Sleep'     -Timeout 5
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Hibernate' -Timeout 30

#             Energy saver
#=======================================

# Always use energy saver
#---------------------------------------
# Disabled (default) | Enabled
Set-EnergySaverSetting -AlwaysOn 'Disabled'

# Turn energy saver on automatically when battery level is at
#---------------------------------------
# default: 30 | never: 0 | always: 100
Set-EnergySaverSetting -TurnOnAtBatteryLevel 30

# Lower screen brightness when using energy saver
#---------------------------------------
# If you use a custom value and turn off the feature in the GUI,
# when you turn it back on, the default value will be used.
# Enabled: 70 (default) (range 0-99) | Disabled: 100
Set-EnergySaverSetting -LowerBrightness 70

#  Lid, power & sleep button controls
#=======================================

# Pressing the power button will make my PC
# Pressing the sleep button will make my PC
# Closing the lid will make my PC
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# ButtonControls: PowerButton | SleepButton | LidClose
# Action: DoNothing | Sleep (default) | Hibernate | ShutDown | DisplayOff

Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'LidClose'    -Action 'Sleep'

Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'LidClose'    -Action 'Sleep'

#endregion power (& battery)


#==========================================================
#                         Storage
#==========================================================
#region storage

Write-Section -Name 'Storage' -SubSection

#             Storage Sense
#=======================================

# Automatic User content cleanup
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'

# Cleanup of temporary files
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-StorageSenseSetting -CleanupTempFiles 'Enabled' -CleanupTempFilesGPO 'NotConfigured'

#endregion storage


#==========================================================
#                      Nearby sharing
#==========================================================
#region nearby sharing

Write-Section -Name 'Nearby sharing' -SubSection

# Nearby sharing
#---------------------------------------
# Disabled (default) | DevicesOnly | EveryoneNearby
Set-NearbySharingSetting -NearbySharing 'Disabled'

# Save files I receive to
#---------------------------------------
# default location: Downloads folder
#Set-NearbySharingSetting -FileSaveLocation 'X:\MySharedFiles'

#endregion nearby sharing


#==========================================================
#                       Multitasking
#==========================================================
#region multitasking

Write-Section -Name 'Multitasking' -SubSection

# Show tabs from apps when snapping or pressing Alt+Tab
#---------------------------------------
# State: TwentyMostRecent | FiveMostRecent | ThreeMostRecent (default) | Disabled
# GPO: TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured
Set-MultitaskingSetting -ShowAppsTabsOnSnapAndAltTab 'ThreeMostRecent' -ShowAppsTabsOnSnapAndAltTabGPO 'NotConfigured'

# Title bar window shake
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-MultitaskingSetting -TitleBarWindowShake 'Disabled' -TitleBarWindowShakeGPO 'NotConfigured'

#             Snap windows
#=======================================

# Snap windows
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapWindows 'Enabled'

# When I snap a window, suggest what I can snap next to it
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapSuggestions 'Enabled'

# Show snap layouts when I hover a window's maximize button
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowLayoutOnMaxButtonHover 'Enabled'

# Show snap layouts when I drag a window to the top of my screen
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowLayoutOnTopScreen 'Enabled'

# Show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -ShowSnappedWindowGroup 'Enabled'

# When I drag a window, let me snap it without dragging all the way to the screen edge
#---------------------------------------
# Disabled | Enabled (default)
Set-SnapWindowsSetting -SnapBeforeReachingScreenEdge 'Enabled'

#          Desktops (virtual)
#=======================================

# On the taskbar, show all the open windows
#---------------------------------------
# AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnTaskbar 'CurrentDesktop'

# Show all open windows when I press Alt+Tab
#---------------------------------------
# AllDesktops | CurrentDesktop (default)
Set-MultitaskingSetting -ShowAllWindowsOnAltTab 'CurrentDesktop'

#endregion multitasking


#==========================================================
#                      For developers
#==========================================================
#region for developers

Write-Section -Name 'For developers' -SubSection

# End task
#---------------------------------------
# Disabled (default) | Enabled
Set-ForDevelopersSetting -EndTask 'Disabled'

# Enable sudo
#---------------------------------------
# Disabled (default) | NewWindow | InputDisabled | Inline
Set-ForDevelopersSetting -Sudo 'Disabled'

#endregion for developers


#==========================================================
#                       Troubleshoot
#==========================================================
#region troubleshoot

Write-Section -Name 'Troubleshoot' -SubSection

# Recommended troubleshooter preference
#---------------------------------------
# Disabled | AskBeforeRunning (default) | AutoRunAndNotify | AutoRunSilently
Set-TroubleshooterPreference -Value 'Disabled'

#endregion troubleshoot


#==========================================================
#                  Projecting to this PC
#==========================================================
#region projecting to this PC

Write-Section -Name 'Projecting to this PC' -SubSection

# Projecting to this PC
#---------------------------------------
# Disabled: The PC isn't discoverable unless Wireless Display app is manually launched.
# Disabled | NotConfigured
Set-ProjectingToThisPC -GPO 'Disabled'

#endregion projecting to this PC


#==========================================================
#                      Remote desktop
#==========================================================
#region remote desktop

Write-Section -Name 'Remote desktop' -SubSection

# Remote desktop
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-RemoteDesktopSetting -RemoteDesktop 'Disabled' -RemoteDesktopGPO 'NotConfigured'

# Require devices to use Network Level Authentication to connect
#---------------------------------------
# Disabled | Enabled (default)
Set-RemoteDesktopSetting -NetworkLevelAuthentication 'Enabled'

# Remote desktop port
#---------------------------------------
# default: 3389
#Set-RemoteDesktopSetting -PortNumber 3389

#endregion remote desktop


#==========================================================
#                        Clipboard
#==========================================================
#region clipboard

Write-Section -Name 'Clipboard' -SubSection

# Clipboard history
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -History 'Disabled' -HistoryGPO 'NotConfigured'

# Sync across your devices
#---------------------------------------
# State: Disabled (default) | AutoSync | ManualSync
# GPO: Disabled | Enabled | NotConfigured
Set-ClipboardSetting -SyncAcrossDevices 'Disabled' -SyncAcrossDevicesGPO 'NotConfigured'

# Suggested actions | deprecated
#---------------------------------------
# Disabled | Enabled (default)
Set-ClipboardSetting -SuggestedActions 'Disabled'

#endregion clipboard


#==========================================================
#                    Optional features
#==========================================================
#region optional features

Write-Section -Name 'Optional features' -SubSection

Export-InstalledWindowsCapabilitiesNames
Export-EnabledWindowsOptionalFeaturesNames

$OptionalFeatures = @(
    # Features
    #-----------------
    'ExtendedThemeContent'
    'FacialRecognitionWindowsHello'
    'InternetExplorerMode'
    'MathRecognizer'
    'NotepadSystem'
    'OneSync'
    'OpenSSHClient'
    'PrintManagement'
    'StepsRecorder'
    'WMIC'
    'VBScript'
    'WindowsFaxAndScan'
    'WindowsMediaPlayerLegacy'
    'WindowsPowerShellISE'
    'WordPad'
    'XpsViewer'

    # More Windows features
    #-----------------
    'InternetPrintingClient'
    'MediaFeatures'
    'MicrosoftXpsDocumentWriter'
    'NetFramework48TcpPortSharing'
    'RemoteDesktopConnection'
    'RemoteDiffCompressionApiSupport'
    'SmbDirect'
    'WindowsPowerShell2'
    'WindowsRecall'
    'WorkFoldersClient'
)
$OptionalFeatures | Remove-PreinstalledOptionalFeature

#endregion optional features

#endregion system


#==============================================================================
#                             Bluetooth & devices
#==============================================================================
#region bluetooth & devices

Write-Section -Name 'Windows Settings App - Bluetooth & devices'

#==========================================================
#                         Devices
#==========================================================
#region devices

Write-Section -Name 'Devices' -SubSection

# Bluetooth
#---------------------------------------
# Disabled | NotConfigured
Set-BluetoothSetting -BluetoothGPO 'NotConfigured'

# Show notifications to connect using Swift Pair
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-BluetoothSetting -ShowQuickPairConnectionNotif 'Enabled' -ShowQuickPairConnectionNotifGPO 'NotConfigured'

# Download over metered connections (device software (drivers, info, and apps))
#---------------------------------------
# Disabled (default) | Enabled
Set-DevicesSetting -DownloadOverMeteredConnections 'Disabled'

# Use LE Audio when available
#---------------------------------------
# Disabled | Enabled (default)
Set-BluetoothSetting -LowEnergyAudio 'Enabled'

# Bluetooth devices discovery | deprecated
#---------------------------------------
# Default (default) | Advanced
Set-BluetoothSetting -DiscoveryMode 'Default'

#endregion devices


#==========================================================
#                   Printers & scanners
#==========================================================
#region printers & scanners

Write-Section -Name 'Printers & scanners' -SubSection

# Let Windows manage my default printer
#---------------------------------------
# Disabled | Enabled (default)
Set-DevicesSetting -DefaultPrinterSystemManaged 'Disabled'

#endregion printers & scanners


#==========================================================
#                      Mobile devices
#==========================================================
#region mobile devices

Write-Section -Name 'Mobile devices' -SubSection

# Allow this PC to access your mobile devices
#---------------------------------------
# Disabled (default) | Enabled
Set-MobileDevicesSetting -MobileDevices 'Disabled'

# Phone Link
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-MobileDevicesSetting -PhoneLink 'Disabled' -PhoneLinkGPO 'NotConfigured'

# Show me suggestions for using my mobile device with Windows
#---------------------------------------
# Disabled | Enabled (default)
Set-MobileDevicesSetting -ShowUsageSuggestions 'Disabled'

#endregion mobile devices


#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# Primary mouse button
#---------------------------------------
# Left (default) | Right
Set-MouseSetting -PrimaryButton 'Left'

# Mouse pointer speed
#---------------------------------------
# default: 10 (range 1-20)
Set-MouseSetting -PointerSpeed 10

# Enhance pointer precision
#---------------------------------------
# Disabled | Enabled (default)
Set-MouseSetting -EnhancedPointerPrecision 'Enabled'

#               Scrolling
#=======================================

# Roll the mouse wheel to scroll
# Lines to scroll at a time
#---------------------------------------
# MultipleLines (default) | OneScreen
# WheelScrollLinesToScroll: 3 (default) (range 1-100)
#Set-MouseSetting -WheelScroll 'OneScreen'
Set-MouseSetting -WheelScroll 'MultipleLines' -WheelScrollLinesToScroll 3

# Scroll inactive windows when hovering over them
#---------------------------------------
# Disabled | Enabled (default)
Set-MouseSetting -ScrollInactiveWindowsOnHover 'Enabled'

# Scrolling direction
#---------------------------------------
# DownMotionScrollsDown (default) | DownMotionScrollsUp
Set-MouseSetting -ScrollingDirection 'DownMotionScrollsDown'

#endregion mouse


#==========================================================
#                         Touchpad
#==========================================================
#region touchpad

Write-Section -Name 'Touchpad' -SubSection

# Touchpad
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -Touchpad 'Enabled'

# Leave touchpad on when a mouse is connected
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -LeaveOnWithMouse 'Enabled'

# Cursor speed
#---------------------------------------
# default: 5 (range 1-10)
Set-TouchpadSetting -CursorSpeed 5

#                 Taps
#=======================================

# Touchpad sensitivity
#---------------------------------------
# Max | High | Medium (default) | Low
Set-TouchpadSetting -Sensitivity 'Medium'

# Tap with a single finger to single-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TapToClick 'Enabled'

# Tap with two fingers to right-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TwoFingersTapToRightClick 'Enabled'

# Tap twice and drag to multi-select
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TapTwiceAndDragToMultiSelect 'Enabled'

# Press the lower right corner of the touchpad to right-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -RightClickButton 'Enabled'

#             Scroll & zoom
#=======================================

# Drag two fingers to scroll
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TwoFingersToScroll 'Enabled'

# Scrolling direction
#---------------------------------------
# DownMotionScrollsDown | DownMotionScrollsUp (default)
Set-TouchpadSetting -ScrollingDirection 'DownMotionScrollsUp'

# Pinch to zoom
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -PinchToZoom 'Enabled'

#         Three-finger gestures
#=======================================

# Taps
#---------------------------------------
# Nothing | OpenSearch (default) | NotificationCenter | PlayPause |
# MiddleMouseButton | MouseBackButton | MouseForwardButton
Set-TouchpadSetting -ThreeFingersTap 'OpenSearch'

# Swipes
#---------------------------------------
# Nothing | SwitchAppsAndShowDesktop (default) | SwitchDesktopsAndShowDesktop | ChangeAudioAndVolume | Custom
Set-TouchpadSetting -ThreeFingersSwipes 'SwitchAppsAndShowDesktop'

# Nothing | SwitchApps (left/right) | TaskView (up) | ShowDesktop (down) | SwitchDesktops | HideAllExceptAppInFocus |
# CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation | SnapWindowToLeft | SnapWindowToRight |
# MaximizeWindow | MinimizeWindow | NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute
$ThreeFingersSwipesCustom = @{
    ThreeFingersUp    = 'TaskView'
    ThreeFingersDown  = 'ShowDesktop'
    ThreeFingersLeft  = 'SwitchApps'
    ThreeFingersRight = 'SwitchApps'
}
#Set-TouchpadSetting -ThreeFingersSwipes 'Custom' @ThreeFingersSwipesCustom

#         Four-finger gestures
#=======================================

# Taps
#---------------------------------------
# Nothing | OpenSearch | NotificationCenter (default) | PlayPause |
# MiddleMouseButton | MouseBackButton | MouseForwardButton
Set-TouchpadSetting -FourFingersTap 'NotificationCenter'

# Swipes
#---------------------------------------
# Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop (default) | ChangeAudioAndVolume | Custom
Set-TouchpadSetting -FourFingersSwipes 'SwitchDesktopsAndShowDesktop'

# Nothing | SwitchApps | TaskView (up) | ShowDesktop (down) | SwitchDesktops (left/right) | HideAllExceptAppInFocus |
# CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation | SnapWindowToLeft | SnapWindowToRight |
# MaximizeWindow | MinimizeWindow | NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute
$FourFingersSwipesCustom = @{
    FourFingersUp    = 'TaskView'
    FourFingersDown  = 'ShowDesktop'
    FourFingersLeft  = 'SwitchDesktops'
    FourFingersRight = 'SwitchDesktops'
}
#Set-TouchpadSetting -FourFingersSwipes 'Custom' @FourFingersSwipesCustom

#endregion touchpad


#==========================================================
#                         AutoPlay
#==========================================================
#region autoplay

Write-Section -Name 'AutoPlay' -SubSection

# Use AutoPlay for all media and devices
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AutoPlaySetting -AutoPlay 'Enabled' -AutoPlayGPO 'NotConfigured'

#endregion autoplay


#==========================================================
#                           USB
#==========================================================
#region usb

Write-Section -Name 'USB' -SubSection

# Connection notifications (if issues with USB)
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -NotifOnErrors 'Enabled'

# USB battery saver
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -BatterySaver 'Enabled'

# Show a notification if this PC is charging slowly over USB
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -NotifOnWeakCharger 'Enabled'

#endregion usb

#endregion bluetooth & devices


#==============================================================================
#                              Network & internet
#==============================================================================
#region network & internet

Write-Section -Name 'Windows Settings App - Network & internet'

#==========================================================
#                     Ethernet / Wi-Fi
#==========================================================
#region ethernet / wi-fi

Write-Section -Name 'Ethernet / Wi-Fi' -SubSection

#              Properties
#=======================================

# Network profile
#---------------------------------------
# Change all currently connected network.
# Public (default) | Private | DomainAuthenticated
Set-NetworkSetting -ConnectedNetworkProfile 'Private'

#endregion ethernet / wi-fi


#==========================================================
#                          Proxy
#==========================================================
#region proxy

Write-Section -Name 'Proxy' -SubSection

# Automatically detect settings
#---------------------------------------
# Disabled | Enabled (default)
Set-NetworkSetting -ProxyAutoDetectSettings 'Enabled'

#endregion proxy


#==========================================================
#                Advanced network settings
#==========================================================
#region advanced network settings

Write-Section -Name 'Advanced network settings' -SubSection

#           Ethernet / Wi-Fi
#=======================================

# View additional properties > DNS server assignment
#---------------------------------------
# ResetServerAddresses
# FallbackToPlaintext (not available for Mullvad)
# Adguard: Default | Unfiltered | Family
# Cloudflare: Default | Security | Family
# Dns0: Default | Zero | Kids
# Mullvad: Default | Adblock | Base | Extended | Family | All
# Quad9: Default | Unfiltered

#Set-DnsServer -ResetServerAddresses
Set-DnsServer -Cloudflare 'Default'

#endregion advanced network settings

#endregion network & internet


#==============================================================================
#                               Personnalization
#==============================================================================
#region personnalization

Write-Section -Name 'Windows Settings App - Personnalization'

#==========================================================
#                        Background
#==========================================================
#region background

Write-Section -Name 'Background' -SubSection

# Personalize your background
#---------------------------------------
# default: Windows spotlight

#                Picture
#=======================================

# Choose a photo
#---------------------------------------
# Default images location: C:\Windows\Web\Wallpaper
# default: "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
# ThemeA: Glow | ThemeB: Captured Motion | ThemeC: Sunrive | ThemeD: Flow
Set-BackgroundSetting -Wallpaper "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"

# Choose a fit for your desktop image
#---------------------------------------
# Fill (default) | Fit | Stretch | Span | Tile | Center
Set-BackgroundSetting -WallpaperStyle 'Fill'

#endregion background


#==========================================================
#                          Colors
#==========================================================
#region colors

Write-Section -Name 'Colors' -SubSection

# Choose your mode
#---------------------------------------
# Dark | Light (default)
Set-ColorsSetting -Theme 'Dark'
#Set-ColorsSetting -AppsTheme 'Dark' -SystemTheme 'Dark'

# Transparency effects
#---------------------------------------
# Disabled | Enabled (default)
Set-ColorsSetting -Transparency 'Enabled'

# Accent color
#---------------------------------------
# default manual color: blue (#0078D4)
# Manual | Automatic (default)
Set-ColorsSetting -AccentColorMode 'Manual'

# Show accent color on Start and taskbar (requires Dark mode)
#---------------------------------------
# Disabled (default) | Enabled
Set-ColorsSetting -ShowAccentColorOnStartAndTaskbar 'Disabled'

# Show accent color on title bars and windows borders
#---------------------------------------
# Disabled (default) | Enabled
Set-ColorsSetting -ShowAccentColorOnTitleAndBorders 'Disabled'

#endregion colors


#==========================================================
#                          Themes
#==========================================================
#region themes

Write-Section -Name 'Themes' -SubSection

#         Desktop icon settings
#=======================================

# Desktop icons
#---------------------------------------
$DesktopIcons = @(
    'ThisPC'
    #'UserFiles'
    'Network'
    'RecycleBin'
    #'ControlPanel'
)
#Set-ThemesSetting -DesktopIcons $DesktopIcons
Set-ThemesSetting -HideAllDesktopIcons

# Allow themes to change desktop icons
#---------------------------------------
# Disabled | Enabled (default)
Set-ThemesSetting -ThemesCanChangeDesktopIcons 'Disabled'

#endregion themes


#==========================================================
#                     Dynamic Lighting
#==========================================================
#region dynamic lighting

Write-Section -Name 'Dynamic Lighting' -SubSection

# Use Dynamic Lighting on my device
#---------------------------------------
# Disabled | Enabled (default)
Set-DynamicLightingSetting -DynamicLighting 'Disabled'

# Compatible apps in the foreground always control lighting
#---------------------------------------
# Disabled | Enabled (default)
Set-DynamicLightingSetting -ControlledByForegroundApp 'Disabled'

#endregion dynamic lighting


#==========================================================
#                       Lock screen
#==========================================================
#region lock screen

Write-Section -Name 'Lock screen' -SubSection

# Personalize your lock screen
#---------------------------------------
# default: Windows spotlight
# Picture choice is not handled.
# Default images location: C:\Windows\Web\Screen
Set-LockScreenSetting -SetToPicture

# Get fun facts, tips, tricks, and more on your lock screen
#---------------------------------------
# If disabled, Windows spotlight will be unset.
# Disabled | Enabled (default)
Set-LockScreenSetting -GetFunFactsTipsTricks 'Disabled'

# Show the lock screen background picture on the sign-in screen
#---------------------------------------
# Disabled | NotConfigured
Set-LockScreenSetting -ShowPictureOnSigninScreenGPO 'NotConfigured'

# Your widgets
#---------------------------------------
# Windows 11 24H2+ only.
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-LockScreenSetting -YourWidgets 'Disabled' -YourWidgetsGPO 'NotConfigured'

#endregion lock screen


#==========================================================
#                          Start
#==========================================================
#region start

Write-Section -Name 'Start' -SubSection

# Layout
#---------------------------------------
# Default (default) | MorePins | MoreRecommendations
Set-StartSetting -LayoutMode 'Default'

# Show recently added apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-StartSetting -ShowRecentlyAddedApps 'Disabled' -ShowRecentlyAddedAppsGPO 'NotConfigured'

# Show most used apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowMostUsedApps 'Disabled' -ShowMostUsedAppsGPO 'NotConfigured'

# Show recommended files in Start, recent files in File Explorer, and items in Jump Lists
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowRecentlyOpenedItems 'Enabled' -ShowRecentlyOpenedItemsGPO 'NotConfigured'

# Show recommendations for tips, shortcuts, new apps, and more
#---------------------------------------
# Disabled | Enabled (default)
Set-StartSetting -ShowRecommendations 'Disabled'

# Show account-related notifications
#---------------------------------------
# Disabled | Enabled (default)
Set-StartSetting -ShowAccountNotifications 'Disabled'

# Folders (choose which folders appear on Start next to the Power button)
#---------------------------------------
# Windows 11 only.
$StartMenuFolders = @(
    'Settings'
    #'FileExplorer'
    #'Network'
    'PersonalFolder'
    #'Documents'
    #'Downloads'
    #'Music'
    #'Pictures'
    #'Videos'
)
Set-StartSetting -FoldersNextToPowerButton $StartMenuFolders
#Set-StartSetting -HideAllFoldersNextToPowerButton

# Show mobile device in Start
#---------------------------------------
# Disabled (default) | Enabled
Set-StartSetting -ShowMobileDevice 'Disabled'

#endregion start


#==========================================================
#                         Taskbar
#==========================================================
#region taskbar

Write-Section -Name 'Taskbar' -SubSection

#             Taskbar items
#=======================================

# Search
#---------------------------------------
# State: Hide | IconOnly | Box (default) | IconAndLabel
# GPO: Hide | IconOnly | Box | IconAndLabel | NotConfigured
Set-TaskbarSetting -SearchBox 'Hide' -SearchBoxGPO 'NotConfigured'

# Task view
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -TaskView 'Disabled' -TaskViewGPO 'NotConfigured'

#           System tray icons
#=======================================

# Emoji and more
#---------------------------------------
# Never | WhileTyping (default) | Always
Set-TaskbarSetting -EmojiAndMore 'Never'

# Pen menu
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -PenMenu 'Disabled'

# Touch keyboard
#---------------------------------------
# Never | Always | WhenNoKeyboard (default)
Set-TaskbarSetting -TouchKeyboard 'Never'

# Virtual touchpad
#---------------------------------------
# Disabled (default) | Enabled
Set-TaskbarSetting -VirtualTouchpad 'Disabled'

#        Other system tray icons
#=======================================

# Hidden icon menu
#---------------------------------------
# If disabled, don't forget to manually turn on icons you want to be visible.
# Disabled | Enabled (default)
Set-TaskbarSetting -HiddenIconMenu 'Enabled'

#           Taskbar behaviors
#=======================================

# Taskbar alignment
#---------------------------------------
# Left | Center (default)
Set-TaskbarSetting -Alignment 'Center'

# Automatically hide the taskbar
#---------------------------------------
# Disabled (default) | Enabled
Set-TaskbarSetting -AutoHide 'Disabled'

# Show badges on taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowAppsBadges 'Enabled'

# Show flashing on taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowAppsFlashing 'Enabled'

# Show my taskbar on all displays
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -ShowOnAllDisplays 'Disabled' -ShowOnAllDisplaysGPO 'NotConfigured'

# When using multiple displays, show my taskbar apps on
#---------------------------------------
# AllTaskbars (default) | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen
Set-TaskbarSetting -ShowAppsOnMultipleDisplays 'AllTaskbars'

# Share any window from my taskbar
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShareAnyWindow 'Enabled'

# Select the far corner of the taskbar to show the desktop
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -FarCornerToShowDesktop 'Enabled'

# Combine taskbar buttons and hide labels
#---------------------------------------
# State: Always (default) | WhenTaskbarIsFull | Never
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -GroupAndHideLabelsMainTaskbar 'Always' -GroupAndHideLabelsGPO 'NotConfigured'

# Combine taskbar buttons and hide labels on other taskbars
#---------------------------------------
# Always (default) | WhenTaskbarIsFull | Never
Set-TaskbarSetting -GroupAndHideLabelsOtherTaskbars 'Always'

# Show hover cards for inactive and pinned taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowJumplistOnHover 'Disabled'

#endregion taskbar


#==========================================================
#                       Device usage
#==========================================================
#region device usage

Write-Section -Name 'Device usage' -SubSection

# default: Disabled
$DeviceUsageOption = @(
    #'Creativity'
    #'Business'
    #'Development'
    'Entertainment'
    #'Family'
    #'Gaming'
    #'School'
)
#Set-DeviceUsageSetting -Value $DeviceUsageOption
Set-DeviceUsageSetting -DisableAll

#endregion device usage

#endregion personnalization


#==============================================================================
#                                     Apps
#==============================================================================
#region apps

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

#endregion apps


#==============================================================================
#                                   Accounts
#==============================================================================
#region accounts

Write-Section -Name 'Windows Settings App - Accounts'

#==========================================================
#                        Your info
#==========================================================
#region your info

Write-Section -Name 'Your info' -SubSection

# Account setting
#---------------------------------------
# Enabled: also disable and gray out 'settings > bluetooth & devices > mobile devices'
# CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured
Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured'

#endregion your info


#==========================================================
#                     Sign-in options
#==========================================================
#region sign-in options

Write-Section -Name 'Sign-in options' -SubSection

# Biometrics
#---------------------------------------
# Disabled | NotConfigured
Set-SigninOptionsSetting -BiometricsGPO 'NotConfigured'

# Sign in with an external camera or fingerprint reader
#---------------------------------------
# Requires compatible hardware and software components to have this option visible.
# Disabled | Enabled (default)
Set-SigninOptionsSetting -SigninWithExternalDevice 'Enabled'

# For improved security, only allow Windows Hello sign-in for Microsoft accounts on this device
#---------------------------------------
# Requires a Microsoft account to have this option visible.
# Disabled (default) | Enabled
Set-SigninOptionsSetting -OnlyWindowsHelloForMSAccount 'Disabled'

# If you've been away, when should Windows require you to sign in again
#---------------------------------------
# Only available if your account has a password.
# Standard Standby (S3): Never | OnWakesUpFromSleep (default)
# Modern Standby (S0): Never | Always (default) | OneMin | ThreeMins | FiveMins | FifteenMins
Set-SigninOptionsSetting -SigninRequiredIfAway 'Never'

# Dynamic lock : Allow Windows to automatically lock your device when you're away
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | Enabled | NotConfigured
Set-SigninOptionsSetting -DynamicLock 'Disabled' -DynamicLockGPO 'NotConfigured'

# Automatically save my restartable apps and restart them when I sign back in
#---------------------------------------
# Disabled | Enabled (default)
Set-SigninOptionsSetting -AutoRestartApps 'Disabled'

# Show account details such as my email address on the sign-in screen
#---------------------------------------
# Disabled | NotConfigured
Set-SigninOptionsSetting -ShowAccountDetailsGPO 'NotConfigured'

# Use my sign-in info to automatically finish setting up after an update
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-SigninOptionsSetting -AutoFinishSettingUpAfterUpdate 'Disabled' -AutoFinishSettingUpAfterUpdateGPO 'NotConfigured'

#endregion sign-in options

#endregion accounts


#==============================================================================
#                               Time & language
#==============================================================================
#region time & language

Write-Section -Name 'Windows Settings App - Time & language'

#==========================================================
#                       Date & time
#==========================================================
#region date & time

Write-Section -Name 'Date & time' -SubSection

# Set time zone automatically
#---------------------------------------
# Already disabled if location permission is off.
# Disabled | Enabled (default)
Set-DateAndTimeSetting -AutoTimeZone 'Disabled'

# Set time automatically
#---------------------------------------
# Disabled | Enabled (default)
Set-DateAndTimeSetting -AutoTime 'Enabled'

# Show time and date in the System tray
#---------------------------------------
# Disabled | Enabled (default)
Set-DateAndTimeSetting -ShowInSystemTray 'Enabled'

# Show abbreviated time and date
#---------------------------------------
# Disabled (default) | Enabled
Set-DateAndTimeSetting -ShowAbbreviatedValue 'Disabled'

# Show seconds in system tray clock (uses more power)
#---------------------------------------
# Disabled (default) | Enabled
Set-DateAndTimeSetting -ShowSecondsInSystemClock 'Disabled'

# Internet time (NTP server)
#---------------------------------------
# Windows (default) | NistGov | PoolNtpOrg
Set-DateAndTimeSetting -TimeServer 'Windows'

#endregion date & time


#==========================================================
#                    Language & region
#==========================================================
#region language & region

Write-Section -Name 'Language & region' -SubSection

#          Preferred Languages
#=======================================

# Language Options
#---------------------------------------
# Basic typing, Handwriting, OCR, Text-To-Speech, Speech recognition
#Remove-LanguageFeatures

#            Regional format
#=======================================

# First day of week
#---------------------------------------
# Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
Set-LanguageAndRegionSetting -FirstDayOfWeek 'Monday'

# Short date
#---------------------------------------
# e.g. 05-Apr-42: dd-MMM-yy
Set-LanguageAndRegionSetting -ShortDateFormat 'dd-MMM-yy'

#   Administrative language settings
#=======================================

# Language for non-Unicode programs:
#   Beta: Use Unicode UTF-8 for worldwide language support
#---------------------------------------
# Disabled (default) | Enabled
Set-LanguageAndRegionSetting -Utf8ForNonUnicodePrograms 'Enabled'

#endregion language & region


#==========================================================
#                          Typing
#==========================================================
#region typing

Write-Section -Name 'Typing' -SubSection

# Show text suggestions when typing on the software keyboard
#---------------------------------------
# Only works on Windows 10 ? (setting not present on Windows 11)
# Disabled (default) | Enabled
Set-TypingSetting -ShowTextSuggestionsOnSoftwareKeyboard 'Disabled'

# Show text suggestions when typing on the physical keyboard
#---------------------------------------
# Disabled (default) | Enabled
Set-TypingSetting -ShowTextSuggestionsOnPhysicalKeyboard 'Disabled'

# Multilingual text suggestions
#---------------------------------------
# Disabled (default) | Enabled
Set-TypingSetting -MultilingualTextSuggestions 'Disabled'

# Autocorrect misspelled words
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -AutocorrectMisspelledWords 'Disabled'

# Highlight misspelled words
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -HighlightMisspelledWords 'Disabled'

# Typing insights
#---------------------------------------
# Disabled | Enabled (default)
Set-TypingSetting -TypingAndCorrectionHistory 'Disabled'

#      Advanced keyboard settings
#=======================================

# Input language hot keys
#---------------------------------------
# 'Win + Space' is not affected by the follwing settings.

# Switch Input Language
# NotAssigned | CtrlShift | LeftAltShift (default) | GraveAccent
Set-TypingSetting -SwitchInputLanguageHotKey 'NotAssigned'

# Switch Keyboard Layout
# NotAssigned | CtrlShift (default) | LeftAltShift | GraveAccent
Set-TypingSetting -SwitchKeyboardLayoutHotKey 'NotAssigned'

#endregion typing

#endregion time & language


#==============================================================================
#                                    Gaming
#==============================================================================
#region gaming

Write-Section -Name 'Windows Settings App - Gaming'

#==========================================================
#                         Game Bar
#==========================================================
#region game bar

Write-Section -Name 'Game Bar' -SubSection

# Allow your controller to open Game Bar
#---------------------------------------
# Disabled (default) | Enabled
Set-GamingSetting -OpenGameBarWithController 'Disabled'

#endregion game bar


#==========================================================
#                         Captures
#==========================================================
#region captures

Write-Section -Name 'Captures' -SubSection

# Record what happened
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-GamingSetting -GameRecording 'Disabled' -GameRecordingGPO 'NotConfigured'

#endregion captures


#==========================================================
#                        Game Mode
#==========================================================
#region game mode

Write-Section -Name 'Game Mode' -SubSection

# Game Mode
#---------------------------------------
# Disabled | Enabled (default)
Set-GamingSetting -GameMode 'Disabled'

#endregion game mode

#endregion gaming


#==============================================================================
#                                Accessibility
#==============================================================================
#region accessibility

Write-Section -Name 'Windows Settings App - Accessibility'

#==========================================================
#                      Visual effects
#==========================================================
#region visual effects

Write-Section -Name 'Visual effects' -SubSection

# Always show scrollbars
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -VisualEffectsAlwaysShowScrollbars 'Disabled'

# Animation effects
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -VisualEffectsAnimation 'Enabled'

# Dismiss notifications after this amount of time
#---------------------------------------
# default (and minimum): 5 seconds
Set-AccessibilitySetting -VisualEffectsNotificationsDuration 5

#endregion visual effects


#==========================================================
#                     Contrast themes
#==========================================================
#region contrast themes

Write-Section -Name 'Contrast themes' -SubSection

# Keyboard shorcut for contrast themes
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -ContrastThemesKeyboardShorcut 'Disabled'

#endregion contrast themes


#==========================================================
#                         Narrator
#==========================================================
#region narrator

Write-Section -Name 'Narrator' -SubSection

# Keyboard shorcut for Narrator
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -NarratorKeyboardShorcut 'Disabled'

# Automatically send diagnostic and performance data
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -NarratorAutoSendTelemetry 'Disabled'

#endregion narrator


#==========================================================
#                          Speech
#==========================================================
#region speech

Write-Section -Name 'Speech' -SubSection

# Keyboard shorcut for Voice typing
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -VoiceTypingKeyboardShorcut 'Disabled'

#endregion speech


#==========================================================
#                         Keyboard
#==========================================================
#region keyboard

Write-Section -Name 'Keyboard' -SubSection

# Use the Print screen key to open screen capture
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardPrintScreenKeyOpenScreenCapture 'Disabled'

#              Sticky keys
#=======================================

# Sticky keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardStickyKeys 'Disabled'

# Keyboard shorcut for Sticky keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardStickyKeysShorcut 'Disabled'

#              Filter keys
#=======================================

# Filter keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardFilterKeys 'Disabled'

# Keyboard shorcut for Filter keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -KeyboardFilterKeysShorcut 'Disabled'

#              Toggle keys
#=======================================

# Toggle keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardToggleKeysTone 'Disabled'

# Keyboard shorcut for Toggle keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -KeyboardToggleKeysToneShorcut 'Disabled'

#endregion keyboard


#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# Mouse keys
#---------------------------------------
# Disabled (default) | Enabled
Set-AccessibilitySetting -MouseKeys 'Disabled'

# Keyboard shorcut for Mouse keys
#---------------------------------------
# Disabled | Enabled (default)
Set-AccessibilitySetting -MouseKeysShorcut 'Disabled'

#endregion mouse

#endregion accessibility


#==============================================================================
#                              Privacy & security
#==============================================================================
#region privacy & security

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
# State: Disabled | Enabled (default)
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

#endregion privacy & security


#==============================================================================
#                       Windows Security (aka Defender)
#==============================================================================
#region defender

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
#                Account Protection
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

#endregion defender


#==============================================================================
#                                Windows Update
#==============================================================================
#region windows update

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

#endregion windows update

#endregion windows settings app


#=================================================================================================================
#                                           Services & Scheduled Tasks
#=================================================================================================================
#region services & scheduled tasks

Write-Section -Name 'Services & Scheduled Tasks'

#==============================================================================
#                                   Services
#==============================================================================
#region services

Write-Section -Name 'Services' -SubSection

Export-DefaultServicesStartupType
Export-DefaultSystemDriversStartupType

<#
  You can review the services StartupType in: src > modules > services > private.

  Make sure to review every services and configure them according to your usage.
  (especially Features.ps1 and Miscellaneous.ps1 which contains unrelated services in the same group)

  If you want to let the default setting, comment the services group below (e.g. #'FileAndPrinterSharing').

  ThirdParty services (e.g. AdobeAcrobat, Intel, Nvidia):
    Will be set back to 'DefaultType' on each app update.
    Need to be reapplied (or automated) if desired.

  To use a printer occasionally, you only need these two services: 'Print Spooler' and 'SSDP Discovery'.
  If disabled as part of this script, launch them manually with services.msc when needed.
#>

$ServicesToConfig = @(
    # SystemDriver
    #-----------------
    'UserChoiceProtectionDriver'
    #'BridgeDriver'
    #'NetBiosDriver'
    #'LldpDriver'
    #'LltdDriver'
    #'MicrosoftMultiplexorDriver'
    #'QosPacketSchedulerDriver'
    #'OfflineFilesDriver'
    #'NetworkDataUsageDriver'

    # Windows
    #-----------------
    #'Autoplay'
    #'Bluetooth'
    #'BluetoothAndCast'
    #'BluetoothAudio'
    'DefenderPhishingProtection'
    'Deprecated'
    'DiagnosticAndUsage'
    'Features'
    'FileAndPrinterSharing'
    'HyperV'
    #'MicrosoftEdge'
    #'MicrosoftOffice'
    'MicrosoftStore'
    'Miscellaneous'
    'Network'
    #'NetworkDiscovery'
    'Printer'
    'RemoteDesktop'
    'Sensor'
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    #'Vpn'
    #'Webcam'
    'WindowsBackupAndSystemRestore'
    'WindowsSearch'
    'WindowsSubsystemForLinux'
    'Xbox'

    # ThirdParty
    #-----------------
    #'AdobeAcrobat'
    'Intel'
    #'Nvidia'
)
$ServicesToConfig | Set-ServiceStartupTypeGroup

#endregion services


#==============================================================================
#                               Scheduled Tasks
#==============================================================================
#region scheduled tasks

Write-Section -Name 'Scheduled Tasks' -SubSection

Export-DefaultScheduledTasksState

<#
  You can review which tasks are disabled in: src > modules > scheduled_tasks > private.

  If you use a specific feature, do not disable the related task.
    Add 'SkipTask = $true' to use the default setting.
    Use 'SkipTask = $false' (or delete the key) and change 'Disabled' to 'Enabled' to enable the task.
    e.g. in Features.ps1
    @{
        SkipTask = $true
        TaskPath = '\Microsoft\Windows\SystemRestore\'
        Task     = @{
            SR = 'Disabled'
        }
    }
#>

$TasksToConfig = @(
    #'AdobeAcrobat'
    'Features'
    #'MicrosoftEdge'
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'TelemetryDiagnostic'
    'UserChoiceProtectionDriver'
)
$TasksToConfig | Set-ScheduledTaskStateGroup

#endregion scheduled tasks

#endregion services & scheduled tasks

Stop-Transcript
