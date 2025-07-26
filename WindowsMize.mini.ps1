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
  All functions in the 'scripts' folder can be imported.
  
  They are also listed in the corresponding module within the public folder.
  e.g. src\modules\file_explorer\public\Set-FileExplorerSetting.ps1
  
  Reload the terminal session if you have made changes to the powershell source code.
  e.g. Open a new PowerShell-Tab.
#>

#Requires -RunAsAdministrator
#Requires -Version 7.5

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\log\$ScriptFileName.log"

$Global:ModuleVerbosePreference = 'Continue'

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
    LaunchTo                        = 'ThisPC'
    ShowRecentFiles                 = 'Enabled'
    ShowFrequentFolders             = 'Disabled'
    ShowCloudFiles                  = 'Disabled'
    CompactView                     = 'Enabled'
    ShowHiddenItems                 = 'Enabled'
    HideFileExtensions              = 'Disabled'
    HideFolderMergeConflicts        = 'Disabled'
    ShowSyncProviderNotifications   = 'Disabled' # OneDrive Ads
    ItemsCheckBoxes                 = 'Enabled'
    SharingWizard                   = 'Disabled'
    ShowCloudStatesOnNavPane        = 'Disabled'
    DontUseSearchIndex              = 'Enabled'
    ShowHome                        = 'Enabled'
    ShowGallery                     = 'Disabled'
    MaxIconCacheSize                = 4096
    AutoFolderTypeDetection         = 'Disabled'
    ShowRemovableDrivesOnlyInThisPC = 'Enabled'
    #RecycleBin                      = 'Enabled'  ; RecycleBinGPO        = 'NotConfigured'
    #ConfirmFileDelete               = 'Disabled' ; ConfirmFileDeleteGPO = 'NotConfigured'
}
Set-FileExplorerSetting @FileExplorerSettings

#endregion file Explorer

#          Windows Permissions
#=======================================
#region Win Permissions

# --- User Data (aka: General / Recommendations & offers)
$PrivacyWinPermUserData = @{
    FindMyDevice            = 'Disabled' ; FindMyDeviceGPO          = 'NotConfigured'
    AdvertisingID           = 'Disabled' ; AdvertisingIDGPO         = 'NotConfigured'
    LanguageListAccess      = 'Disabled'
    TrackAppLaunches        = 'Disabled' ; TrackAppLaunchesGPO      = 'NotConfigured'
    ShowTipsInSettingsApp   = 'Disabled' ; ShowTipsInSettingsAppGPO = 'NotConfigured'
    ShowNotifsInSettingsApp = 'Disabled'
    ActivityHistory         = 'Disabled' ; ActivityHistoryGPO       = 'NotConfigured'
}
Set-WinPermissionsSetting @PrivacyWinPermUserData

