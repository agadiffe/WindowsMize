#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

<#
  This file is the equivalent of all functions within the 'scripts' folder.
  It doesn't include any comments or parameter value choices.
#>

#Requires -RunAsAdministrator
#Requires -Version 7.5

if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
{
    Write-Error 'The script cannot be run: LanguageMode is set to ConstrainedLanguage.'
    exit
}

$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\src\modules\helper_functions\general"

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\$ScriptFileName.log"

$WindowsMizeModulesNames = @(
    'tweaks'
    'telemetry'
    'network'
    'power_options'
    'system_properties'
    'file_explorer'
    'applications\management'
    'applications\settings'
    'ramdisk'
    'settings_app\system'
    'settings_app\optional_features'
    'settings_app\bluetooth_&_devices'
    'settings_app\network_&_internet'
    'settings_app\personnalization'
    'settings_app\apps'
    'settings_app\accounts'
    'settings_app\time_&_language'
    'settings_app\gaming'
    'settings_app\accessibility'
    'settings_app\privacy_&_security'
    'settings_app\defender_security_center'
    'settings_app\windows_update'
    'services'
    'scheduled_tasks'
)
Write-Output -InputObject 'Loading WindowsMize Modules ...'
Import-Module -Name $WindowsMizeModulesNames.ForEach({ "$PSScriptRoot\src\modules\$_" })


#=================================================================================================================
#                                                Settings - Part 1
#=================================================================================================================
#region PART 1

#             File Explorer
#=======================================
#region file Explorer

$FileExplorerSettings = @{
    # --- General
    LaunchTo                         = 'Home'
    #OpenFolder                       = 'SameWindow'
    #OpenFolderInNewTab               = 'Enabled'
    #OpenItem                         = 'DoubleClick'
    ShowRecentFiles                  = 'Enabled'
    ShowFrequentFolders              = 'Disabled'
    ShowCloudFiles                   = 'Disabled'

    # --- View
    #ShowIconsOnly                    = 'Disabled'
    CompactView                      = 'Enabled'
    #ShowFileIconOnThumbnails         = 'Enabled'
    #ShowFileSizeInFolderTips         = 'Enabled'
    #ShowFullPathInTitleBar           = 'Disabled'
    ShowHiddenItems                  = 'Enabled'
    #HideEmptyDrives                  = 'Enabled'
    HideFileExtensions               = 'Disabled'
    HideFolderMergeConflicts         = 'Disabled'
    #HideProtectedSystemFiles         = 'Enabled'
    #LaunchFolderInSeparateProcess    = 'Disabled'
    #RestorePreviousFoldersAtLogon    = 'Disabled'
    #ShowDriveLetters                 = 'Enabled'
    #ColorEncryptedAndCompressedFiles = 'Disabled'
    #ShowItemsInfoPopup               = 'Enabled'
    #ShowPreviewHandlers              = 'Enabled'
    #ShowStatusBar                    = 'Enabled'
    ShowSyncProviderNotifications    = 'Disabled'
    ItemsCheckBoxes                  = 'Enabled'
    SharingWizard                    = 'Disabled'
    #TypingIntoListViewBehavior       = 'SelectItemInView'
    ShowCloudStatesOnNavPane         = 'Disabled'
    #ExpandToCurrentFolder            = 'Disabled'
    #ShowAllFolders                   = 'Disabled'
    #ShowLibraries                    = 'Disabled'
    #ShowNetwork                      = 'Enabled'
    #ShowThisPC                       = 'Enabled'

    # --- Search
    DontUseSearchIndex               = 'Enabled'
    #IncludeSystemFolders             = 'Enabled'
    #IncludeCompressedFiles           = 'Disabled'
    #SearchFileNamesAndContents       = 'Disabled'

    # --- Miscellaneous
    ShowHome                         = 'Enabled'
    ShowGallery                      = 'Disabled'
    ShowRemovableDrivesOnlyInThisPC  = 'Enabled'
    MaxIconCacheSize                 = 4096
    AutoFolderTypeDetection          = 'Disabled'
    #UndoRedo                         = 'Enabled'
    #RecycleBin                       = 'Enabled'  ; RecycleBinGPO        = 'NotConfigured'
    #ConfirmFileDelete                = 'Disabled' ; ConfirmFileDeleteGPO = 'NotConfigured'
}
Set-FileExplorerSetting @FileExplorerSettings

#endregion file Explorer

#          Windows Permissions
#=======================================
#region Win Permissions

# --- User Data (aka: General / Recommendations & offers)
$PrivacyWinPermUserData = @{
    FindMyDevice            = 'Disabled' ; FindMyDeviceGPO         = 'NotConfigured'
    AdvertisingID           = 'Disabled' ; AdvertisingIDGPO        = 'NotConfigured'
    LanguageListAccess      = 'Disabled'
    TrackAppLaunches        = 'Disabled' ; TrackAppLaunchesGPO     = 'NotConfigured'
    ShowAdsInSettingsApp    = 'Disabled' ; ShowAdsInSettingsAppGPO = 'NotConfigured'
    ShowNotifsInSettingsApp = 'Disabled'
    ActivityHistory         = 'Disabled' ; ActivityHistoryGPO      = 'NotConfigured'
}
Set-WinPermissionsSetting @PrivacyWinPermUserData

# --- AI (Recall / Speech / Typing)
$PrivacyWinPermAI = @{
    RecallSnapshotsGPO = 'Disabled'
      RecallFilteringTelemetry   = 'Disabled'
      RecallPersonalizedHomepage = 'Disabled'
    ClickToDo          = 'Disabled' ; ClickToDoGPO         = 'NotConfigured'
    SpeechRecognition  = 'Disabled' ; SpeechRecognitionGPO = 'NotConfigured'
    InkingAndTypingPersonalization = 'Disabled'
}
Set-WinPermissionsSetting @PrivacyWinPermAI

# --- Telemetry (aka: Diagnostics & feedback)
$PrivacyWinPermTelemetry = @{
    DiagnosticData          = 'Disabled' ; DiagnosticDataGPO         = 'Disabled'
    ImproveInkingAndTyping  = 'Disabled' ; ImproveInkingAndTypingGPO = 'Disabled'
    TailoredExperiences     = 'Disabled' ; TailoredExperiencesGPO    = 'Disabled'
    DiagnosticDataViewer    = 'Disabled' ; DiagnosticDataViewerGPO   = 'Disabled'
    DeleteDiagnosticDataGPO = 'NotConfigured'
    FeedbackFrequency       = 'Never'    ; FeedbackFrequencyGPO      = 'Disabled'
}
Set-WinPermissionsSetting @PrivacyWinPermTelemetry

