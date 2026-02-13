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
  This file is the equivalent of all functions within the "scripts" folder.
#>

#Requires -RunAsAdministrator
#Requires -Version 7.5

[CmdletBinding()]
param
(
    [string] $User
)

$Global:ProvidedUserName = $User

Import-Module -Name "$PSScriptRoot\src\modules\helper_functions\general"
Test-PowerShellLanguageMode
Test-NewerWindowsMizeVersion
Start-Logging -FileName 'WindowsMize.mini'


#=================================================================================================================
#                                                     Modules
#=================================================================================================================

$WindowsMizeModuleNames = @(
    # --- Application
    'settings_app\optional_features'
    'applications\management'
    'applications\settings'

    # --- Network & Internet
    'settings_app\network_&_internet'
    'network'

    # --- System & Tweaks
    'file_explorer'
    'power_options'
    'system_properties'
    'scheduled_tasks'
    'services'
    'ramdisk'
    'tweaks'

    # --- Telemetry & Annoyances
    'telemetry'
    'settings_app\defender_security_center'
    'settings_app\privacy_&_security'

    # --- Win Settings App
    'settings_app\system'
    'settings_app\bluetooth_&_devices'
    'settings_app\personnalization'
    'settings_app\apps'
    'settings_app\accounts'
    'settings_app\time_&_language'
    'settings_app\gaming'
    'settings_app\accessibility'
    'settings_app\windows_update'
)
Import-Module -Name $WindowsMizeModuleNames.ForEach({ "$PSScriptRoot\src\modules\$_" })


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                                 Apps Management
#=================================================================================================================
#region Apps Management

Write-Section -Name 'Applications Management'

#      Appx & provisioned packages
#=======================================
#region Debloat

Remove-StartMenuPromotedApps # W11
Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'
Set-Recall -GPO 'Disabled' # Disabled | Enabled | NotConfigured
Set-Widgets -GPO 'Disabled'
Set-MicrosoftStorePushToInstall -GPO 'Disabled'
Set-Copilot -GPO 'Disabled' # old
Set-Cortana -GPO 'Disabled' # old

Export-DefaultAppxPackagesNames
Remove-MicrosoftEdge
Remove-OneDrive
Set-OneDriveNewUserAutoInstall -State 'Disabled'
Remove-MSMaliciousSoftwareRemovalTool

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
    'M365Copilot'
    'M365Companions'
    'MicrosoftCopilot'
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
    #'Xbox' # might be required for some games

    # Win 10
    '3DViewer'
    'MixedReality'
    'OneNote'
    'Paint3D'
    'Skype'
    'Wallet'
)
$PreinstalledAppsToRemove | Remove-PreinstalledAppPackage

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

#endregion Debloat

#             Installation
#=======================================
#region Install

$CustomAppsToInstall = @(
    'Valve.Steam'
    'AppName2'
    'AppName3'
)
# Scope (optional): Machine | User
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
    #'ProtonVPN'
    #'MullvadVPN'
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
    #'DirectXEndUserRuntime' # DX9
    #'DotNetDesktopRuntime5'
    #'DotNetDesktopRuntime6'
    #'DotNetDesktopRuntime7'
    #'DotNetDesktopRuntime8'
    #'DotNetDesktopRuntime9'
)
$AppsToInstall | Install-Application
#Remove-AllDesktopShortcuts

#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'

#endregion Install

#endregion Apps Management


#=================================================================================================================
#                                                  Apps Settings
#=================================================================================================================
#region Apps Settings

Write-Section -Name 'Applications Settings'

#            Acrobat Reader
#=======================================
#region acrobat reader