# --- AI (Recall / Speech / Typing)
$PrivacyWinPermAI = @{
    RecallSnapshotsGPO = 'Disabled'
      RecallFilteringTelemetry = 'Disabled'
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
    SafeSearch         = 'Disabled'
    CloudSearchGPO     = 'NotConfigured'
      CloudSearchMicrosoftAccount    = 'Disabled'
      CloudSearchWorkOrSchoolAccount = 'Disabled'
    SearchHistory      = 'Disabled'
    SearchHighlights   = 'Disabled' ; SearchHighlightsGPO = 'NotConfigured'
    CloudContentSearch = 'Disabled'
    WebSearch          = 'Disabled'
    FindMyFiles        = 'Classic'
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
Set-GroupPolicySettingsLogging -GPO 'Disabled'
Set-ErrorReporting -GPO 'Disabled'
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
Set-NotificationsNetworkUsage -GPO 'NotConfigured' # real-time notifs (Discord, MSTeams)
Set-PasswordExpiration -State 'Disabled'
Set-PasswordRevealButton -GPO 'Disabled'
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'
Set-WifiSense -GPO 'Disabled'
Set-Wpbt -State 'Disabled'

# --- System and performance
Set-FirstSigninAnimation -State 'Disabled' -GPO 'NotConfigured'
#Set-FullscreenOptimizations -State 'Disabled'
Set-LongPaths -State 'Enabled'
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'
Set-NumLockAtStartup -State 'Enabled'
Set-ServiceHostSplitting -State 'Enabled'
Set-Short8Dot3FileName -State 'Disabled' # -RemoveExisting8dot3FileNames # Read comments in Set-Short8Dot3FileName.ps1
Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured'

# --- User interface and experience
Set-CopyPasteDialogShowMoreDetails -State 'Enabled'
Set-HelpTips -GPO 'Disabled'
Set-OnlineTips -GPO 'Disabled'
Set-ShortcutNameSuffix -State 'Disabled'
Set-StartMenuAllAppsViewMode -Value 'Category'
Set-StartMenuRecommendedSection -GPO 'NotConfigured'
Set-SuggestedContent -State 'Disabled'
Set-WindowsExperimentation -GPO 'Disabled'
Set-WindowsInputExperience -State 'Disabled'
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'
Set-WindowsSharedExperience -GPO 'NotConfigured' # disable: system > nearby sharing | apps > share across devices'
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
Set-OpenWithDialogStoreAccess -GPO 'Disabled'
Set-WindowsHelpSupportSetting -F1Key 'Disabled'
Set-WindowsHelpSupportSetting -FeedbackGPO 'Disabled'
Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'
Set-WindowsUpdateSearchDrivers -GPO 'NotConfigured'

#endregion tweaks

#                Network
#=======================================
#region network

# --- Firewall
$FirewallInboundRules = @(
    'CDP'
    'DCOM'
    'NetBiosTcpIP'
    'SMB'
    'MiscProgSrv' # lsass.exe, wininit.exe, Schedule, EventLog, services.exe
)
Block-NetFirewallInboundRule -Name $FirewallInboundRules

# --- Protocols
Set-NetBiosOverTcpIP -State 'Disabled'
Set-NetIcmpRedirects -State 'Disabled'
Set-NetIPSourceRouting -State 'Disabled'
Set-NetLlmnr -GPO 'Disabled'
Set-NetSmhnr -GPO 'Disabled'
#Set-NetProxyAutoDetect -State 'Disabled'

$IPv6TransitionTech = @(
    '6to4'
    'Teredo'
    'IP-HTTPS'
    'ISATAP'
)
Set-NetIPv6Transition -Name $IPv6TransitionTech -State 'Disabled' -GPO 'Disabled'

$AdapterProtocols = @(
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
Set-NetAdapterProtocol -Name $AdapterProtocols -State 'Disabled'

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
Set-AdvancedBatterySetting -Battery 'Critical' -Level 7  -Action 'Hibernate'

#endregion power options

#           System properties
#=======================================
#region system properties

# --- Misc
Set-ManufacturerAppsAutoDownload -State 'Disabled' -GPO 'NotConfigured'
Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 512 -MaximumSize 2048
Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured'

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
    #'DirectXEndUserRuntime'
    #'VCRedist2015+.ARM'
    'VCRedist2015+'
    #'VCRedist2013'
    #'VCRedist2012'
    #'VCRedist2010'
    #'VCRedist2008'
    #'VCRedist2005'
)
$AppsToInstall | Install-Application
Remove-AllDesktopShortcuts

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

# --- Misc
$AppsToConfig = @(
    'KeePassXC'
    'qBittorrent'
    'VLC'
    #'VSCode'
    #'Git'
)
$AppsToConfig.ForEach({ Set-MyAppsSetting -Name $_ })

# --- Brave Browser
Set-BraveBrowserSettings

# --- Adobe Acrobat Reader
$AdobeReaderSettings = @{
    ShowToolsPane              = 'Disabled'
    ShowCloudStorageOnFileOpen = 'Disabled'
    ShowCloudStorageOnFileSave = 'Disabled'
    ShowMessagesAtLaunch       = 'Disabled'
    SendCrashReports           = 'Never'
    Javascript                 = 'Disabled'
    ProtectedMode              = 'Enabled'
    AppContainer               = 'Enabled'
    ProtectedView              = 'Disabled'
    EnhancedSecurity           = 'Enabled'
    TrustCertifiedDocuments    = 'Disabled'
    TrustOSTrustedSites        = 'Disabled'
    OpenFileAttachments        = 'Disabled'
    PageUnits                  = 'Centimeters'
    RecommendedTools           = 'Collapse'
    FirstLaunchExperience      = 'Disabled'
    Upsell                     = 'Disabled'
    UsageStatistics            = 'Disabled'
    OnlineServices             = 'Disabled'
    AdobeCloud                 = 'Disabled'
    SharePoint                 = 'Disabled'
    Webmail                    = 'Disabled'
}
Set-AdobeAcrobatReaderSetting @AdobeReaderSettings

# --- Microsoft Edge
$MicrosoftEdgePolicy = @{
    Prelaunch      = 'Disabled'
    StartupBoost   = 'Disabled'
    BackgroundMode = 'Disabled'
}
Set-MicrosoftEdgePolicy @MicrosoftEdgePolicy

# --- Microsoft Office
$MsOfficeSettings = @{
    ConnectedExperiences = 'Disabled'
    LinkedinFeatures     = 'Disabled'
    ShowStartScreen      = 'Disabled'
    Ceip                 = 'Disabled'
    Feedback             = 'Disabled'
    Logging              = 'Disabled'
    Telemetry            = 'Disabled'
}
Set-MicrosoftOfficeSetting @MsOfficeSettings

# --- Microsoft Store
$MsStoreSettings = @{
    AutoAppsUpdates         = 'Enabled'
    AppInstallNotifications = 'Enabled'
    VideoAutoplay           = 'Disabled'
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
    OpenFile       = 'NewTab'
    ContinuePreviousSession = 'Disabled'
    RecentFiles    = 'Enabled'
    SpellCheck     = 'Disabled'
    AutoCorrect    = 'Disabled'
    Copilot        = 'Disabled'
    StatusBar      = 'Enabled'
    ContinuePreviousSessionTip = 'Disabled'
    FormattingTips = 'Disabled'
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
    AutoSaveScreenshoots          = 'Enabled'
    AskToSaveEditedScreenshots    = 'Disabled'
    MultipleWindows               = 'Disabled'
    ScreenshotBorder              = 'Disabled'
    HDRColorCorrector             = 'Disabled'
    AutoCopyRecordingChangesToClipboard = 'Enabled'
    AutoSaveRecordings            = 'Enabled'
    IncludeMicrophoneInRecording  = 'Disabled'
    IncludeSystemAudioInRecording = 'Enabled'
    Theme                         = 'System'
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
    'DefenderPhishingProtection' # do not disable if you use Edge with 'Phishing Protection' enabled.
    'Deprecated'
    'DiagnosticAndUsage'
    'Features' # adjust to your needs: src > modules > services > private > Features.ps1
    'FileAndPrinterSharing'
    'HyperV'
    'MicrosoftEdge' # do not disable if you use Edge.
    #'MicrosoftOffice'
    'MicrosoftStore' # only 'PushToInstall service' is disabled. all others are left to default state 'Manual'.
    'Miscellaneous' # adjust to your needs: src > modules > services > private > Miscellaneous.ps1
    'Network' # all disabaled by default. Including 'Internet Connection Sharing (ICS)' needed by Mobile hotspot.
    #'NetworkDiscovery' # needed by printer and FileAndPrinterSharing.
    'Printer' # To use a Printer, edit the .ps1 file and enable only: 'Spooler' (and maybe 'PrintNotify') services.
    'RemoteDesktop'
    'Sensor'
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    #'Vpn'
    #'Webcam'
    'WindowsBackupAndSystemRestore' # System Restore is left to default state 'Manual'. Update ps1 file if desired.
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
    'Features'
    'MicrosoftEdge' # do not disable if you didn't uninstalled Edge.
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'TelemetryDiagnostic'
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
    WindowedGamesOptimizations = 'Disabled'
    AutoHDR                    = 'Disabled'
    GPUScheduling              = 'Enabled'
    GamesVariableRefreshRate   = 'Disabled'
}
Set-DisplayGraphicsSetting @DisplayGraphicsSettings

# --- Sound
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

# --- Notifications
$NotificationsSettings = @{
    Notifications    = 'Disabled' ; NotificationsGPO = 'NotConfigured'
    PlaySounds       = 'Disabled'
    ShowOnLockScreen = 'Disabled' ; ShowOnLockScreenGPO = 'NotConfigured'
    ShowRemindersAndIncomingCallsOnLockScreen = 'Disabled'
    ShowBellIcon     = 'Disabled'
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
Set-PowerSetting -PowerMode 'Balanced'

$DeviceTimeouts = @(
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Screen'    ; Timeout = 3 }
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Sleep'     ; Timeout = 10 }
    @{ PowerSource = 'PluggedIn' ; PowerState = 'Hibernate' ; Timeout = 60 }

    @{ PowerSource = 'OnBattery' ; PowerState = 'Screen'    ; Timeout = 3 }
    @{ PowerSource = 'OnBattery' ; PowerState = 'Sleep'     ; Timeout = 5 }
    @{ PowerSource = 'OnBattery' ; PowerState = 'Hibernate' ; Timeout = 30 }
) | ForEach-Object { [PSCustomObject]$_ }
$DeviceTimeouts | Set-PowerSetting

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

# --- Multitasking
$SnapWindowsSettingSettings = @{
    SnapWindows                = 'Enabled'
    SnapSuggestions            = 'Enabled'
    ShowLayoutOnMaxButtonHover = 'Enabled'
    ShowLayoutOnTopScreen      = 'Enabled'
}
Set-SnapWindowsSetting @SnapWindowsSettingSettings

# --- Miscellaneous
Set-ForDevelopersSetting -EndTask 'Disabled'
Set-TroubleshooterPreference -Value 'Disabled'
Set-ProjectingToThisPC -GPO 'Disabled'
Set-RemoteDesktopSetting -RemoteDesktop 'Disabled' -RemoteDesktopGPO 'NotConfigured'

# --- Clipboard
$ClipboardSettings = @{
    History           = 'Disabled' ; HistoryGPO           = 'NotConfigured'
    SyncAcrossDevices = 'Disabled' ; SyncAcrossDevicesGPO = 'NotConfigured'
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

$DevicesSettings = @{
    MobileDevices        = 'Disabled'
    PhoneLink            = 'Disabled' ; PhoneLinkGPO = 'NotConfigured'
    ShowUsageSuggestions = 'Disabled'
}
Set-MobileDevicesSetting @DevicesSettings

Set-MouseSetting -EnhancedPointerPrecision 'Enabled'
Set-TouchpadSetting -ScrollingDirection 'DownMotionScrollsUp'

$AutoPlaySettings = @{
    AutoPlay       = 'Enabled'    ; AutoPlayGPO = 'NotConfigured'
    RemovableDrive = 'OpenFolder'
    MemoryCard     = 'OpenFolder'
}
Set-AutoPlaySetting @AutoPlaySettings

#endregion bluetooth & devices

#          Network & internet
#=======================================
#region network & internet

Set-DnsServer -Cloudflare 'Default'

$NetworkSettings = @{
    ConnectedNetworkProfile = 'Private'
    ProxyAutoDetectSettings = 'Enabled'
}
Set-NetworkSetting @NetworkSettings

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
    SetToPicture          = $true
    GetFunFactsTipsTricks = 'Disabled'
    YourWidgets           = 'Disabled' ; YourWidgetsGPO = 'NotConfigured'
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
    SearchBox           = 'Hide'     ; SearchBoxGPO = 'NotConfigured'
    TaskView            = 'Disabled' ; TaskViewGPO  = 'NotConfigured'
    EmojiAndMore        = 'Never'
    PenMenu             = 'Disabled'
    TouchKeyboard       = 'Never'
    VirtualTouchpad     = 'Disabled'
    Alignment           = 'Center'
    ShowJumplistOnHover = 'Disabled'
}
Set-TaskbarSetting @TaskbarSettings

# --- Device usage
Set-DeviceUsageSetting -DisableAll

#endregion personnalization

#                 Apps
#=======================================
#region apps

$AppsSettings = @{
    ShareAcrossDevices = 'Disabled'
    AutoArchiveApps    = 'Disabled' ; AutoArchiveAppsGPO = 'NotConfigured'
    AppsOpenLinksInsteadOfBrowserGPO = 'NotConfigured'
    AppsResume         = 'Disabled'
}
Set-GeneralAppsSetting @AppsSettings

# Deprecated app
Set-OfflineMapsSetting -AutoUpdateOnACAndWifi 'Disabled' -AutoUpdateOnACAndWifiGPO 'NotConfigured'

#endregion apps

#                 Accounts
#=======================================
#region accounts

# GPO: CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured
Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured'

$AccountsSettings = @{
    SigninRequiredIfAway           = 'Never'
    AutoRestartApps                = 'Disabled'
    AutoFinishSettingUpAfterUpdate = 'Disabled' ; AutoFinishSettingUpAfterUpdateGPO = 'NotConfigured'
}
Set-SigninOptionsSetting @AccountsSettings

#endregion accounts

#            Time & language
#=======================================
#region time & language

# --- Basic typing, Handwriting, OCR, Text-To-Speech, Speech recognition
#Remove-LanguageFeatures # W11

# --- Date & time
$DateTimeSettings = @{
    AutoTimeZone             = 'Disabled'
    AutoTime                 = 'Enabled'
    ShowInSystemTray         = 'Enabled'
    ShowAbbreviatedValue     = 'Disabled' 
    ShowSecondsInSystemClock = 'Disabled'
    TimeServer               = 'Windows'
}
Set-DateAndTimeSetting @DateTimeSettings

# --- Language & region
$LanguageRegionSettings = @{
    FirstDayOfWeek            = 'Monday'
    ShortDateFormat           = 'dd-MMM-yy'
    Utf8ForNonUnicodePrograms = 'Enabled'
}
Set-LanguageAndRegionSetting @LanguageRegionSettings

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
    VisualEffectsAnimation        = 'Enabled'
    ContrastThemesKeyboardShorcut = 'Disabled'
    NarratorKeyboardShorcut       = 'Disabled'
    NarratorAutoSendTelemetry     = 'Disabled'
    VoiceTypingKeyboardShorcut    = 'Disabled'
    MouseKeys                     = 'Disabled'
    MouseKeysShorcut              = 'Disabled'
    KeyboardStickyKeys            = 'Disabled'
    KeyboardStickyKeysShorcut     = 'Disabled'
    KeyboardFilterKeys            = 'Disabled'
    KeyboardFilterKeysShorcut     = 'Disabled'
    KeyboardToggleKeysTone        = 'Disabled'
    KeyboardToggleKeysToneShorcut = 'Disabled'
    KeyboardPrintScreenKeyOpenScreenCapture = 'Disabled'
}
Set-AccessibilitySetting @AccessibilitySettings

#endregion accessibility

#           Windows Security
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
    ActiveHoursMode  = 'Manually' ; ActiveHoursGPO = 'NotConfigured'
    ActiveHoursStart = 7          ; ActiveHoursEnd = 1

    DeliveryOptimization         = 'Disabled' ; DeliveryOptimizationGPO         = 'NotConfigured'
    RestartNotification          = 'Disabled' ; RestartNotificationGPO          = 'NotConfigured'
    GetLatestAsSoonAsAvailable   = 'Disabled' ; GetLatestAsSoonAsAvailableGPO   = 'NotConfigured'
    UpdateOtherMicrosoftProducts = 'Enabled'  ; UpdateOtherMicrosoftProductsGPO = 'NotConfigured'
    InsiderProgramPageVisibility = 'Disabled'
}
Set-WinUpdateSetting @WindowsUpdateSettings

#endregion Windows Update

#endregion Part 2


Stop-Transcript