# --- Search
$PrivacyWinPermTelemetry = @{
    SafeSearch             = 'Disabled'
    SearchHistory          = 'Disabled'
    SearchHighlights       = 'Disabled' ; SearchHighlightsGPO = 'NotConfigured'
    CloudSearchGPO         = 'NotConfigured'
      CloudSearchMicrosoftAccount    = 'Disabled'
      CloudSearchWorkOrSchoolAccount = 'Disabled'
    CloudFileContentSearch = 'Disabled'
    StartMenuWebSearch     = 'Disabled'
    FindMyFiles            = 'Classic'
    IndexEncryptedFilesGPO = 'Disabled'
}
Set-WinPermissionsSetting @PrivacyWinPermTelemetry

#endregion Win Permissions

#            App Permissions
#=======================================
#region app Permissions

# --- General
$PrivacyAppPermGeneral = @{
    Location               = 'Disabled' ; LocationGPO               = 'NotConfigured'
      LocationAllowOverride    = 'Disabled'
      LocationAppsRequestNotif = 'Disabled'
    Camera                 = 'Disabled' ; CameraGPO                 = 'NotConfigured'
    Microphone             = 'Disabled' ; MicrophoneGPO             = 'NotConfigured'
    VoiceActivation        = 'Disabled' ; VoiceActivationGPO        = 'NotConfigured'
    Notifications          = 'Disabled' ; NotificationsGPO          = 'NotConfigured'

    TextAndImageGeneration = 'Disabled' ; TextAndImageGenerationGPO = 'NotConfigured'
    BackgroundApps         = 'Disabled' ; BackgroundAppsGPO         = 'NotConfigured'
}
Set-AppPermissionsSetting @PrivacyAppPermGeneral

# --- User Data
$PrivacyAppPermUserData = @{
    AccountInfo    = 'Disabled' ; AccountInfoGPO    = 'NotConfigured'
    Contacts       = 'Disabled' ; ContactsGPO       = 'NotConfigured'
    Calendar       = 'Disabled' ; CalendarGPO       = 'NotConfigured'
    PhoneCalls     = 'Disabled' ; PhoneCallsGPO     = 'NotConfigured'
    CallHistory    = 'Disabled' ; CallHistoryGPO    = 'NotConfigured'
    Email          = 'Disabled' ; EmailGPO          = 'NotConfigured'
    Tasks          = 'Disabled' ; TasksGPO          = 'NotConfigured'
    Messaging      = 'Disabled' ; MessagingGPO      = 'NotConfigured'
    Radios         = 'Disabled' ; RadiosGPO         = 'NotConfigured'
    AppDiagnostics = 'Disabled' ; AppDiagnosticsGPO = 'NotConfigured'

    # Others devices
    SyncWithUnpairedDevices = 'Disabled' ; SyncWithUnpairedDevicesGPO = 'NotConfigured'
    TrustedDevicesGPO = 'NotConfigured'
}
Set-AppPermissionsSetting @PrivacyAppPermUserData

# --- User Files
$PrivacyAppPermUserFiles = @{
    Documents       = 'Disabled'
    DownloadsFolder = 'Disabled'
    MusicLibrary    = 'Disabled'
    Pictures        = 'Disabled'
    Videos          = 'Disabled'
    FileSystem      = 'Disabled'
    ScreenshotBorders       = 'Disabled' ; ScreenshotBordersGPO       = 'NotConfigured'
    ScreenshotsAndRecording = 'Disabled' ; ScreenshotsAndRecordingGPO = 'NotConfigured'
}
Set-AppPermissionsSetting @PrivacyAppPermUserFiles

# --- Tablet
$PrivacyAppPermTablet = @{
    CellularData    = 'Disabled' ; CellularDataGPO    = 'NotConfigured'
    EyeTracker      = 'Disabled' ; EyeTrackerGPO      = 'NotConfigured'
    Motion          = 'Disabled' ; MotionGPO          = 'NotConfigured'
    PresenceSensing = 'Disabled' ; PresenceSensingGPO = 'NotConfigured'
    UserMovement    = 'Disabled' ; UserMovementGPO    = 'NotConfigured'
}
#Set-AppPermissionsSetting @PrivacyAppPermTablet

#endregion app Permissions

#               Telemetry
#=======================================
#region telemetry

Disable-DotNetTelemetry
Disable-NvidiaTelemetry
Disable-PowerShellTelemetry
Set-AppAndDeviceInventory -GPO 'Disabled'
Set-ApplicationCompatibility -GPO 'Disabled'
Set-CloudContent -GPO 'NotConfigured'
Set-ConsumerExperience -GPO 'NotConfigured'
Set-Ceip -GPO 'Disabled'
Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'
Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'
Set-ErrorReporting -GPO 'Disabled'
Set-GroupPolicySettingsLogging -GPO 'Disabled'
Set-HandwritingPersonalization -GPO 'Disabled'
Set-InventoryCollector -GPO 'Disabled'
Set-KmsClientActivationDataSharing -GPO 'Disabled'
Set-MsrtDiagnosticReport -GPO 'Disabled'
Set-OneSettingsDownloads -GPO 'Disabled'
Set-UserInfoSharing -GPO 'Disabled'

#endregion telemetry

#                Tweaks
#=======================================
#region tweaks

# --- Security, privacy and networking
Set-Hotspot2 -State 'Disabled'
Set-LockScreenCameraAccess -GPO 'Disabled'
Set-MessagingCloudSync -GPO 'Disabled'
Set-NotificationsNetworkUsage -GPO 'NotConfigured'
Set-PasswordExpiration -State 'Disabled'
Set-PasswordRevealButton -GPO 'Disabled'
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'
Set-WifiSense -GPO 'Disabled'
Set-Wpbt -State 'Disabled'

# --- System and performance
Set-FirstSigninAnimation -GPO 'Disabled'
#Set-FullscreenOptimizations -State 'Disabled'
Set-LongPaths -State 'Enabled'
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'
Set-NumLockAtStartup -State 'Enabled'
Set-ServiceHostSplitting -State 'Enabled'
Set-Short8Dot3FileName -State 'Disabled'
#Set-Short8Dot3FileName -State 'Disabled' -RemoveExisting8dot3FileNames
Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured'

# --- User interface and experience
# Win11 24H2+ only.
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

Set-CopyPasteDialogShowMoreDetails -State 'Enabled'
Set-HelpTips -GPO 'Disabled'
Set-MenuShowDelay -Value '200'
Set-OnlineTips -GPO 'Disabled'
Set-ShortcutNameSuffix -State 'Disabled'
Set-StartMenuAllAppsViewMode -Value 'Category'
Set-StartMenuRecommendedSection -GPO 'NotConfigured'
Set-SuggestedContent -State 'Disabled'
Set-WindowsExperimentation -GPO 'Disabled'
Set-WindowsInputExperience -State 'Disabled'
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'
Set-WindowsSettingsSearchAgent -GPO 'NotConfigured'
Set-WindowsSharedExperience -GPO 'NotConfigured'
Set-WindowsSpotlight -GPO 'NotConfigured'
Set-WindowsSpotlight -LearnAboutPictureDesktopIcon 'Disabled'