$AdobeReaderSettings = @{
    # --- Preferences
    ## Documents
    ShowToolsPane = 'Disabled'

    ## General
    ShowCloudStorageOnFileOpen = 'Disabled'
    ShowCloudStorageOnFileSave = 'Disabled'
    ShowMessagesAtLaunch       = 'Disabled' ; ShowMessagesAtLaunchGPO       = 'Disabled' # Disabled | Enabled | NotConfigured
    ShowMessagesWhenViewingPdf = 'Disabled' ; ShowMessagesWhenViewingPdfGPO = 'Disabled' # Disabled | Enabled | NotConfigured
    SendCrashReports           = 'Never' # Ask | Always | Never

    ## Email accounts
    WebmailGPO = 'Disabled'

    ## Javascript
    Javascript                      = 'Disabled' ; JavascriptGPO = 'NotConfigured'
    JavascriptMenuItemsExecution    = 'Disabled'
    JavascriptGlobalObjectSecurity  = 'Enabled'

    ## Reviewing
    SharedReviewWelcomeDialog = 'Disabled'

    ## Security (enhanced)
    ProtectedMode             = 'Enabled'  ; ProtectedModeGPO           = 'NotConfigured' # Disabled | Enabled | NotConfigured
    AppContainer              = 'Enabled'  ; AppContainerGPO            = 'NotConfigured' # Disabled | Enabled | NotConfigured
    ProtectedView             = 'Disabled' ; ProtectedViewGPO           = 'NotConfigured'
    EnhancedSecurity          = 'Enabled'  ; EnhancedSecurityGPO        = 'NotConfigured' # Disabled | Enabled | NotConfigured
    TrustCertifiedDocuments   = 'Disabled' ; TrustCertifiedDocumentsGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
    TrustOSTrustedSites       = 'Disabled' ; TrustOSTrustedSitesGPO     = 'NotConfigured' # Disabled | Enabled | NotConfigured
    AddTrustedFilesFoldersGPO = 'NotConfigured'
    AddTrustedSitesGPO        = 'NotConfigured'

    ## Trust manager
    OpenFileAttachments             = 'Disabled' ; OpenFileAttachmentsGPO             = 'NotConfigured'
    InternetAccessFromPdf           = 'Custom'   ; InternetAccessFromPdfGPO           = 'NotConfigured' # BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured
    InternetAccessFromPdfUnknownUrl = 'Ask'      ; InternetAccessFromPdfUnknownUrlGPO = 'NotConfigured' # Ask | Allow | Block | NotConfigured

    ## Units
    PageUnits = 'Centimeters' # Points | Inches | Millimeters | Centimeters | Picas

    # --- Miscellaneous
    ## Ads
    UpsellGPO          = 'Disabled'
    UpsellMobileAppGPO = 'Disabled'

    ## Cloud storage
    AdobeCloudStorageGPO      = 'Disabled'
    SharePointGPO             = 'Disabled'
    ThirdPartyCloudStorageGPO = 'Disabled'

    ## Tips
    FirstLaunchExperienceGPO = 'Disabled'
    OnboardingDialogsGPO     = 'Disabled'
    PopupTipsGPO             = 'Disabled'

    ## Others
    AcceptEulaGPO          = 'Enabled' # Enabled | NotConfigured
    ChromeExtensionGPO     = 'Disabled' # Disabled | Enabled | NotConfigured
    CrashReporterDialogGPO = 'Disabled'
    HomeTopBannerGPO       = 'Disabled' # Disabled | Expanded | Collapsed
    OnlineServicesGPO      = 'Disabled'
    OutlookPluginGPO       = 'Disabled'
    ShareFileGPO           = 'Disabled'
    TelemetryGPO           = 'Disabled'

    SynchronizerRunAtStartup       = 'Disabled'
    #SynchronizerTaskManagerProcess = 'Disabled'
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

#endregion acrobat reader

#          Brave, VLC, Others
#=======================================
#region Brave, VLC, Others

# src\modules\applications\settings\private\New-BraveBrowserConfigData.ps1
Set-BraveBrowserSettings

# src\modules\applications\settings\config_files
$AppsToConfig = @(
    #'KeePassXC'
    #'qBittorrent'
    'VLC'
    #'VSCode'
    #'Git'
)
$AppsToConfig | Set-MyAppsSetting

#endregion Brave, VLC, Others

#               MS Office
#=======================================
#region MS Office

# --- Microsoft Office
$MsOfficeSettings = @{
    # Options
    LinkedinFeatures = 'Disabled' ; LinkedinFeaturesGPO = 'NotConfigured'
    ShowStartScreen  = 'Disabled' ; ShowStartScreenGPO  = 'NotConfigured'

    # Miscellaneous
    AcceptEULAsGPO = 'Enabled' # Enabled | NotConfigured
    BlockSigninGPO = 'NotConfigured' # Enabled | NotConfigured
    TeachingTips   = 'Disabled'

    # Privacy
    AILocalTrainingGPO       = 'Disabled'
    CeipGPO                  = 'Disabled'
    DiagnosticsGPO           = 'Disabled' # Disabled | Enabled | NotConfigured
    DiscountProgramNotifsGPO = 'Disabled' # Disabled | Enabled | NotConfigured
    ErrorReportingGPO        = 'Disabled'
    FeedbackGPO              = 'Disabled'
    FirstRunAboutSigninGPO   = 'Disabled'
    FirstRunOptinWizardGPO   = 'Disabled'
    SendPersonalInfoGPO      = 'Disabled'
    SurveysGPO               = 'Disabled'
    TelemetryGPO             = 'Disabled'

    # Connected experiences
    AllConnectedExperiencesGPO                 = 'NotConfigured'
    ConnectedExperiencesThatAnalyzeContentGPO  = 'NotConfigured'
    ConnectedExperiencesThatDownloadContentGPO = 'NotConfigured'
    OptionalConnectedExperiences               = 'Disabled' ; OptionalConnectedExperiencesGPO = 'NotConfigured'
}
Set-MicrosoftOfficeSetting @MsOfficeSettings

#endregion MS Office

#            MS Store & Edge
#=======================================
#region MS Store & Edge

# --- MS Edge
$MicrosoftEdgePolicy = @{
    Prelaunch      = 'Disabled' # Disabled | Enabled | NotConfigured
    StartupBoost   = 'Disabled' # Disabled | Enabled | NotConfigured
    BackgroundMode = 'Disabled' # Disabled | Enabled | NotConfigured
}
Set-MicrosoftEdgePolicy @MicrosoftEdgePolicy

# --- MS Store
$MsStoreSettings = @{
    AutoAppUpdates              = 'Enabled' ; AutoAppUpdatesGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
    AppInstallNotifications     = 'Enabled'
    AutoCreateAppDesktopShorcut = 'Disabled'
    VideoAutoplay               = 'Disabled'
    PersonalizedExperiences     = 'Disabled'
}
Set-MicrosoftStoreSetting @MsStoreSettings

#endregion MS Store & Edge

#               UWP Apps
#=======================================
#region UWP Apps

# --- Windows Notepad
$NotepadSettings = @{
    Theme          = 'System' # System | Light | Dark
    FontFamily     = 'Consolas' # Arial | Calibri | Consolas | Comic Sans MS | Times New Roman | ...
    FontStyle      = 'Regular' # Regular | Italic | Bold | Bold Italic
    FontSize       = '11' # range 1-99
    WordWrap       = 'Enabled'
    Formatting     = 'Enabled'
    FormattingTips = 'Disabled'
    OpenFile       = 'NewTab' # NewTab | NewWindow
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
    Theme                      = 'Dark' # System | Light | Dark
    ShowGalleryTilesAttributes = 'Enabled'
    LocationBasedFeatures      = 'Disabled'
    ShowICloudPhotos           = 'Disabled'
    DeleteConfirmationDialog   = 'Enabled'
    ImageCategorization        = 'Disabled'
    MouseWheelBehavior         = 'ZoomInOut' # ZoomInOut | NextPreviousItems
    SmallMediaZoomPreference   = 'ViewActualSize' # FitWindow | ViewActualSize
    RunAtStartup               = 'Disabled'
    FirstRunExperience         = 'Disabled'
}
Set-WindowsPhotosSetting @PhotosSettings

# --- Windows Snipping Tool
$SnippingToolSettings = @{
    AutoCopyScreenshotChangesToClipboard = 'Enabled'
    AutoSaveScreenshots           = 'Enabled'
    AskToSaveEditedScreenshots    = 'Disabled'
    MultipleWindows               = 'Disabled'
    ScreenshotBorder              = 'Disabled'
    HDRColorCorrector             = 'Disabled'
    AutoCopyRecordingChangesToClipboard  = 'Enabled'
    AutoSaveRecordings            = 'Enabled'
    AskToSaveEditedRecordings     = 'Disabled'
    IncludeMicrophoneInRecording  = 'Disabled'
    IncludeSystemAudioInRecording = 'Enabled'
    Theme                         = 'System' # System | Light | Dark
    TeachingTips                  = 'Disabled'
}
Set-WindowsSnippingToolSetting @SnippingToolSettings

# --- Windows Terminal
$TerminalSettings = @{
    DefaultProfile            = 'PowerShellCore' # WindowsPowerShell | CommandPrompt | PowerShellCore
    DefaultCommandTerminalApp = 'WindowsTerminal' # LetWindowsDecide | WindowsConsoleHost | WindowsTerminal
    RunAtStartup              = 'Disabled'
    DefaultColorScheme        = 'One Half Dark' # Campbell | Campbell Powershell | Dark+ | One Half Dark | ...
    DefaultHistorySize        = 32767 # default: 9001 | max: 32767
}
Set-WindowsTerminalSetting @TerminalSettings

#endregion UWP Apps

#endregion Apps Settings


#=================================================================================================================
#                                               Network & Internet
#=================================================================================================================
#region Network & Internet

Write-Section -Name 'Network & Internet'

#          Network & internet
#=======================================
#region Network

# ResetServerAddresses
# FallbackToPlaintext (does not work for Mullvad)
# Provider: Adguard | Cloudflare | Mullvad | Quad9
# Server:
#   Adguard    : Default | Unfiltered | Family
#   Cloudflare : Default | Security | Family
#   Mullvad    : Default | Adblock | Base | Extended | Family | All
#   Quad9      : Default | Unfiltered
Set-DnsServer -Provider 'Cloudflare' -Server 'Default'
#Set-DnsServer -ResetServerAddresses

$NetworkSettings = @{
    ConnectedNetworkProfile   = 'Private' # Public | Private
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

#endregion Network

#                Firewall
#=======================================
#region Firewall

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
    'DCOM_RPC'
    'NetBiosTcpIP'
    'SMB'
    'MiscProgSrv' # lsass.exe, wininit.exe, Schedule, EventLog, services.exe
)
Block-DefenderFirewallInboundRule -Name $FirewallInboundRules
#Block-DefenderFirewallInboundRule -Name $FirewallInboundRules -Reset

#endregion Firewall

#               Protocol
#=======================================
#region Protocol

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
    #'IPv4'
    #'IPv6'
    #'FileSharingClient' # needed by NetworkDiscovery (File Explorer > Network)
    #'FileSharingServer' # needed by NetworkDiscovery (File Explorer > Network)
    'BridgeDriver'
    'QosPacketScheduler'
    'HyperVExtensibleVirtualSwitch'
    'Lldp'
    'MicrosoftMultiplexor'
)
Set-NetAdapterProtocol -Name $AdapterProtocolsToDisable -State 'Disabled'