# --- Windows features and settings
Move-CharacterMapShortcutToWindowsTools
#Set-EventLogLocation -Path 'X:\MyEventsLogs'
#Set-EventLogLocation -Default
Set-EaseOfAccessReadScanSection -State 'Disabled'
Set-FileHistory -GPO 'NotConfigured'
Set-FontProviders -GPO 'Disabled'
Set-HomeSettingPageVisibility -GPO 'Disabled'
Set-LocationPermission -GPO 'NotConfigured'
Set-LocationScriptingPermission -GPO 'NotConfigured'
Set-OpenWithDialogStoreAccess -GPO 'Disabled'
Set-SensorsPermission -GPO 'NotConfigured'
Set-TaskbarLastActiveClick -State 'Disabled'
Set-WindowsHelpSupportSetting -F1Key 'Disabled'
Set-WindowsHelpSupportSetting -FeedbackGPO 'Disabled'
Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'
Set-WindowsUpdateSearchDrivers -GPO 'NotConfigured'

#endregion tweaks

#                Network
#=======================================
#region network

# --- Firewall
$FirewallRules = @(
    'AllJoynRouter'
    'CastToDevice'
    'ConnectedDevicesPlatform'
    'DeliveryOptimization'
    'DIALProtocol'
    'MicrosoftMediaFoundation'
    'ProximitySharing'
    'WifiDirectDiscovery'
    'WirelessDisplay'
    'WiFiDirectCoordinationProtocol'
    'WiFiDirectKernelModeDriver'
)
Set-DefenderFirewallRule -Name $FirewallRules -State 'Disabled'

$FirewallInboundRules = @(
    'CDP'
    'DCOM'
    'NetBiosTcpIP'
    'SMB'
    'MiscProgSrv' # lsass.exe, wininit.exe, Schedule, EventLog, services.exe
)
Block-DefenderFirewallInboundRule -Name $FirewallInboundRules
#Block-DefenderFirewallInboundRule -Name $FirewallInboundRules -Reset

# --- IPv6 transition technologies
$IPv6TransitionTech = @(
    '6to4'
    'Teredo'
    'IP-HTTPS'
    'ISATAP'
)
Set-NetIPv6Transition -Name $IPv6TransitionTech -State 'Disabled' -GPO 'Disabled'

# --- Network adapter protocol
Export-DefaultNetAdapterProtocolsState

$AdapterProtocolsToDisable = @(
    'LltdIo'
    'LltdResponder'
    'FileSharingClient'
    'FileSharingServer'
    'BridgeDriver'
    'QosPacketScheduler'
    'HyperVExtensibleVirtualSwitch'
    'Lldp'
    'MicrosoftMultiplexor'
)
Set-NetAdapterProtocol -Name $AdapterProtocolsToDisable -State 'Disabled'

$AdapterProtocolsToEnable = @(
    'IPv4'
    'IPv6'
)
#Set-NetAdapterProtocol -Name $AdapterProtocolsToEnable -State 'Enabled'

# --- System Drivers (Services)
$SystemDriversToConfig = @(
    'BridgeDriver'
    'NetBiosDriver'
    'NetBiosOverTcpIpDriver'
    'LldpDriver'
    'LltdIoDriver'
    'LltdResponderDriver'
    'MicrosoftMultiplexorDriver'
    'QosPacketSchedulerDriver'
)
# Disable the above selected drivers.
#$SystemDriversToConfig | Set-ServiceStartupTypeGroup

# --- Miscellaneous
Set-NetBiosOverTcpIP -State 'Disabled'
Set-NetIcmpRedirects -State 'Disabled'
Set-NetIPSourceRouting -State 'Disabled'
Set-NetLlmnr -GPO 'NotConfigured'
Set-NetLmhosts -State 'Disabled'
#Set-NetMulicastDns -State 'Enabled'
Set-NetSmhnr -GPO 'Disabled'
#Set-NetProxyAutoDetect -State 'Disabled'

#endregion network

#             Power Options
#=======================================
#region power options

Set-FastStartup -State 'Disabled'
Set-Hibernate -State 'Disabled'

Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60

Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

Set-AdvancedBatterySetting -Battery 'Low'      -Level 15 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 10
Set-AdvancedBatterySetting -Battery 'Critical' -Level 7  -Action 'Sleep'

#endregion power options

#           System properties
#=======================================
#region system properties

# --- Miscellaneous
Set-ManufacturerAppsAutoDownload -State 'Disabled' -GPO 'NotConfigured'
Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 512 -MaximumSize 2048
Set-DataExecutionPrevention -State 'OptIn'

#Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
#Set-SystemRestore -Drive $env:SystemDrive -State 'Enabled'

Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured'
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

# --- Visual Effects
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
Set-VisualEffects -Value 'Custom' -Setting $VisualEffectsCustomSettings
#Set-VisualEffects -Value 'ManagedByWindows'

# --- System Failure
$SystemFailureSettings = @{
    WriteEventToSystemLog      = 'Enabled'
    AutoRestart                = 'Disabled'
    WriteDebugInfo             = 'None'
    OverwriteExistingDebugFile = 'Enabled'
    AlwaysKeepMemoryDumpOnLowDiskSpace = 'Disabled'
}
Set-SystemFailureSetting @SystemFailureSettings

#endregion system properties

#            Apps management
#=======================================
#region apps management
# i.e. Install & Debloat

# --- Installation
$CustomAppsToInstall = @(
    'Valve.Steam'
    'AppName2'
    'AppName3'
)
#$CustomAppsToInstall | Install-ApplicationWithWinget -Scope 'Machine'

$AppsToInstall = @(
    #'Git'
    #'VSCode'
    'VLC'
    #'Bitwarden'
    #'KeePassXC'
    #'ProtonPass'
    #'AcrobatReader'
    #'SumatraPDF'
    #'7zip'
    #'Notepad++'
    #'qBittorrent'
    'Brave'
    #'Firefox'
    #'MullvadBrowser'
    #'VCRedist2015+.ARM'
    'VCRedist2015+'
    #'VCRedist2013'
    #'VCRedist2012'
    #'VCRedist2010'
    #'VCRedist2008'
    #'VCRedist2005'
    #'DirectXEndUserRuntime'
    #'DotNetDesktopRuntime5'
    #'DotNetDesktopRuntime6'
    #'DotNetDesktopRuntime7'
    #'DotNetDesktopRuntime8'
    #'DotNetDesktopRuntime9'
)
$AppsToInstall | Install-Application
Remove-AllDesktopShortcuts

#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'

# --- Appx & provisioned packages
Remove-StartMenuPromotedApps # W11
Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'
Set-Recall -GPO 'Disabled'
Set-Widgets -GPO 'Disabled'
Set-MicrosoftStorePushToInstall -GPO 'Disabled'
Set-Copilot -GPO 'Disabled'
Set-Cortana -GPO 'Disabled'

Export-DefaultAppxPackagesNames
Remove-MicrosoftEdge
Remove-OneDrive
Set-OneDriveNewUserAutoInstall -State 'Disabled'
#Remove-MSMaliciousSoftwareRemovalTool

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
    'EdgeGameAssist'
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

#endregion apps management

#             Apps settings
#=======================================
#region apps settings

# --- Miscellaneous
$AppsToConfig = @(
    #'KeePassXC'
    #'qBittorrent'
    'VLC'
    #'VSCode'
    #'Git'
)
$AppsToConfig | Set-MyAppsSetting

# --- Brave Browser
Set-BraveBrowserSettings

# --- Adobe Acrobat Reader
$AdobeReaderSettings = @{
    # --- Preferences
    ## Documents
    ShowToolsPane                   = 'Disabled'

    ## General
    ShowCloudStorageOnFileOpen      = 'Disabled'
    ShowCloudStorageOnFileSave      = 'Disabled'
    ShowMessagesAtLaunch            = 'Disabled' ; ShowMessagesAtLaunchGPO       = 'Disabled'
    ShowMessagesWhenViewingPdf      = 'Disabled' ; ShowMessagesWhenViewingPdfGPO = 'Disabled'
    SendCrashReports                = 'Never'

    ## Email accounts
    WebmailGPO                      = 'Disabled'

    ## Javascript
    Javascript                      = 'Disabled' ; JavascriptGPO = 'NotConfigured'
    JavascriptMenuItemsExecution    = 'Disabled'
    JavascriptGlobalObjectSecurity  = 'Enabled'

    ## Reviewing
    SharedReviewWelcomeDialog       = 'Disabled'

    ## Security (enhanced)
    ProtectedMode                   = 'Enabled'  ; ProtectedModeGPO           = 'NotConfigured'
    AppContainer                    = 'Enabled'  ; AppContainerGPO            = 'NotConfigured'
    ProtectedView                   = 'Disabled' ; ProtectedViewGPO           = 'NotConfigured'
    EnhancedSecurity                = 'Enabled'  ; EnhancedSecurityGPO        = 'NotConfigured'
    TrustCertifiedDocuments         = 'Disabled' ; TrustCertifiedDocumentsGPO = 'NotConfigured'
    TrustOSTrustedSites             = 'Disabled' ; TrustOSTrustedSitesGPO     = 'NotConfigured'
    AddTrustedFilesFoldersGPO       = 'NotConfigured'
    AddTrustedSitesGPO              = 'NotConfigured'

    ## Trust manager
    OpenFileAttachments             = 'Disabled' ; OpenFileAttachmentsGPO             = 'NotConfigured'
    InternetAccessFromPdf           = 'Custom'   ; InternetAccessFromPdfGPO           = 'NotConfigured'
    InternetAccessFromPdfUnknownUrl = 'Ask'      ; InternetAccessFromPdfUnknownUrlGPO = 'NotConfigured'

    ## Units
    PageUnits                       = 'Centimeters'

    # --- Miscellaneous
    ## Ads
    UpsellGPO                       = 'Disabled'
    UpsellMobileAppGPO              = 'Disabled'

    ## Cloud storage
    AdobeCloudStorageGPO            = 'Disabled'
    SharePointGPO                   = 'Disabled'
    ThirdPartyCloudStorageGPO       = 'Disabled'

    ## Tips
    FirstLaunchExperienceGPO        = 'Disabled'
    OnboardingDialogsGPO            = 'Disabled'
    PopupTipsGPO                    = 'Disabled'

    ## Others
    AcceptEulaGPO                   = 'Enabled'
    CrashReporterDialogGPO          = 'Disabled'
    HomeTopBannerGPO                = 'Disabled'
    OnlineServicesGPO               = 'Disabled'
    OutlookPluginGPO                = 'Disabled'
    ShareFileGPO                    = 'Disabled'
    TelemetryGPO                    = 'Disabled'
    SynchronizerRunAtStartup        = 'Disabled'
    #SynchronizerTaskManagerProcess  = 'Disabled'
}
Set-AdobeAcrobatReaderSetting @AdobeReaderSettings

$RemovedTools = @(
    #'AddComments'
    'AddRichMedia'
    'AddSearchIndex'
    #'AddStamp'
    'ApplyPdfStandards'
    'CreatePdf'
    'CombineFiles'
    'CompareFiles'
    'CompressPdf'
    'ConvertPdf'
    'EditPdf'
    'ExportPdf'
    #'FillAndSign'
    'MeasureObjects'
    'OrganizePages'
    'PrepareForAccessibility'
    'PrepareForm'
    'ProtectPdf'
    'RedactPdf'
    'RequestSignatures'
    'ScanAndOcr'
    'UseCertificate'
    'UseGuidedActions'
    'UsePrintProduction'
)
Set-AdobeAcrobatReaderSetting -RemoveToolFromToolsTab $RemovedTools
#Set-AdobeAcrobatReaderSetting -ResetRemovedToolsFromToolsTab

# --- Microsoft Edge
$MicrosoftEdgePolicy = @{
    Prelaunch      = 'Disabled'
    StartupBoost   = 'Disabled'
    BackgroundMode = 'Disabled'
}
Set-MicrosoftEdgePolicy @MicrosoftEdgePolicy

# --- Microsoft Office
$MsOfficeSettings = @{
    # --- Options
    LinkedinFeatures         = 'Disabled' ; LinkedinFeaturesGPO = 'NotConfigured'
    ShowStartScreen          = 'Disabled' ; ShowStartScreenGPO  = 'NotConfigured'

    # --- Miscellaneous
    AcceptEULAsGPO           = 'Enabled'
    BlockSigninGPO           = 'NotConfigured'
    TeachingTips             = 'Disabled'

    # --- Privacy
    AILocalTrainingGPO       = 'Disabled'
    CeipGPO                  = 'Disabled'
    DiagnosticsGPO           = 'Disabled'
    DiscountProgramNotifsGPO = 'Disabled'
    ErrorReportingGPO        = 'Disabled'
    FeedbackGPO              = 'Disabled'
    FirstRunAboutSigninGPO   = 'Disabled'
    FirstRunOptinWizardGPO   = 'Disabled'
    SendPersonalInfoGPO      = 'Disabled'
    SurveysGPO               = 'Disabled'
    TelemetryGPO             = 'Disabled'

    # --- Connected experiences
    AllConnectedExperiencesGPO                 = 'NotConfigured'
    ConnectedExperiencesThatAnalyzeContentGPO  = 'NotConfigured'
    ConnectedExperiencesThatDownloadContentGPO = 'NotConfigured'
    OptionalConnectedExperiences               = 'Disabled' ; OptionalConnectedExperiencesGPO = 'NotConfigured'
}
Set-MicrosoftOfficeSetting @MsOfficeSettings