# --- System Drivers (Services)
$SystemDriversToConfig = @(
    'BridgeDriver' # old ?
    'NetBiosDriver' # needed by old pc/hardware: File and Printer Sharing
    'NetBiosOverTcpIpDriver' # legacy/old | needed by old pc/hardware: File and Printer Sharing
    'LldpDriver'
    'LltdIoDriver'
    'LltdResponderDriver'
    'MicrosoftMultiplexorDriver'
    'QosPacketSchedulerDriver'
)
# Disable the above selected drivers.
#$SystemDriversToConfig | Set-ServiceStartupTypeGroup
#$SystemDriversToConfig | Set-ServiceStartupTypeGroup -RestoreDefault

# --- Miscellaneous
Set-NetBiosOverTcpIP -State 'Disabled' # Disabled | Enabled | Default
Set-NetIcmpRedirects -State 'Disabled'
Set-NetIPSourceRouting -State 'Disabled'
#Set-NetLlmnr -GPO 'NotConfigured' # needed by NetworkDiscovery (File Explorer > Network)
Set-NetLmhosts -State 'Disabled'
#Set-NetMulicastDns -State 'Disabled'
Set-NetSmhnr -GPO 'Disabled'
#Set-NetProxyAutoDetect -State 'Disabled'

#endregion Protocol

#endregion Network & Internet


#=================================================================================================================
#                                                 System & Tweaks
#=================================================================================================================
#region System & Tweaks

Write-Section -Name 'System & Tweaks'

#             File Explorer
#=======================================
#region file Explorer

$FileExplorerSettings = @{
    # --- General
    LaunchTo               = 'Home' # ThisPC | Home | Downloads | OneDrive
    #OpenFolder             = 'SameWindow' # SameWindow | NewWindow
    #OpenFolderInNewTab     = 'Enabled'
    #OpenItem               = 'DoubleClick' # SingleClick | DoubleClick
    ShowRecentFiles        = 'Enabled'
    ShowFrequentFolders    = 'Disabled'
    ShowCloudFiles         = 'Disabled'
    ShowRecommendedSection = 'Disabled'

    # --- View
    #ShowIconsOnly                    = 'Disabled'
    CompactView                      = 'Enabled'
    #ShowFileIconOnThumbnails         = 'Enabled'
    #ShowFileSizeInFolderTips         = 'Enabled'
    #ShowFullPathInTitleBar           = 'Disabled'
    #Prelaunch                        = 'Enabled'
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
    #TypingIntoListViewBehavior       = 'SelectItemInView' # SelectItemInView | AutoTypeInSearchBox
    ShowCloudStatesOnNavPane         = 'Disabled'
    #ExpandToCurrentFolder            = 'Disabled'
    #ShowAllFolders                   = 'Disabled'
    #ShowLibraries                    = 'Disabled'
    #ShowNetwork                      = 'Enabled'
    #ShowThisPC                       = 'Enabled'

    # --- Search
    DontUseSearchIndex         = 'Enabled'
    #IncludeSystemFolders       = 'Enabled'
    #IncludeCompressedFiles     = 'Disabled'
    #SearchFileNamesAndContents = 'Disabled'

    # --- Miscellaneous
    ShowHome                        = 'Enabled'
    ShowGallery                     = 'Disabled'
    ShowRemovableDrivesOnlyInThisPC = 'Enabled'
    MaxIconCacheSize                = 4096 # KB
    AutoFolderTypeDetection         = 'Disabled'
    #UndoRedo                        = 'Enabled'
    #RecycleBin                      = 'Enabled'  ; RecycleBinGPO        = 'NotConfigured'
    #ConfirmFileDelete               = 'Disabled' ; ConfirmFileDeleteGPO = 'NotConfigured'
}
Set-FileExplorerSetting @FileExplorerSettings

#endregion file Explorer

#            Power & battery
#=======================================
#region power & battery

# --- Control Panel
Set-FastStartup -State 'Disabled'
Set-Hibernate -State 'Disabled'

Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20 # min
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60 # min

Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled' # Disabled | Enabled | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled' # Disabled | Enabled | ManagedByWindows

# Level: value in percent (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown
Set-AdvancedBatterySetting -Battery 'Low'      -Level 19 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 12
Set-AdvancedBatterySetting -Battery 'Critical' -Level 9  -Action 'Sleep'

# --- Win settings app
# PowerMode: BestPowerEfficiency | Balanced | BestPerformance
# PowerSource: PluggedIn | OnBattery
Set-PowerSetting -PowerMode 'Balanced'
#Set-PowerSetting -PowerMode 'Balanced' -PowerSource 'PluggedIn'
#Set-PowerSetting -PowerMode 'BestPowerEfficiency' -PowerSource 'OnBattery'

Set-PowerSetting -BatteryPercentage 'Disabled'

# Timeout: value in minutes | never: 0
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
    TurnOnAtBatteryLevel = 30 # never: 0 | always: 100
    LowerBrightness      = 70 # range: 0-99 | Disabled: 100
}
Set-EnergySaverSetting @EnergySaverSettings

# Action: DoNothing | Sleep | Hibernate | ShutDown | DisplayOff
$ButtonControlsSettings = @(
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'PowerButton' ; Action = 'Sleep' }
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'SleepButton' ; Action = 'Sleep' }
    @{ PowerSource = 'PluggedIn' ; ButtonControls = 'LidClose'    ; Action = 'Sleep' }

    @{ PowerSource = 'OnBattery' ; ButtonControls = 'PowerButton' ; Action = 'Sleep' }
    @{ PowerSource = 'OnBattery' ; ButtonControls = 'SleepButton' ; Action = 'Sleep' }
    @{ PowerSource = 'OnBattery' ; ButtonControls = 'LidClose'    ; Action = 'Sleep' }
) | ForEach-Object { [PSCustomObject]$_ }
$ButtonControlsSettings | Set-PowerSetting