# --- Microsoft Store
$MsStoreSettings = @{
    AutoAppUpdates          = 'Enabled' ; AutoAppUpdatesGPO = 'NotConfigured'
    AppInstallNotifications = 'Enabled'
    VideoAutoplay           = 'Disabled'
    PersonalizedExperiences = 'Disabled'
}
Set-MicrosoftStoreSetting @MsStoreSettings

# --- Windows Notepad
$NotepadSettings = @{
    Theme          = 'System'
    FontFamily     = 'Consolas'
    FontStyle      = 'Regular'
    FontSize       = '11'
    WordWrap       = 'Enabled'
    Formatting     = 'Enabled'
    FormattingTips = 'Disabled'
    OpenFile       = 'NewTab'
    RecentFiles    = 'Enabled'
    SpellCheck     = 'Disabled'
    AutoCorrect    = 'Disabled'
    Copilot        = 'Disabled'
    StatusBar      = 'Enabled'
    ContinuePreviousSession    = 'Disabled'
    ContinuePreviousSessionTip = 'Disabled'
}
Set-WindowsNotepadSetting @NotepadSettings

# --- Windows Photos
$PhotosSettings = @{
    Theme                      = 'Dark'
    ShowGalleryTilesAttributes = 'Enabled'
    LocationBasedFeatures      = 'Disabled'
    ShowICloudPhotos           = 'Disabled'
    DeleteConfirmationDialog   = 'Enabled'
    MouseWheelBehavior         = 'ZoomInOut'
    SmallMediaZoomPreference   = 'ViewActualSize'
    RunAtStartup               = 'Disabled'
    FirstRunExperience         = 'Disabled'
}
Set-WindowsPhotosSetting @PhotosSettings

# --- Windows Snipping Tool
$SnippingToolSettings = @{
    AutoCopyScreenshotChangesToClipboard = 'Enabled'
    AutoSaveScreenshoots                 = 'Enabled'
    AskToSaveEditedScreenshots           = 'Disabled'
    MultipleWindows                      = 'Disabled'
    ScreenshotBorder                     = 'Disabled'
    HDRColorCorrector                    = 'Disabled'
    AutoCopyRecordingChangesToClipboard  = 'Enabled'
    AutoSaveRecordings                   = 'Enabled'
    IncludeMicrophoneInRecording         = 'Disabled'
    IncludeSystemAudioInRecording        = 'Enabled'
    Theme                                = 'System'
}
Set-WindowsSnippingToolSetting @SnippingToolSettings

# --- Windows Terminal
$TerminalSettings = @{
    DefaultProfile            = 'PowerShellCore'
    DefaultCommandTerminalApp = 'WindowsTerminal'
    RunAtStartup              = 'Disabled'
    DefaultColorScheme        = 'One Half Dark'
    DefaultHistorySize        = 32767
}
Set-WindowsTerminalSetting @TerminalSettings

#endregion apps settings

#      Services & Scheduled Tasks
#=======================================
#region Services & Scheduled Tasks

# --- Services
Export-DefaultServicesStartupType
Export-DefaultSystemDriversStartupType

$ServicesToConfig = @(
    # --- SystemDriver
    'UserChoiceProtectionDriver'
    #'OfflineFilesDriver'
    #'NetworkDataUsageDriver'

    # --- Windows
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
    'MicrosoftEdge'
    #'MicrosoftOffice'
    'MicrosoftStore'
    'Miscellaneous'
    'Network'
    #'NetworkDiscovery'
    'Printer'
    'RemoteDesktop'
    #'Sensor'
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    #'Vpn'
    #'Webcam'
    'WindowsBackupAndSystemRestore'
    'WindowsSearch'
    #'WindowsSubsystemForLinux'
    'Xbox'

    # --- ThirdParty
    #'AdobeAcrobat'
    'Intel'
    #'Nvidia'
)
$ServicesToConfig | Set-ServiceStartupTypeGroup

# --- Scheduled Tasks
Export-DefaultScheduledTasksState

$TasksToConfig = @(
    #'AdobeAcrobat'
    'Diagnostic'
    'Features'
    'MicrosoftEdge'
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'UserChoiceProtectionDriver'
)
$TasksToConfig | Set-ScheduledTaskStateGroup

#endregion Services & Scheduled Tasks

#                Ramdisk
#=======================================
#region Ramdisk

#Install-OSFMount

$AppToRamDisk = @(
    'Brave'
    #'VSCode'
)
#Set-RamDisk -Size '1G' -AppToRamDisk $AppToRamDisk

#endregion Ramdisk

#endregion Part 1


#=================================================================================================================
#                                                Settings - Part 2
#=================================================================================================================
#region PART 2

#                System
#=======================================
#region system

# --- Display
$DisplayBrightnessSettings = @{
    Brightness              = 70
    AdjustOnLightingChanges = 'Disabled'
    AdjustBasedOnContent    = 'Disabled'
}
Set-DisplayBrightnessSetting @DisplayBrightnessSettings

$DisplayGraphicsSettings = @{
    AutoSuperResolution        = 'Disabled'
    AutoHDR                    = 'Disabled'
    WindowedGamesOptimizations = 'Enabled'
    GPUScheduling              = 'Enabled'
    GamesVariableRefreshRate   = 'Disabled'
}
Set-DisplayGraphicsSetting @DisplayGraphicsSettings

# --- Sound
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

# --- Notifications
$NotificationsSettings = @{
    Notifications            = 'Disabled' ; NotificationsGPO    = 'NotConfigured'
    PlaySounds               = 'Disabled'
    ShowOnLockScreen         = 'Disabled' ; ShowOnLockScreenGPO = 'NotConfigured'
    ShowRemindersAndIncomingCallsOnLockScreen = 'Disabled'
    ShowBellIcon             = 'Disabled'
    ScreenIndicatorsPosition = 'BottomCenter'
}
Set-NotificationsSetting @NotificationsSettings

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
Set-NotificationsSetting -AppsAndOtherSenders $SendersNotifs -State 'Disabled'

# --- Notifications - Ads
$NotificationsAdsSettings = @{
    ShowWelcomeExperience     = 'Disabled' ; ShowWelcomeExperienceGPO = 'NotConfigured'
    SuggestWaysToFinishConfig = 'Disabled'
    TipsAndSuggestions        = 'Disabled' ; TipsAndSuggestionsGPO    = 'NotConfigured'
}
Set-NotificationsSetting @NotificationsAdsSettings

# --- Power (& battery)
$PowerSettings = @{
    PowerMode         = 'Balanced'
    BatteryPercentage = 'Disabled'
}
Set-PowerSetting @PowerSettings

$DeviceTimeouts = @(
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Screen'    ; Timeout = 3 }
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Sleep'     ; Timeout = 10 }
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Hibernate' ; Timeout = 60 }

    @{ PowerSource = 'OnBattery' ; PowerState = 'Screen'    ; Timeout = 3 }
    @{ PowerSource = 'OnBattery' ; PowerState = 'Sleep'     ; Timeout = 5 }
    @{ PowerSource = 'OnBattery' ; PowerState = 'Hibernate' ; Timeout = 30 }
) | ForEach-Object { [PSCustomObject]$_ }
$DeviceTimeouts | Set-PowerSetting