#endregion power & battery

#           System properties
#=======================================
#region system properties

# --- Miscellaneous
Set-ManufacturerAppsAutoDownload -State 'Enabled' -GPO 'NotConfigured'

# CustomSize | SystemManaged | NoPagingFile
Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 4096 -MaximumSize 4096 # MB
#Set-PagingFileSize -AllDrivesAutoManaged 'Enabled'
#Set-PagingFileSize -Drive 'X:', 'Y:' -State 'SystemManaged'

Set-DataExecutionPrevention -State 'OptIn' # OptIn | OptOut

Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
#Set-SystemRestore -Drive $env:SystemDrive -State 'Enabled'

Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured' # Disabled | FullControl | ViewOnly | NotConfigured
$RemoteAssistanceProperties = @{
    State                 = 'ViewOnly'
    GPO                   = 'NotConfigured'
    InvitationMaxTime     = 6 # range: 1-99
    InvitationMaxTimeUnit = 'Hours' # Minutes | Hours | Days
    EncryptedOnly         = 'Enabled'
    EncryptedOnlyGPO      = 'NotConfigured' # Disabled | Enabled | NotConfigured
    InvitationMethodGPO   = 'SimpleMAPI' # SimpleMAPI | Mailto
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
# ManagedByWindows | BestAppearance | BestPerformance | Custom
Set-VisualEffects -Value 'Custom' -Setting $VisualEffectsCustomSettings
#Set-VisualEffects -Value 'ManagedByWindows'

# --- System Failure
$SystemFailureSettings = @{
    WriteEventToSystemLog      = 'Enabled'
    AutoRestart                = 'Disabled'
    WriteDebugInfo             = 'None' # None | Complete | Kernel | Small | Automatic | Active
    OverwriteExistingDebugFile = 'Enabled'
    AlwaysKeepMemoryDumpOnLowDiskSpace = 'Disabled'
}
Set-SystemFailureSetting @SystemFailureSettings

#endregion system properties

#      Services & Scheduled Tasks
#=======================================
#region services & tasks

# --- Services
Export-DefaultServicesStartupType
Export-DefaultSystemDriversStartupType

# Minimum recommended:
#   'Deprecated'
#   'RemoteDesktop'
#   'Telemetry'

# src\modules\services\private
$ServicesToConfig = @(
    # --- SystemDriver
    'UserChoiceProtectionDriver'
    #'OfflineFilesDriver'
    #'NetworkDataUsageDriver'

    # --- Windows
    'Features'      # adjust to your needs: Features.ps1 (21 Svcs) (e.g. SysMain (disabled)).
    'Miscellaneous' # adjust to your needs: Miscellaneous.ps1 : everything should be ok (61 Svcs).

    #'Autoplay'
    #'Bluetooth'
    #'BluetoothAndCast'
    #'BluetoothAudio'
    'DefenderPhishingProtection' # do not disable if you use Edge with 'Phishing Protection' enabled.
    'Deprecated'
    'DiagnosticAndUsage'
    #'FileAndPrinterSharing' # needed by NetworkDiscovery (File Explorer > Network).
    'HyperV'
    #'MicrosoftOffice'
    'MicrosoftStore' # only 'PushToInstall service' is disabled. all others are left to default state 'Manual'.
    'Network'
    #'NetworkDiscovery' # needed by printer and FileAndPrinterSharing.
    'Printer'
    'RemoteDesktop'
    #'Sensor' # screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in).
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    'Vpn' # only needed if using the built-in Windows VPN feature (i.e. not needed if using 3rd party VPN client).
    #'Webcam' # only needed by MS Store apps. e.g. Microsoft Teams, Skype, or Camera app.
    'WindowsBackupAndSystemRestore' # System Restore is left to default state 'Manual'.
    'WindowsSearch'
    #'WindowsSubsystemForLinux'
    'Xbox'

    # --- ThirdParty
    #'AdobeAcrobat'
    'Intel'
    #'Nvidia'
)
$ServicesToConfig | Set-ServiceStartupTypeGroup

# The script must have been executed at least once.
#Restore-ServiceStartupTypeFromBackup
#Restore-ServiceStartupTypeFromBackup -FilePath 'X:\Backup\windows_services_default.json'

# --- Scheduled Tasks
Export-DefaultScheduledTasksState

# Everything should be ok/harmless.

# src\modules\scheduled_tasks\private
$TasksToConfig = @(
    #'AdobeAcrobat'
    'Diagnostic'
    'Features'
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'UserChoiceProtectionDriver'
)
$TasksToConfig | Set-ScheduledTaskStateGroup

# The script must have been executed at least once.
#Restore-ScheduledTaskStateFromBackup
#Restore-ScheduledTaskStateFromBackup -FilePath 'X:\Backup\windows_scheduled_tasks_default.json'

#endregion services & tasks

#                Ramdisk
#=======================================
#region ramdisk

#Install-OSFMount

# src\modules\ramdisk\private\app_data
$AppToRamDisk = @(
    'Brave'
    #'VSCode'
)
# Size: number + M or G (e.g. 512M or 4G)
#Set-RamDisk -Size '2G' -AppToRamDisk $AppToRamDisk

#endregion ramdisk

#                Tweaks
#=======================================
#region tweaks

# --- Security, privacy and networking
Set-DisplayLastSignedinUserName -GPO 'Enabled' # Disabled | Enabled
Set-HomeGroup -GPO 'Disabled' # old
Set-Hotspot2 -State 'Disabled'
Set-LocalAccountsSecurityQuestions -GPO 'Disabled'
Set-LockScreenCameraAccess -GPO 'Disabled'
Set-MessagingCloudSync -GPO 'Disabled'
#Set-NotificationsNetworkUsage -GPO 'NotConfigured'
Set-PasswordExpiration -State 'Disabled'
Set-PasswordRevealButton -GPO 'Disabled'
Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'
Set-PrintingOverHttp -GPO 'Disabled'
Set-WifiSense -GPO 'Disabled' # old
Set-Wpbt -State 'Disabled'

# --- System and performance
Set-FirstSigninAnimation -GPO 'Disabled' # Disabled | Enabled | NotConfigured
#Set-FullscreenOptimizations -State 'Disabled' # Disabled | Enabled | Default
Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled' # Managed: User | System
Set-NumLockAtStartup -State 'Enabled'
Set-ServiceHostSplitting -State 'Enabled'
#Set-StartupAppsDelay -Value 2 # s / range: 0-45s
#Set-StartupAppsDelay -Default
#Set-StartupShutdownVerboseStatusMessages -GPO 'NotConfigured' # Enabled | NotConfigured

# 'PROGRA~1', 'COMMON~1', and others, will not be stripped because they are in used (access denied).
# To remove them:
#   - Settings > System > Recovery > Advanced Startup: click on "Restart now".
#   - On the recovery Menu, choose: Troubleshoot > Commmand Prompt.
#   - Check the Windows drive letter with DISKPART: list disk, select disk 0, list volume
#   - On the Commmand Prompt, run: fsutil.exe 8Dot3Name strip /f /s /l C:\8dot3.log C:
#     Note: "/l C:\8dot3.log" will save the log file into your C: drive instead of the recovery partition.
Set-Short8Dot3FileName -State 'Disabled'
#Set-Short8Dot3FileName -State 'Disabled' -RemoveExisting8dot3FileNames

# --- User interface and experience
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
# Win11 24H2+ only.
#Set-ActionCenterLayout -Value $ActionCenterLayout
#Set-ActionCenterLayout -Reset

#Disable-GameBarLinks # Fix error if XBox GameBar is uninstalled
Set-CopyPasteDialogShowMoreDetails -State 'Enabled'
Set-HelpTips -GPO 'Disabled'
Set-MenuShowDelay -Value '200' # ms | range 50-1000
Set-OnlineTips -GPO 'Disabled'
Set-ShortcutNameSuffix -State 'Disabled'
Set-StartMenuAllAppsViewMode -Value 'Category' # Category | Grid | List
#Set-StartMenuRecommendedSection -GPO 'NotConfigured' # Enterprise/Edu only
Set-SuggestedContent -State 'Disabled'
Set-TaskbarCalendarState -Value 'Expanded' # Collapsed | Expanded
Set-WindowsExperimentation -GPO 'Disabled'
Set-WindowsInputExperience -State 'Disabled' # don't disable if touchscreen
Set-WindowsPrivacySettingsExperience -GPO 'Disabled'
Set-WindowsSettingsSearchAgent -GPO 'NotConfigured'
Set-WindowsSharedExperience -GPO 'NotConfigured' # disable: "nearby sharing" and "share across devices"

$WindowsSpotlightSettings = @{
    AllFeaturesGPO = 'NotConfigured'
    DesktopGPO     = 'NotConfigured'
    LockScreenGPO  = 'NotConfigured' # Enterprise only
    AdsContentGPO  = 'Disabled'
    #LearnAboutPictureDesktopIcon = 'Disabled'
}
Set-WindowsSpotlight @WindowsSpotlightSettings

# --- Windows features and settings
#Move-CharacterMapShortcutToWindowsTools
Set-DisplayLockScreen -GPO 'NotConfigured'
#Set-DisplayModeChangeAnimation -State 'Disabled'
#Set-EventLogLocation -Path 'X:\MyEventsLogs'
#Set-EventLogLocation -Default
Set-EaseOfAccessReadScanSection -State 'Disabled'
Set-FileHistory -GPO 'Disabled'
Set-FontProviders -GPO 'Disabled' # Disabled | Enabled | NotConfigured
Set-HomeSettingPageVisibility -GPO 'Disabled'
Set-LocationPermission -GPO 'NotConfigured'
Set-LocationScriptingPermission -GPO 'NotConfigured'
Set-OpenWithDialogStoreAccess -GPO 'Disabled'
Set-SensorsPermission -GPO 'NotConfigured'
#Set-TaskbarLastActiveClick -State 'Enabled'
Set-WindowsHelpSupportSetting -F1Key 'Disabled'
Set-WindowsHelpSupportSetting -FeedbackGPO 'Disabled'
Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'
Set-WindowsUpdateSearchDrivers -GPO 'NotConfigured' # Disabled | Enabled | NotConfigured

#endregion tweaks

#endregion System & Tweaks


#=================================================================================================================
#                                             Telemetry & Annoyances
#=================================================================================================================
#region Telemetry & Annoyances

Write-Section -Name 'Telemetry & Annoyances'

#               Telemetry
#=======================================
#region telemetry

# DiagnosticTracing: TrustedInstaller protected key. Need to be changed manually.
# See src\modules\telemetry\private\Set-DiagnosticTracing.ps1

Disable-DotNetTelemetry
Disable-NvidiaTelemetry
Disable-PowerShellTelemetry
Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'

Set-AppAndDeviceInventory -GPO 'Disabled'
Set-ApplicationCompatibility -GPO 'Disabled'
Set-CloudContent -GPO 'NotConfigured' # also disable: Windows Spotlight
Set-ConsumerExperience -GPO 'NotConfigured' # also disable: 'settings > bluetooth & devices > mobile devices'
Set-Ceip -GPO 'Disabled' # Disabled | Enabled | NotConfigured
Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'
Set-ErrorReporting -GPO 'Disabled'
Set-GroupPolicySettingsLogging -GPO 'Disabled'
Set-HandwritingPersonalization -GPO 'Disabled'
Set-KmsClientActivationDataSharing -GPO 'Disabled'
Set-MsrtDiagnosticReport -GPO 'Disabled'
Set-OneSettingsDownloads -GPO 'Disabled'
Set-UserInfoSharing -GPO 'Disabled' # Disabled | Enabled | NotConfigured

#endregion telemetry

#    Windows Security (aka Defender)
#=======================================
#region Windows security

# --- Settings
$DefenderSettings = @{
    CloudDeliveredProtection = 'Disabled'  ; CloudDeliveredProtectionGPO = 'NotConfigured' # Disabled | Basic | Advanced | NotConfigured
    AutoSampleSubmission     = 'NeverSend' ; AutoSampleSubmissionGPO     = 'NotConfigured' # NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured
    #AdminProtection          = 'Disabled'
    SmartAppControl          = 'Disabled'
    CheckAppsAndFiles        = 'Disabled'  ; CheckAppsAndFilesGPO        = 'NotConfigured' # GPO: Disabled | Warn | Block | NotConfigured
    SmartScreenForEdge       = 'Disabled'  ; SmartScreenForEdgeGPO       = 'NotConfigured' # GPO: Disabled | Warn | Block | NotConfigured
    PhishingProtectionGPO    = 'Disabled' # Disabled | Warn | Block | NotConfigured
    UnwantedAppBlocking      = 'Disabled'  ; UnwantedAppBlockingGPO      = 'NotConfigured' # Disabled | Enabled | AuditMode | NotConfigured
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

#          Windows Permissions
#=======================================
#region Win Permissions

# --- User Data (aka: General / Recommendations & offers)
$PrivacyWinPermUserData = @{
    FindMyDevice            = 'Disabled' ; FindMyDeviceGPO         = 'NotConfigured' # Disabled | Enabled | NotConfigured
    PersonalizedOffers      = 'Disabled' ; PersonalizedOffersGPO   = 'Disabled'
    LanguageListAccess      = 'Disabled'
    TrackAppLaunches        = 'Disabled' ; TrackAppLaunchesGPO     = 'NotConfigured'
    ShowAdsInSettingsApp    = 'Disabled' ; ShowAdsInSettingsAppGPO = 'NotConfigured'
    AdvertisingID           = 'Disabled' ; AdvertisingIDGPO        = 'NotConfigured'
    ShowNotifsInSettingsApp = 'Disabled' # old
    ActivityHistory         = 'Disabled' ; ActivityHistoryGPO      = 'NotConfigured' # old
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
    DiagnosticData          = 'Disabled' ; DiagnosticDataGPO         = 'Disabled' # Disabled | OnlyRequired | OptionalAndRequired | NotConfigured
    ImproveInkingAndTyping  = 'Disabled' ; ImproveInkingAndTypingGPO = 'Disabled'
    DiagnosticDataViewer    = 'Disabled' ; DiagnosticDataViewerGPO   = 'Disabled'
    DeleteDiagnosticDataGPO = 'NotConfigured'
    FeedbackFrequency       = 'Never'    ; FeedbackFrequencyGPO      = 'Disabled' # State: Never | Automatically | Always | Daily | Weekly
}
Set-WinPermissionsSetting @PrivacyWinPermTelemetry

# --- Search
$PrivacyWinPermSearch = @{
    #SafeSearch             = 'Disabled' # old
    SearchHistory          = 'Disabled'
    SearchHighlights       = 'Disabled' ; SearchHighlightsGPO = 'NotConfigured'
    CloudSearchGPO         = 'NotConfigured'
      CloudSearchMicrosoftAccount    = 'Disabled'
      CloudSearchWorkOrSchoolAccount = 'Disabled'
    CloudFileContentSearch = 'Disabled'
    StartMenuWebSearch     = 'Disabled' # EEA
    FindMyFiles            = 'Classic' # Classic | Enhanced
    IndexEncryptedFilesGPO = 'Disabled' # Disabled | Enabled | NotConfigured
}
Set-WinPermissionsSetting @PrivacyWinPermSearch

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
    #BackgroundApps         = 'Disabled' ; BackgroundAppsGPO         = 'NotConfigured' # e.g. needed by Windows Spotlight
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
    Passkeys        = 'Disabled'
      PasskeysAutofill = 'Disabled'
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

#             Notifications
#=======================================
#region Notifications

# --- Notifications
$NotificationsSettings = @{
    Notifications            = 'Disabled' ; NotificationsGPO    = 'NotConfigured'
    PlaySounds               = 'Disabled'
    ShowOnLockScreen         = 'Disabled' ; ShowOnLockScreenGPO = 'NotConfigured'
    ShowRemindersAndIncomingCallsOnLockScreen = 'Disabled'
    ShowBellIcon             = 'Disabled'
    ScreenIndicatorsPosition = 'BottomCenter' # BottomCenter | TopLeft | TopCenter
}
Set-NotificationsSetting @NotificationsSettings

$SenderNotifs = @(
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
Set-NotificationsSetting -AppsAndOtherSenders $SenderNotifs -State 'Disabled'

# --- Notifications - Ads
$NotificationsAdsSettings = @{
    ShowWelcomeExperience     = 'Disabled' ; ShowWelcomeExperienceGPO = 'NotConfigured'
    SuggestWaysToFinishConfig = 'Disabled'
    TipsAndSuggestions        = 'Disabled' ; TipsAndSuggestionsGPO    = 'NotConfigured'
}
Set-NotificationsSetting @NotificationsAdsSettings

#endregion Notifications

#            Start & Taskbar
#=======================================
#region Start & Taskbar

# --- Start
$StartSettings = @{
    #LayoutMode               = 'Default' # old / Default | MorePins | MoreRecommendations
    ShowAllPins              = 'Enabled'
    ShowRecentlyAddedApps    = 'Disabled' ; ShowRecentlyAddedAppsGPO   = 'NotConfigured'
    ShowRecentlyOpenedItems  = 'Enabled'  ; ShowRecentlyOpenedItemsGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
    ShowRecommendations      = 'Disabled'
    ShowWebsitesFromHistoryGPO = 'Disabled'
    ShowMostUsedApps         = 'Disabled' ; ShowMostUsedAppsGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
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
    SearchBox       = 'Hide'     ; SearchBoxGPO = 'NotConfigured' # Hide | IconOnly | Box | IconAndLabel | NotConfigured
    AskCopilot      = 'Disabled'
    TaskView        = 'Disabled' ; TaskViewGPO  = 'NotConfigured'
    #Widgets         = 'Disabled' # UCPD protected
    ResumeAppNotif  = 'Disabled'
    EmojiAndMore    = 'Never' # Never | WhileTyping | Always
    PenMenu         = 'Disabled'
    TouchKeyboard   = 'WhenNoKeyboard' # Never | Always | WhenNoKeyboard
    VirtualTouchpad = 'Disabled'
    HiddenIconMenu  = 'Enabled'

    Alignment                       = 'Center' # Left | Center
    #TouchOptimized                  = 'Enabled'
    AutoHide                        = 'Disabled'
    #ShowAppsBadges                  = 'Enabled'
    #ShowAppsFlashing                = 'Enabled'
    #ShowOnAllDisplays               = 'Disabled' ; ShowOnAllDisplaysGPO = 'NotConfigured'
    #ShowAppsOnMultipleDisplays      = 'AllTaskbars' # AllTaskbars | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen
    ShareAnyWindowWith              = 'None' # None | AllApps | CommunicationApps | ChatAgentApps
    FarCornerToShowDesktop          = 'Enabled'
    GroupAndHideLabelsMainTaskbar   = 'Always' ; GroupAndHideLabelsGPO = 'NotConfigured'
    #GroupAndHideLabelsOtherTaskbars = 'Always' # # State (main + other): Always | WhenTaskbarIsFull | Never
    ShowSmallerButtons              = 'WhenFull' # Always | Never | WhenFull
    ShowJumplistOnHover             = 'Enabled'
}
Set-TaskbarSetting @TaskbarSettings

#endregion Start & Taskbar

#endregion Telemetry & Annoyances


#=================================================================================================================
#                                                Win Settings App
#=================================================================================================================
#region Win Settings App

Write-Section -Name 'Windows Settings App'

#                System
#=======================================
#region system

# --- Display
$DisplayBrightnessSettings = @{
    Brightness              = 70 # range: 0-100
    AdjustOnLightingChanges = 'Disabled'
    AdjustBasedOnContent    = 'Disabled' # Disabled | Enabled | BatteryOnly
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
# DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent | ReduceOtherSoundsBy50Percent
Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'

# --- Storage
$StorageSenseSettings = @{
    StorageSense     = 'Disabled' ; StorageSenseGPO     = 'NotConfigured' # Disabled | Enabled | NotConfigured
    CleanupTempFiles = 'Enabled'  ; CleanupTempFilesGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
}
Set-StorageSenseSetting @StorageSenseSettings

# --- Nearby sharing
$NearbySharingSettings = @{
    DragTray          = 'Disabled'
    NearbySharing     = 'Disabled' # Disabled | DevicesOnly | EveryoneNearby
    #FileSaveLocation = 'X:\MySharedFiles'
}
Set-NearbySharingSetting @NearbySharingSettings

# --- Multitasking
$MultitaskingSettingSettings = @{
    ShowAppsTabsOnSnapAndAltTab = 'ThreeMostRecent' ; ShowAppsTabsOnSnapAndAltTabGPO = 'NotConfigured' # TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured
    TitleBarWindowShake         = 'Disabled'        ; TitleBarWindowShakeGPO         = 'NotConfigured'
    ShowAllWindowsOnTaskbar     = 'CurrentDesktop' # AllDesktops | CurrentDesktop
    ShowAllWindowsOnAltTab      = 'CurrentDesktop' # AllDesktops | CurrentDesktop
}
Set-MultitaskingSetting @MultitaskingSettingSettings

$SnapWindowsSettings = @{
    SnapWindows                = 'Enabled'
    SnapSuggestions            = 'Enabled'
    ShowLayoutOnMaxButtonHover = 'Enabled'
    ShowLayoutOnTopScreen      = 'Enabled'
}
Set-SnapWindowsSetting @SnapWindowsSettings

# --- Advanced
$AdvancedSettings = @{
    EndTask             = 'Disabled'
    ModernRunDialog     = 'Disabled'
    LongPaths           = 'Enabled'
    Sudo                = 'Disabled' # Disabled | NewWindow | InputDisabled | Inline
    MoreAgentConnectors = 'Disabled'
}
Set-SystemAdvancedSetting @AdvancedSettings

# --- Troubleshoot
Set-TroubleshooterPreference -Value 'Disabled' # Disabled | AskBeforeRunning | AutoRunAndNotify | AutoRunSilently

# --- Recovery
# RetryInterval: value are in minutes, default: 0, range: 0-720
#   GUI values: Once (0) | 10 mins | 30 mins | 1 hour (60) | 2 hours (120) | 3 hours (180) | 6 hours (360) | 12 hours (720)
Set-QuickMachineRecovery -State 'Disabled'
#Set-QuickMachineRecovery -State 'Enabled' -AutoRemediation 'Enabled' -RetryInterval 0

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
    History           = 'Disabled' ; HistoryGPO           = 'NotConfigured' # Disabled | Enabled | NotConfigured
    SyncAcrossDevices = 'Disabled' ; SyncAcrossDevicesGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
    #SuggestedActions  = 'Disabled' # old
}
Set-ClipboardSetting @ClipboardSettings

# --- AI Components
Set-AIComponentsSetting -AgenticFeatures 'Disabled'

#endregion system

#          Bluetooth & devices
#=======================================
#region bluetooth & devices

# --- Devices
$BluetoothSettings = @{
    BluetoothGPO                 = 'NotConfigured'
    ShowQuickPairConnectionNotif = 'Enabled' ; ShowQuickPairConnectionNotifGPO = 'NotConfigured'
    LowEnergyAudio               = 'Enabled'
    #DiscoveryMode                = 'Default' # old
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

# --- AutoPlay
$AutoPlaySettings = @{
    AutoPlay       = 'Enabled'    ; AutoPlayGPO = 'NotConfigured'
    RemovableDrive = 'OpenFolder' # Default | NoAction | OpenFolder | AskEveryTime
    MemoryCard     = 'OpenFolder' # Default | NoAction | OpenFolder | AskEveryTime
}
Set-AutoPlaySetting @AutoPlaySettings

# --- USB
$UsbSettings = @{
    NotifOnErrors      = 'Enabled'
    BatterySaver       = 'Enabled'
    NotifOnWeakCharger = 'Enabled'
}
Set-UsbSetting @UsbSettings

# --- Mouse
$MouseSettings = @{
    PrimaryButton                = 'Left' # Left | Right
    PointerSpeed                 = 10 # range: 1-20
    EnhancedPointerPrecision     = 'Enabled'
    ScrollInactiveWindowsOnHover = 'Enabled'
    ScrollingDirection           = 'DownMotionScrollsDown' # DownMotionScrollsDown | DownMotionScrollsUp
}
Set-MouseSetting @MouseSettings

#Set-MouseSetting -WheelScroll 'OneScreen'
Set-MouseSetting -WheelScroll 'MultipleLines' -LinesToScroll 3 # range: 1-100

# --- Touchpad
$TouchpadSettings = @{
    Touchpad                     = 'Enabled'
    LeaveOnWithMouse             = 'Enabled'
    CursorSpeed                  = 5 # range: 1-10
    Sensitivity                  = 'Medium' # Max | High | Medium | Low
    TapToClick                   = 'Enabled'
    TwoFingersTapToRightClick    = 'Enabled'
    TapTwiceAndDragToMultiSelect = 'Enabled'
    RightClickButton             = 'Enabled'
    TwoFingersToScroll           = 'Enabled'
    ScrollingDirection           = 'DownMotionScrollsUp' # DownMotionScrollsDown | DownMotionScrollsUp
    PinchToZoom                  = 'Enabled'
    #ThreeFingersTap              = 'OpenSearch'
    #ThreeFingersSwipes           = 'SwitchAppsAndShowDesktop'
    #FourFingersTap               = 'NotificationCenter'
    #FourFingersSwipes            = 'SwitchDesktopsAndShowDesktop'
}
#Set-TouchpadSetting @TouchpadSettings

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

#endregion bluetooth & devices

#           Personnalization
#=======================================
#region personnalization

# --- Background
$BackgroundSettings = @{
    Wallpaper      = "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
    WallpaperStyle = 'Fill' # Fill | Fit | Stretch | Span | Tile | Center
}
#Set-BackgroundSetting @BackgroundSettings

# --- Colors
$ColorsSettings = @{
    Theme           = 'Dark' # Dark | Light
    Transparency    = 'Enabled'
    AccentColorMode = 'Manual' # Manual | Automatic
    ShowAccentColorOnStartAndTaskbar = 'Disabled'
    ShowAccentColorOnTitleAndBorders = 'Disabled'
}
Set-ColorsSetting @ColorsSettings

# --- Themes - Desktop icons
$DesktopIcons = @(
    'ThisPC'
    #'UserFiles'
    #'Network'
    'RecycleBin'
    #'ControlPanel'
)
Set-ThemesSetting -DesktopIcons $DesktopIcons
#Set-ThemesSetting -HideAllDesktopIcons
Set-ThemesSetting -ThemesCanChangeDesktopIcons 'Disabled'

# --- Dynamic Lighting
$DynamicLightingSettings = @{
    DynamicLighting           = 'Disabled'
    ControlledByForegroundApp = 'Disabled'
}
Set-DynamicLightingSetting @DynamicLightingSettings

# --- Lock screen
$LockScreenSettings = @{
    #SetToPicture                 = $true
    #GetFunFactsTipsTricks        = 'Disabled' # also unset: Windows Spotlight
    ShowPictureOnSigninScreen    = 'Enabled'  ; ShowPictureOnSigninScreenGPO = 'NotConfigured'
    YourWidgets                  = 'Disabled' ; YourWidgetsGPO               = 'NotConfigured'
}
Set-LockScreenSetting @LockScreenSettings

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
    ChooseWhereToGetApps = 'Anywhere' ; ChooseWhereToGetAppsGPO = 'NotConfigured' # Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured
    ShareAcrossDevices   = 'Disabled' # Disabled | DevicesOnly | EveryoneNearby
    AutoArchiveApps      = 'Disabled' ; AutoArchiveAppsGPO      = 'NotConfigured'
    AppsOpenLinksInsteadOfBrowserGPO = 'NotConfigured'
    AppsResume           = 'Disabled' ; AppsResumeGPO           = 'NotConfigured'
}
Set-GeneralAppsSetting @AppsSettings

$AppActionsSettings = @{
    M365Copilot = 'Disabled'
    MSOffice    = 'Disabled'
    MSTeams     = 'Disabled'
    Paint       = 'Disabled'
    Photos      = 'Disabled'
}
#Set-AppActions -Setting $AppActionsSettings

$OfflineMapsSettings = @{
    DownloadOverMeteredConnection = 'Disabled' # old
    AutoUpdateOnACAndWifi         = 'Disabled' ; AutoUpdateOnACAndWifiGPO = 'NotConfigured' # old
}
Set-OfflineMapsSetting @OfflineMapsSettings

#endregion apps

#                 Accounts
#=======================================
#region accounts

Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured' # CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured
Set-WinBackupSetting -RememberAppsAndPrefsGPO 'DefaultOff' # DefaultOff | Disabled | NotConfigured

$AccountsSettings = @{
    BiometricsGPO                  = 'NotConfigured'
    SigninWithExternalDevice       = 'Enabled'
    OnlyWindowsHelloForMSAccount   = 'Disabled'
    # Standard Standby (S3) : Never | OnWakesUpFromSleep
    # Modern Standby (S0)   : Never | Always | OneMin | ThreeMins | FiveMins | FifteenMins
    SigninRequiredIfAway           = 'Never'
    DynamicLock                    = 'Disabled' ; DynamicLockGPO        = 'NotConfigured' # Disabled | Enabled | NotConfigured
    AutoRestartApps                = 'Disabled'
    ShowAccountDetails             = 'Disabled' ; ShowAccountDetailsGPO = 'NotConfigured'
    AutoFinishSettingUpAfterUpdate = 'Disabled' ; AutoFinishSettingUpAfterUpdateGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
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
    #ShowAbbreviatedValue     = 'Disabled' # old
    ShowSecondsInSystemClock = 'Disabled'
    ShowTimeInNotifCenter    = 'Enabled'
    #TimeServer               = 'Windows' # Cloudflare | Windows | NistGov | PoolNtpOrg
}
Set-DateAndTimeSetting @DateTimeSettings

# --- Language & region
# Install or remove: Basic typing, Handwriting, OCR, Speech recognition, Text-To-Speech.
#Set-LanguageFeatures -State 'Disabled' # W11

$LanguageAndRegionSettings = @{
    FirstDayOfWeek            = 'Monday'
    ShortDateFormat           = 'dd-MMM-yy' # 05-Apr-42
    Utf8ForNonUnicodePrograms = 'Enabled'
}
Set-LanguageAndRegionSetting @LanguageAndRegionSettings

# --- Typing
$TypingSettings = @{
    ShowTextSuggestionsOnSoftwareKeyboard = 'Disabled' # old ?
    ShowTextSuggestionsOnPhysicalKeyboard = 'Disabled'
    MultilingualTextSuggestions           = 'Disabled'
    AutocorrectMisspelledWords            = 'Disabled'
    HighlightMisspelledWords              = 'Disabled'
    TypingAndCorrectionHistory            = 'Disabled'
    UseDifferentInputMethodForEachApp     = 'Disabled'
    LanguageBar                           = 'DockedInTaskbar' # FloatingOnDesktop | DockedInTaskbar | Hidden
    SwitchInputLanguageHotKey             = 'NotAssigned' # NotAssigned | CtrlShift | LeftAltShift | GraveAccent
    SwitchKeyboardLayoutHotKey            = 'NotAssigned' # NotAssigned | CtrlShift | LeftAltShift | GraveAccent
}
Set-TypingSetting @TypingSettings

#endregion time & language

#                Gaming
#=======================================
#region gaming

$GamingSettings = @{
    OpenGameBarWithController      = 'Disabled'
    UseViewMenuAsGuideButtonInApps = 'Disabled'
    GameRecording                  = 'Disabled' ; GameRecordingGPO = 'NotConfigured'
    GameMode                       = 'Disabled'
}
Set-GamingSetting @GamingSettings

#endregion gaming

#                 Accessibility
#=======================================
#region accessibility

$AccessibilitySettings = @{
    VisualEffectsAlwaysShowScrollbars       = 'Disabled'
    VisualEffectsAnimation                  = 'Enabled'
    VisualEffectsNotificationsDuration      = 5 # s
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

#            Windows Update
#=======================================
#region Windows Update

$WindowsUpdateSettings = @{
    GetLatestAsSoonAsAvailable     = 'Disabled' ; GetLatestAsSoonAsAvailableGPO     = 'NotConfigured'
    PauseUpdatesGPO                = 'NotConfigured'
    UpdateOtherMicrosoftProducts   = 'Enabled'  ; UpdateOtherMicrosoftProductsGPO   = 'NotConfigured' # GPO: Enabled | NotConfigured
    GetMeUpToDate                  = 'Disabled'
    DownloadOverMeteredConnections = 'Disabled' ; DownloadOverMeteredConnectionsGPO = 'NotConfigured' # Disabled | Enabled | NotConfigured
    RestartNotification            = 'Enabled' ; RestartNotificationGPO            = 'NotConfigured'
    DeliveryOptimization           = 'Disabled' ; DeliveryOptimizationGPO           = 'NotConfigured' # Disabled | LocalNetwork | InternetAndLocalNetwork | NotConfigured
    InsiderProgramPageVisibility   = 'Disabled'
}
Set-WinUpdateSetting @WindowsUpdateSettings

# Values are in 24H clock format (range 0-23), Max range is 18 hours.
#Set-WinUpdateSetting -ActiveHoursMode 'Automatically' -ActiveHoursGPO 'NotConfigured' # State: Automatically | Manually
Set-WinUpdateSetting -ActiveHoursMode 'Manually' -ActiveHoursStart 7 -ActiveHoursEnd 1
#Set-WinUpdateSetting -ActiveHoursGPO 'Enabled' -ActiveHoursStart 7 -ActiveHoursEnd 1 # GPO: Enabled | NotConfigured

#endregion Windows Update

#endregion Win Settings App


Stop-Transcript # Stop Logging