$EnergySaverSettings = @{
    AlwaysOn             = 'Disabled'
    TurnOnAtBatteryLevel = 30
    LowerBrightness      = 70
}
Set-EnergySaverSetting @EnergySaverSettings

$ButtonControlsSettings = @(
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'PowerButton' ; Action = 'Sleep' }
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'SleepButton' ; Action = 'Sleep' }
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'LidClose'    ; Action = 'Sleep' }

    @{ PowerSource = 'OnBattery' ; ButtonControls = 'PowerButton' ; Action = 'Sleep' }
    @{ PowerSource = 'OnBattery' ; ButtonControls = 'SleepButton' ; Action = 'Sleep' }
    @{ PowerSource = 'OnBattery' ; ButtonControls = 'LidClose'    ; Action = 'Sleep' }
) | ForEach-Object { [PSCustomObject]$_ }
$ButtonControlsSettings | Set-PowerSetting

# --- Storage
$StorageSenseSettings = @{
    StorageSense     = 'Disabled' ; StorageSenseGPO     = 'NotConfigured'
    CleanupTempFiles = 'Enabled'  ; CleanupTempFilesGPO = 'NotConfigured'
}
Set-StorageSenseSetting @StorageSenseSettings

# --- Nearby sharing
$NearbySharingSettings = @{
    NearbySharing     = 'Disabled'
    #FileSaveLocation = 'X:\MySharedFiles'
}
Set-NearbySharingSetting @NearbySharingSettings

# --- Multitasking
$MultitaskingSettingSettings = @{
    ShowAppsTabsOnSnapAndAltTab = 'ThreeMostRecent' ; ShowAppsTabsOnSnapAndAltTabGPO = 'NotConfigured'
    TitleBarWindowShake         = 'Disabled'        ; TitleBarWindowShakeGPO         = 'NotConfigured'
    ShowAllWindowsOnTaskbar     = 'CurrentDesktop'
    ShowAllWindowsOnAltTab      = 'CurrentDesktop'
}
Set-MultitaskingSetting @MultitaskingSettingSettings

$SnapWindowsSettings = @{
    SnapWindows                = 'Enabled'
    SnapSuggestions            = 'Enabled'
    ShowLayoutOnMaxButtonHover = 'Enabled'
    ShowLayoutOnTopScreen      = 'Enabled'
}
Set-SnapWindowsSetting @SnapWindowsSettings

# --- For developers
$AdvancedSettings = @{
    EndTask = 'Disabled'
    Sudo    = 'Disabled'
}
Set-ForDevelopersSetting @AdvancedSettings

# --- Troubleshoot
Set-TroubleshooterPreference -Value 'Disabled'

# --- Recovery
Set-QuickMachineRecovery -State 'Disabled'
#Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryInterval '30min' -RestartInterval '72hours'

# --- Projecting to this PC
Set-ProjectingToThisPC -GPO 'Disabled'

# --- Remote desktop
$RemoteDesktopSettings = @{
    RemoteDesktop = 'Disabled' ; RemoteDesktopGPO = 'NotConfigured'
    NetworkLevelAuthentication = 'Enabled'
    #PortNumber = 3389
}
Set-RemoteDesktopSetting @RemoteDesktopSettings

# --- Clipboard
$ClipboardSettings = @{
    History           = 'Disabled' ; HistoryGPO           = 'NotConfigured'
    SyncAcrossDevices = 'Disabled' ; SyncAcrossDevicesGPO = 'NotConfigured'
    SuggestedActions  = 'Disabled'
}
Set-ClipboardSetting @ClipboardSettings

# --- Optional features
Export-InstalledWindowsCapabilitiesNames
Export-EnabledWindowsOptionalFeaturesNames

$OptionalFeatures = @(
    # --- Features
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

    # --- More Windows features
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

#endregion system

#          Bluetooth & devices
#=======================================
#region bluetooth & devices

# --- Devices
$BluetoothSettings = @{
    BluetoothGPO                   = 'NotConfigured'
    ShowQuickPairConnectionNotif   = 'Enabled'  ; ShowQuickPairConnectionNotifGPO = 'NotConfigured'
    LowEnergyAudio                 = 'Enabled'
    DiscoveryMode                  = 'Default'
}
Set-BluetoothSetting @BluetoothSettings

$DevicesSettings = @{
    DownloadOverMeteredConnections = 'Disabled'
    DefaultPrinterSystemManaged    = 'Disabled'
}
Set-DevicesSetting @DevicesSettings

# --- Mobile devices
$MobileDevicesSettings = @{
    MobileDevices        = 'Disabled'
    PhoneLink            = 'Disabled' ; PhoneLinkGPO = 'NotConfigured'
    ShowUsageSuggestions = 'Disabled'
}
Set-MobileDevicesSetting @MobileDevicesSettings

# --- Mouse
$MouseSettings = @{
    PrimaryButton                = 'Left'
    PointerSpeed                 = 10
    EnhancedPointerPrecision     = 'Enabled'
    ScrollInactiveWindowsOnHover = 'Enabled'
    ScrollingDirection           = 'DownMotionScrollsDown'
}
Set-MouseSetting @MouseSettings

#Set-MouseSetting -WheelScroll 'OneScreen'
Set-MouseSetting -WheelScroll 'MultipleLines' -LinesToScroll 3

# --- Touchpad
$TouchpadSettings = @{
    Touchpad                     = 'Enabled'
    LeaveOnWithMouse             = 'Enabled'
    CursorSpeed                  = 5
    Sensitivity                  = 'Medium'
    TapToClick                   = 'Enabled'
    TwoFingersTapToRightClick    = 'Enabled'
    TapTwiceAndDragToMultiSelect = 'Enabled'
    RightClickButton             = 'Enabled'
    TwoFingersToScroll           = 'Enabled'
    ScrollingDirection           = 'DownMotionScrollsUp'
    PinchToZoom                  = 'Enabled'
    #ThreeFingersTap              = 'OpenSearch'
    #ThreeFingersSwipes           = 'SwitchAppsAndShowDesktop'
    #FourFingersTap               = 'NotificationCenter'
    #FourFingersSwipes            = 'SwitchDesktopsAndShowDesktop'
}
Set-TouchpadSetting @TouchpadSettings

$ThreeFingersSwipesCustom = @{
    ThreeFingersUp    = 'TaskView'
    ThreeFingersDown  = 'ShowDesktop'
    ThreeFingersLeft  = 'SwitchApps'
    ThreeFingersRight = 'SwitchApps'
}
#Set-TouchpadSetting -ThreeFingersSwipes 'Custom' @ThreeFingersSwipesCustom

$FourFingersSwipesCustom = @{
    FourFingersUp    = 'TaskView'
    FourFingersDown  = 'ShowDesktop'
    FourFingersLeft  = 'SwitchDesktops'
    FourFingersRight = 'SwitchDesktops'
}
#Set-TouchpadSetting -FourFingersSwipes 'Custom' @FourFingersSwipesCustom

# --- AutoPlay
$AutoPlaySettings = @{
    AutoPlay       = 'Enabled'    ; AutoPlayGPO = 'NotConfigured'
    RemovableDrive = 'OpenFolder'
    MemoryCard     = 'OpenFolder'
}
Set-AutoPlaySetting @AutoPlaySettings

# --- USB
$UsbSettings = @{
    NotifOnErrors      = 'Enabled'
    BatterySaver       = 'Enabled'
    NotifOnWeakCharger = 'Enabled'
}
Set-UsbSetting @UsbSettings

#endregion bluetooth & devices

#          Network & internet
#=======================================
#region network & internet

Set-DnsServer -Provider 'Cloudflare' -Server 'Default'
#Set-DnsServer -ResetServerAddresses

$NetworkSettings = @{
    ConnectedNetworkProfile   = 'Private'
    VpnOverMeteredNetworks    = 'Enabled'
    VpnWhileRoaming           = 'Enabled'
    ProxyAutoDetectSettings   = 'Disabled'
    AutoSetupConnectedDevices = 'Disabled'
}
Set-NetworkSetting @NetworkSettings

$NetworkSharingSettings = @(
    @{ Name = 'NetworkDiscovery' ; NetProfile = 'Private' ; State = 'Disabled' }
    @{ Name = 'NetworkDiscovery' ; NetProfile = 'Public'  ; State = 'Disabled' }
    @{ Name = 'NetworkDiscovery' ; NetProfile = 'Domain'  ; State = 'Disabled' }

    @{ Name = 'FileAndPrinterSharing' ; NetProfile = 'Private' ; State = 'Disabled' }
    @{ Name = 'FileAndPrinterSharing' ; NetProfile = 'Public'  ; State = 'Disabled' }
    @{ Name = 'FileAndPrinterSharing' ; NetProfile = 'Domain'  ; State = 'Disabled' }
) | ForEach-Object { [PSCustomObject]$_ }
$NetworkSharingSettings | Set-NetworkSharingSetting

#endregion network & internet

#           Personnalization
#=======================================
#region personnalization

# --- Background
$BackgroundSettings = @{
    Wallpaper      = "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
    WallpaperStyle = 'Fill'
}
Set-BackgroundSetting @BackgroundSettings

# --- Colors
$ColorsSettings = @{
    Theme           = 'Dark'
    Transparency    = 'Enabled'
    AccentColorMode = 'Manual'
    ShowAccentColorOnStartAndTaskbar = 'Disabled'
    ShowAccentColorOnTitleAndBorders = 'Disabled'
}
Set-ColorsSetting @ColorsSettings

# --- Themes - Desktop icons
$DesktopIcons = @(
    'ThisPC'
    #'UserFiles'
    'Network'
    'RecycleBin'
    #'ControlPanel'
)
#Set-ThemesSetting -DesktopIcons $DesktopIcons
Set-ThemesSetting -HideAllDesktopIcons
Set-ThemesSetting -ThemesCanChangeDesktopIcons 'Disabled'

# --- Dynamic Lighting
$DynamicLightingSettings = @{
    DynamicLighting           = 'Disabled'
    ControlledByForegroundApp = 'Disabled'
}
Set-DynamicLightingSetting @DynamicLightingSettings

# --- Lock screen
$LockScreenSettings = @{
    SetToPicture                 = $true
    GetFunFactsTipsTricks        = 'Disabled'
    ShowPictureOnSigninScreenGPO = 'NotConfigured'
    YourWidgets                  = 'Disabled' ; YourWidgetsGPO = 'NotConfigured'
}
Set-LockScreenSetting @LockScreenSettings

# --- Start
$StartSettings = @{
    LayoutMode               = 'Default'
    ShowAllPins              = 'Disabled'
    ShowRecentlyAddedApps    = 'Disabled' ; ShowRecentlyAddedAppsGPO   = 'NotConfigured'
    ShowMostUsedApps         = 'Disabled' ; ShowMostUsedAppsGPO        = 'NotConfigured'
    ShowRecentlyOpenedItems  = 'Enabled'  ; ShowRecentlyOpenedItemsGPO = 'NotConfigured'
    ShowRecommendations      = 'Disabled'
    ShowAccountNotifications = 'Disabled'
    ShowMobileDevice         = 'Disabled'
}
Set-StartSetting @StartSettings

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

# --- Taskbar
$TaskbarSettings = @{
    SearchBox                       = 'Hide'     ; SearchBoxGPO = 'NotConfigured'
    TaskView                        = 'Disabled' ; TaskViewGPO  = 'NotConfigured'
    EmojiAndMore                    = 'Never'
    PenMenu                         = 'Disabled'
    TouchKeyboard                   = 'Never'
    VirtualTouchpad                 = 'Disabled'
    HiddenIconMenu                  = 'Enabled'
    Alignment                       = 'Center'
    #TouchOptimized                  = 'Enabled'
    AutoHide                        = 'Disabled'
    #ShowAppsBadges                  = 'Enabled'
    #ShowAppsFlashing                = 'Enabled'
    #ShowOnAllDisplays               = 'Disabled' ; ShowOnAllDisplaysGPO = 'NotConfigured'
    #ShowAppsOnMultipleDisplays      = 'AllTaskbars'
    #ShareAnyWindow                  = 'Enabled'
    FarCornerToShowDesktop          = 'Enabled'
    #GroupAndHideLabelsMainTaskbar   = 'Always' ; GroupAndHideLabelsGPO = 'NotConfigured'
    #GroupAndHideLabelsOtherTaskbars = 'Always'
    ShowSmallerButtons              = 'WhenFull'
    ShowJumplistOnHover             = 'Disabled'
}
Set-TaskbarSetting @TaskbarSettings

# --- Device usage
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

#endregion personnalization

#                 Apps
#=======================================
#region apps

$AppsSettings = @{
    ChooseWhereToGetApps = 'Anywhere' ; ChooseWhereToGetAppsGPO = 'NotConfigured'
    ShareAcrossDevices   = 'Disabled'
    AutoArchiveApps      = 'Disabled' ; AutoArchiveAppsGPO      = 'NotConfigured'
    AppsOpenLinksInsteadOfBrowserGPO = 'NotConfigured'
    AppsResume           = 'Disabled' ; AppsResumeGPO           = 'NotConfigured'
}
Set-GeneralAppsSetting @AppsSettings

# Deprecated app
$OfflineMapsSettings = @{
    DownloadOverMeteredConnection = 'Disabled'
    AutoUpdateOnACAndWifi         = 'Disabled' ; AutoUpdateOnACAndWifiGPO = 'NotConfigured'
}
Set-OfflineMapsSetting @OfflineMapsSettings

#endregion apps

#                 Accounts
#=======================================
#region accounts

Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured'

$AccountsSettings = @{
    BiometricsGPO                  = 'NotConfigured'
    SigninWithExternalDevice       = 'Enabled'
    OnlyWindowsHelloForMSAccount   = 'Disabled'
    SigninRequiredIfAway           = 'Never'
    DynamicLock                    = 'Disabled' ; DynamicLockGPO = 'NotConfigured'
    AutoRestartApps                = 'Disabled'
    ShowAccountDetailsGPO          = 'NotConfigured'
    AutoFinishSettingUpAfterUpdate = 'Disabled' ; AutoFinishSettingUpAfterUpdateGPO = 'NotConfigured'
}
Set-SigninOptionsSetting @AccountsSettings

#endregion accounts

#            Time & language
#=======================================
#region time & language

# --- Date & time
$DateTimeSettings = @{
    AutoTimeZone             = 'Disabled'
    AutoTime                 = 'Enabled'
    ShowInSystemTray         = 'Enabled'
    ShowAbbreviatedValue     = 'Disabled' 
    ShowSecondsInSystemClock = 'Disabled'
    ShowTimeInNotifCenter    = 'Disabled'
    TimeServer               = 'Windows'
}
Set-DateAndTimeSetting @DateTimeSettings

# --- Language & region
#Remove-LanguageFeatures # W11

$LanguageAndRegionSettings = @{
    FirstDayOfWeek            = 'Monday'
    ShortDateFormat           = 'dd-MMM-yy'
    Utf8ForNonUnicodePrograms = 'Enabled'
}
Set-LanguageAndRegionSetting @LanguageAndRegionSettings

# --- Typing
$TypingSettings = @{
    ShowTextSuggestionsOnSoftwareKeyboard = 'Disabled'
    ShowTextSuggestionsOnPhysicalKeyboard = 'Disabled'
    MultilingualTextSuggestions           = 'Disabled'
    AutocorrectMisspelledWords            = 'Disabled'
    HighlightMisspelledWords              = 'Disabled'
    TypingAndCorrectionHistory            = 'Disabled'
    UseDifferentInputMethodForEachApp     = 'Disabled'
    LanguageBar                           = 'DockedInTaskbar'
    SwitchInputLanguageHotKey             = 'NotAssigned'
    SwitchKeyboardLayoutHotKey            = 'NotAssigned'
}
Set-TypingSetting @TypingSettings

#endregion time & language

#                Gaming
#=======================================
#region gaming

$NetworkSettings = @{
    OpenGameBarWithController = 'Disabled'
    GameRecording = 'Disabled' ; GameRecordingGPO = 'NotConfigured'
    GameMode      = 'Disabled'
}
Set-GamingSetting @NetworkSettings

#endregion gaming

#                 Accessibility
#=======================================
#region accessibility

$AccessibilitySettings = @{
    VisualEffectsAlwaysShowScrollbars       = 'Disabled'
    VisualEffectsAnimation                  = 'Enabled'
    VisualEffectsNotificationsDuration      = 5
    ContrastThemesKeyboardShorcut           = 'Disabled'
    NarratorKeyboardShorcut                 = 'Disabled'
    NarratorAutoSendTelemetry               = 'Disabled'
    VoiceTypingKeyboardShorcut              = 'Disabled'
    MouseKeys                               = 'Disabled'
    MouseKeysShorcut                        = 'Disabled'
    KeyboardStickyKeys                      = 'Disabled'
    KeyboardStickyKeysShorcut               = 'Disabled'
    KeyboardFilterKeys                      = 'Disabled'
    KeyboardFilterKeysShorcut               = 'Disabled'
    KeyboardToggleKeysTone                  = 'Disabled'
    KeyboardToggleKeysToneShorcut           = 'Disabled'
    KeyboardPrintScreenKeyOpenScreenCapture = 'Disabled'
}
Set-AccessibilitySetting @AccessibilitySettings

#endregion accessibility

#    Windows Security (aka Defender)
#=======================================
#region Windows security

# --- Settings
$DefenderSettings = @{
    CloudDeliveredProtection = 'Disabled'  ; CloudDeliveredProtectionGPO = 'NotConfigured'
    AutoSampleSubmission     = 'NeverSend' ; AutoSampleSubmissionGPO     = 'NotConfigured'
    AdminProtection          = 'Disabled'
    CheckAppsAndFiles        = 'Disabled'  ; CheckAppsAndFilesGPO        = 'NotConfigured'
    SmartScreenForEdge       = 'Disabled'  ; SmartScreenForEdgeGPO       = 'NotConfigured'
    PhishingProtectionGPO    = 'Disabled'
    UnwantedAppBlocking      = 'Disabled'  ; UnwantedAppBlockingGPO      = 'NotConfigured'
    SmartScreenForStoreApps  = 'Disabled'
    WatsonEventsReportGPO    = 'Disabled'
}
Set-DefenderSetting @DefenderSettings

# --- Notifications
$DefenderNotifs = @{
    #VirusAndThreatAllNotifs      = 'Enabled'
      RecentActivityAndScanResults = 'Disabled'
      ThreatsFoundNoActionNeeded   = 'Enabled'
      FilesOrActivitiesBlocked     = 'Enabled'
    #AccountAllNotifs             = 'Enabled'
      WindowsHelloProblems         = 'Enabled'
      DynamicLockProblems          = 'Enabled'
}
Set-DefenderNotificationsSetting @DefenderNotifs

#endregion Windows security

#            Windows Update
#=======================================
#region Windows Update

$WindowsUpdateSettings = @{
    GetLatestAsSoonAsAvailable     = 'Disabled' ; GetLatestAsSoonAsAvailableGPO     = 'NotConfigured'
    PauseUpdatesGPO                = 'NotConfigured'
    UpdateOtherMicrosoftProducts   = 'Enabled'  ; UpdateOtherMicrosoftProductsGPO   = 'NotConfigured'
    GetMeUpToDate                  = 'Disabled'
    DownloadOverMeteredConnections = 'Disabled' ; DownloadOverMeteredConnectionsGPO = 'NotConfigured'
    RestartNotification            = 'Disabled' ; RestartNotificationGPO            = 'NotConfigured'
    DeliveryOptimization           = 'Disabled' ; DeliveryOptimizationGPO           = 'NotConfigured'
    InsiderProgramPageVisibility   = 'Disabled'
}
Set-WinUpdateSetting @WindowsUpdateSettings

#Set-WinUpdateSetting -ActiveHoursMode 'Automatically' -ActiveHoursGPO 'NotConfigured'
Set-WinUpdateSetting -ActiveHoursMode 'Manually' -ActiveHoursStart 7 -ActiveHoursEnd 1
#Set-WinUpdateSetting -ActiveHoursGPO 'Enabled' -ActiveHoursStart 7 -ActiveHoursEnd 1

#endregion Windows Update

#endregion Part 2


Stop-Transcript
