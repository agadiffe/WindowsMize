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

Import-Module -Name "$PSScriptRoot\..\src\modules\helper_functions\general"

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\$ScriptFileName.log"

Write-Output -InputObject 'Loading ''Applications\Settings'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\applications\settings"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

#=================================================================================================================
#                                            Applications Config Files
#=================================================================================================================
#region config files

Write-Section -Name 'Applications Config Files'

#==============================================================================
#                                Brave Browser
#==============================================================================

Write-Section -Name 'Brave Browser' -SubSection

<#
  Meant to be used on a fresh Brave installation.

  If used on current install, it will override the current settings.
  Including your profiles if you have more than one (the data folder will not be deleted).
  It means that you will have only 1 profile after applying this function.

  For now, to customize the settings, open the file:
    src > modules > applications > settings > private > New-BraveBrowserConfigData.ps1
  The settings are organized in the same way as in the GUI.

  By default, everything is disabled: AI, Web3, Vpn, etc ...
  This is not done via policy, so you can customize everything afterward with the Brave GUI.
#>

Set-BraveBrowserSettings

#==============================================================================
#                                    Others
#==============================================================================

<#
  The apps config files are located in the follwing folder:
    src > modules > applications > settings > config_files

  Edit these files to your preferences (don't change the file name).
  A backup is created if the config file already exist.
#>

$AppsToConfig = @(
    #'KeePassXC'
    #'qBittorrent'
    'VLC'
    #'VSCode'
    #'Git'
)
$AppsToConfig.ForEach({ Write-Section -Name $_ -SubSection ; Set-MyAppsSetting -Name $_ })

#endregion config files


#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================
#region settings

Write-Section -Name 'Applications Settings'

#==============================================================================
#                             Adobe Acrobat Reader
#==============================================================================
#region adobe reader

Write-Section -Name 'Adobe Acrobat Reader' -SubSection

#==========================================================
#                       Preferences
#==========================================================

#               Documents
#=======================================

# --- Show Tools Pane (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowToolsPane 'Disabled'

#                General
#=======================================

# --- Show online storage when openings files (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileOpen 'Disabled'

# --- Show online storage when saving files (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileSave 'Disabled'

# --- Show me messages when I launch Adobe Acrobat (ads & tips related) (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ShowMessagesAtLaunch 'Disabled' -ShowMessagesAtLaunchGPO 'Disabled'

# --- Show messages while viewing a document (popup tips related) (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ShowMessagesWhenViewingPdf 'Disabled' -ShowMessagesWhenViewingPdfGPO 'Disabled'

# --- Send crash reports
# State: Ask (default) | Always | Never
Set-AdobeAcrobatReaderSetting -SendCrashReports 'Never'

#            Email Accounts
#=======================================

# --- Add account
Set-AdobeAcrobatReaderSetting -WebmailGPO 'Disabled'

#              Javascript
#=======================================

# --- Enable Acrobat Javascript (default: Enabled)
Set-AdobeAcrobatReaderSetting -Javascript 'Disabled' -JavascriptGPO 'NotConfigured'

# --- Enable Menu Items Javascript Execution Privileges (default: Disabled)
Set-AdobeAcrobatReaderSetting -JavascriptMenuItemsExecution 'Disabled'

# --- Enable Global Object Security Policy (default: Enabled)
Set-AdobeAcrobatReaderSetting -JavascriptGlobalObjectSecurity 'Enabled'

#               Reviewing
#=======================================

# --- Show Welcome Dialog When Opening File (default: Enabled)
Set-AdobeAcrobatReaderSetting -SharedReviewWelcomeDialog 'Disabled'

#          Security (enhanced)
#=======================================

# --- Protected mode at startup (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
# GPO Disabled: disable both "Protected Mode At Startup" and "Run In AppContainer".
# GPO Enabled : only enforce "Protected Mode At Startup".
Set-AdobeAcrobatReaderSetting -ProtectedMode 'Enabled' -ProtectedModeGPO 'NotConfigured'

# --- Run in AppContainer (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -AppContainer 'Enabled' -AppContainerGPO 'NotConfigured'

# --- Protected view 
# State: Disabled (default) | UnsafeLocationsFiles | AllFiles
# GPO: Disabled | UnsafeLocationsFiles | AllFiles | NotConfigured
Set-AdobeAcrobatReaderSetting -ProtectedView 'Disabled' -ProtectedViewGPO 'NotConfigured'

# --- Enhanced security (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -EnhancedSecurity 'Enabled' -EnhancedSecurityGPO 'NotConfigured'

# --- Automatically trust documents with valid certification (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -TrustCertifiedDocuments 'Disabled' -TrustCertifiedDocumentsGPO 'NotConfigured'

# --- Automatically trust sites from my Win OS security zones (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -TrustOSTrustedSites 'Disabled' -TrustOSTrustedSitesGPO 'NotConfigured'

# --- Privileged Locations: Add File / Add Folder Path
Set-AdobeAcrobatReaderSetting -AddTrustedFilesFoldersGPO 'NotConfigured'

# --- Privileged Locations: Add Host
Set-AdobeAcrobatReaderSetting -AddTrustedSitesGPO 'NotConfigured'

#             Trust Manager
#=======================================

# --- Allow opening of non-PDF file attachments with external applications (default: Enabled)
Set-AdobeAcrobatReaderSetting -OpenFileAttachments 'Disabled' -OpenFileAttachmentsGPO 'NotConfigured'

# --- Internet access from PDF files: Access All Web Sites
# State: BlockAllWebSites | AllowAllWebSites | Custom (default)
# GPO: BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured
Set-AdobeAcrobatReaderSetting -InternetAccessFromPdf 'Custom' -InternetAccessFromPdfGPO 'NotConfigured'

# --- Internet access from PDF files: Behavior if not in the list
# State: Ask (default) | Allow | Block
# GPO: Ask | Allow | Block | NotConfigured
Set-AdobeAcrobatReaderSetting -InternetAccessFromPdfUnknownUrl 'Ask' -InternetAccessFromPdfUnknownUrlGPO 'NotConfigured'

#                 Units
#=======================================

# --- Page units
# Points | Inches | Millimeters | Centimeters | Picas
Set-AdobeAcrobatReaderSetting -PageUnits 'Centimeters'

#==========================================================
#                      Miscellaneous
#==========================================================

#                  Ads
#=======================================

# --- Upsell (offers to buy extra tools)
Set-AdobeAcrobatReaderSetting -UpsellGPO 'Disabled'

# --- Upsell Mobile App (ads on Home banner)
Set-AdobeAcrobatReaderSetting -UpsellMobileAppGPO 'Disabled'

#             Cloud Storage
#=======================================

# --- Adobe Cloud Storage
# Disable annoyances if you don't use an Adobe account.
# Disables:
#   Home page online services
#   Tools that requires Acrobat
Set-AdobeAcrobatReaderSetting -AdobeCloudStorageGPO 'Disabled'

# --- SharePoint
Set-AdobeAcrobatReaderSetting -SharePointGPO 'Disabled'

# --- Third Party Cloud Storage
Set-AdobeAcrobatReaderSetting -ThirdPartyCloudStorageGPO 'Disabled'

#                 Tips
#=======================================

# --- First launch experiences
Set-AdobeAcrobatReaderSetting -FirstLaunchExperienceGPO 'Disabled'

# --- Onboarding dialogs
Set-AdobeAcrobatReaderSetting -OnboardingDialogsGPO 'Disabled'

# --- Popup tips
Set-AdobeAcrobatReaderSetting -PopupTipsGPO 'Disabled'

#                Others
#=======================================

# --- Accept EULA (End-User License Agreement)
# GPO: Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -AcceptEulaGPO 'Enabled'

# --- Chrome extension
# The extension is automatically installed if not disabled.
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ChromeExtensionGPO 'Disabled'

# --- Crash reporter dialog
Set-AdobeAcrobatReaderSetting -CrashReporterDialogGPO 'Disabled'

# --- Home View : Top Banner
# GPO: Disabled | Expanded (default) | Collapsed
Set-AdobeAcrobatReaderSetting -HomeTopBannerGPO 'Disabled'

# --- Adobe Online Services
# Disable annoyances if you don't use an Adobe account.
# Disables:
#   Top bar icons (sign-in, notifs, ...)
#   Home page online services
#   Tools that requires Acrobat
Set-AdobeAcrobatReaderSetting -OnlineServicesGPO 'Disabled'

# --- Outlook Plugin (Adobe Send and Track plugin)
Set-AdobeAcrobatReaderSetting -OutlookPluginGPO 'Disabled'

# --- Share File (replace the Share Icon with the Email Icon)
Set-AdobeAcrobatReaderSetting -ShareFileGPO 'Disabled'

# --- Telemetry
Set-AdobeAcrobatReaderSetting -TelemetryGPO 'Disabled'

# --- Synchronizer: Run At Startup (default: Enabled)
# Disabled: Need to be reapplied after each update (or create a scheduled task).
Set-AdobeAcrobatReaderSetting -SynchronizerRunAtStartup 'Disabled'

# --- Synchronizer: Task Manager Process (default: Enabled)
# Disabled:
#   Add a ".bak" extension to "AdobeCollabSync.exe" and "FullTrustNotifier.exe" files.
#   Need to be reapplied after each update (or create a scheduled task).
#Set-AdobeAcrobatReaderSetting -SynchronizerTaskManagerProcess 'Disabled'

# --- Removes tool from the Tools tab
# Name: list of tools to remove.
# Reset: Reset every removed tools.
# Most tools are only available on Acrobat.
# Override any existing removed tools.
# i.e. Only the listed tools will be removed from the Tools tab.
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

#endregion adobe reader

#==============================================================================
#                                Microsoft Edge
#==============================================================================
#region edge

Write-Section -Name 'Microsoft Edge' -SubSection

# Basic settings if you don't use Edge and didn't removed it.
# Prevent Edge to run all the time in the background.

# GPO: Disabled | Enabled | NotConfigured

# --- Prelaunch at startup
Set-MicrosoftEdgePolicy -Prelaunch 'Disabled'

# --- Startup boost
Set-MicrosoftEdgePolicy -StartupBoost 'Disabled'

# --- Continue running background extensions and apps when Microsoft Edge is closed
Set-MicrosoftEdgePolicy -BackgroundMode 'Disabled'

#endregion edge

#==============================================================================
#                               Microsoft Office
#==============================================================================
#region office

Write-Section -Name 'Microsoft Office' -SubSection

#==========================================================
#                         Options
#==========================================================

#                General
#=======================================

# --- Enable Linkedin features in my Office applications (default: Enabled)
Set-MicrosoftOfficeSetting -LinkedinFeatures 'Disabled' -LinkedinFeaturesGPO 'NotConfigured'

# --- Show the Start screen when this application starts (default: Enabled)
Set-MicrosoftOfficeSetting -ShowStartScreen 'Disabled' -ShowStartScreenGPO 'NotConfigured'

#==========================================================
#                      Miscellaneous
#==========================================================

# --- Accept all EULAs (End-User License Agreement)
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -AcceptEULAsGPO 'Enabled'

# --- Block sign-in into Office
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -BlockSigninGPO 'NotConfigured'

# --- Teaching Tips (aka Teaching Callouts) (default: Enabled)
Set-MicrosoftOfficeSetting -TeachingTips 'Disabled'

#==========================================================
#                  Connected Experiences
#==========================================================

# --- Connected experiences
Set-MicrosoftOfficeSetting -AllConnectedExperiencesGPO 'NotConfigured'

# --- Connected experiences that analyze content
Set-MicrosoftOfficeSetting -ConnectedExperiencesThatAnalyzeContentGPO 'NotConfigured'

# --- Connected experiences that download online content
Set-MicrosoftOfficeSetting -ConnectedExperiencesThatDownloadContentGPO 'NotConfigured'

# --- Optional connected experiences (default: Enabled)
Set-MicrosoftOfficeSetting -OptionalConnectedExperiences 'Disabled' -OptionalConnectedExperiencesGPO 'NotConfigured'

#==========================================================
#                         Privacy
#==========================================================

# --- Local training of AI features
Set-MicrosoftOfficeSetting -AILocalTrainingGPO 'Disabled'

# --- Customer experience improvement program
Set-MicrosoftOfficeSetting -CeipGPO 'Disabled'

# --- Diagnostics
# GPO: Disabled | Enabled | NotConfigured
Set-MicrosoftOfficeSetting -DiagnosticsGPO 'Disabled'

# --- Microsoft Workplace Discount Program notifications
# GPO: Disabled | Enabled | NotConfigured
Set-MicrosoftOfficeSetting -DiscountProgramNotifsGPO 'Disabled'

# --- Error Reporting
Set-MicrosoftOfficeSetting -ErrorReportingGPO 'Disabled'

# --- Feedback
Set-MicrosoftOfficeSetting -FeedbackGPO 'Disabled'

# --- First Run about sign-in to Office
Set-MicrosoftOfficeSetting -FirstRunAboutSigninGPO 'Disabled'

# --- Opt-In Wizard On First Run
Set-MicrosoftOfficeSetting -FirstRunOptinWizardGPO 'Disabled'

# --- Send Personal Information
# Not applicable to Microsoft 365 App for enterprise (Replaced by Connected Experiences policies).
Set-MicrosoftOfficeSetting -SendPersonalInfoGPO 'Disabled'

# --- Surveys
Set-MicrosoftOfficeSetting -SurveysGPO 'Disabled'

# --- Telemetry
Set-MicrosoftOfficeSetting -TelemetryGPO 'Disabled'

#endregion office

#==============================================================================
#                               Microsoft Store
#==============================================================================
#region ms store

Write-Section -Name 'Microsoft Store' -SubSection

# --- App updates (default: Enabled)
Set-MicrosoftStoreSetting -AutoAppUpdates 'Enabled' -AutoAppUpdatesGPO 'NotConfigured'

# --- Notifications for app installations (default: Enabled)
Set-MicrosoftStoreSetting -AppInstallNotifications 'Enabled'

# --- Video autoplay (default: Enabled)
Set-MicrosoftStoreSetting -VideoAutoplay 'Disabled'

# --- Personalized experiences (default: Enabled)
Set-MicrosoftStoreSetting -PersonalizedExperiences 'Disabled'

#endregion ms store

#==============================================================================
#                               Windows Notepad
#==============================================================================
#region notepad

Write-Section -Name 'Windows Notepad' -SubSection

#              Appearance
#=======================================

# App theme
# State: System (default) | Light | Dark
Set-WindowsNotepadSetting -Theme 'System'

#            Text Formatting
#=======================================

# --- Font family
# State (e.g.): Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman | ...
Set-WindowsNotepadSetting -FontFamily 'Consolas'

# --- Font style
# State: Regular (default) | Italic | Bold | Bold Italic
Set-WindowsNotepadSetting -FontStyle 'Regular'

# --- Font size
# Dropdown GUI values: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72
# default: 11 (range 1-99)
Set-WindowsNotepadSetting -FontSize 11

# --- Word wrap (default: Enabled)
Set-WindowsNotepadSetting -WordWrap 'Enabled'

# --- Formatting (default: Enabled)
Set-WindowsNotepadSetting -Formatting 'Enabled'

#            Opening Notepad
#=======================================

# --- Opening files
# State: NewTab (default) | NewWindow
Set-WindowsNotepadSetting -OpenFile 'NewTab'

# --- When Notepad starts : Continue previous session (default: Enabled)
Set-WindowsNotepadSetting -ContinuePreviousSession 'Disabled'

# --- Recent Files (default: Enabled)
Set-WindowsNotepadSetting -RecentFiles 'Enabled'

#               Spelling
#=======================================

# --- Spell check (default: Enabled)
Set-WindowsNotepadSetting -SpellCheck 'Disabled'

# --- Autocorrect (default: Enabled)
Set-WindowsNotepadSetting -AutoCorrect 'Disabled'

#              AI Features
#=======================================

# --- Copilot (default: Enabled)
Set-WindowsNotepadSetting -Copilot 'Disabled'

#             Miscellaneous
#=======================================

# --- Status bar (default: Enabled)
Set-WindowsNotepadSetting -StatusBar 'Enabled'

# --- Continue Previous Session tip (notepad automatically saves your progress) (default: Enabled)
Set-WindowsNotepadSetting -ContinuePreviousSessionTip 'Disabled'

# --- Formatting tips (default: Enabled)
Set-WindowsNotepadSetting -FormattingTips 'Disabled'

#endregion windows notepad

#==============================================================================
#                                Windows Photos
#==============================================================================
#region windows photos

Write-Section -Name 'Windows Photos' -SubSection

#               Settings
#=======================================

# --- Customize theme
# State: System | Light | Dark (default)
Set-WindowsPhotosSetting -Theme 'Dark'

# --- Show gallery tiles attributes (default: Enabled)
Set-WindowsPhotosSetting -ShowGalleryTilesAttributes 'Enabled'

# --- Enable location based features (default: Disabled)
Set-WindowsPhotosSetting -LocationBasedFeatures 'Disabled'

# --- Show iCloud photos (default: Enabled)
Set-WindowsPhotosSetting -ShowICloudPhotos 'Disabled'

# --- Ask for permission to delete photos (default: Enabled)
Set-WindowsPhotosSetting -DeleteConfirmationDialog 'Enabled'

# --- Mouse wheel
# State: ZoomInOut (default) | NextPreviousItems
Set-WindowsPhotosSetting -MouseWheelBehavior 'ZoomInOut'

# --- Zoom preference (media smaller than window)
# State: FitWindow | ViewActualSize (default)
Set-WindowsPhotosSetting -SmallMediaZoomPreference 'ViewActualSize'

# --- Performance (run in the background at startup) (default: Enabled)
Set-WindowsPhotosSetting -RunAtStartup 'Disabled'

#             Miscellaneous
#=======================================

# --- First Run Experience (default: Enabled)
#   First Run Experience Dialog
#   OneDrive Promo flyout
#   Designer Editor flyout
#   ClipChamp flyout
#   AI Generative Erase tip
Set-WindowsPhotosSetting -FirstRunExperience 'Disabled'

#endregion photos

#==============================================================================
#                            Windows Snipping Tool
#==============================================================================
#region snipping tool

Write-Section -Name 'Windows Snipping Tool' -SubSection

#               Snipping
#=======================================

# --- Automatically copy changes (default: Enabled)
Set-WindowsSnippingToolSetting -AutoCopyScreenshotChangesToClipboard 'Enabled'

# --- Automatically save original screenshoots (default: Enabled)
Set-WindowsSnippingToolSetting -AutoSaveScreenshoots 'Enabled'

# --- Ask to save edited screenshots (default: Disabled)
Set-WindowsSnippingToolSetting -AskToSaveEditedScreenshots 'Disabled'

# --- Multiple windows (default: Disabled)
Set-WindowsSnippingToolSetting -MultipleWindows 'Disabled'

# --- Add border to each screenshot (default: Disabled)
Set-WindowsSnippingToolSetting -ScreenshotBorder 'Disabled'

# --- HDR screenshot color corrector (default: Disabled)
Set-WindowsSnippingToolSetting -HDRColorCorrector 'Disabled'

#           Screen recording
#=======================================

# --- Automatically copy changes (default: Enabled)
Set-WindowsSnippingToolSetting -AutoCopyRecordingChangesToClipboard 'Enabled'

# --- Automatically save original screen recordings (default: Enabled)
Set-WindowsSnippingToolSetting -AutoSaveRecordings 'Enabled'

# --- Include microphone input by default when a screen recording starts (default: Disabled)
Set-WindowsSnippingToolSetting -IncludeMicrophoneInRecording 'Disabled'

# --- Include system audio by default when a screen recording starts (default: Enabled)
Set-WindowsSnippingToolSetting -IncludeSystemAudioInRecording 'Enabled'

#              Appearance
#=======================================

# --- App theme
# State: System (default) | Light | Dark
Set-WindowsSnippingToolSetting -Theme 'System'

#endregion snipping tool

#==============================================================================
#                               Windows Terminal
#==============================================================================
#region terminal

Write-Section -Name 'Windows Terminal' -SubSection

#==========================================================
#                         Startup
#==========================================================

# --- Default profile
# State: WindowsPowerShell (default) | CommandPrompt | PowerShellCore
Set-WindowsTerminalSetting -DefaultProfile 'PowerShellCore'

# --- Default terminal application
# e.g. command-line from Start Menu or Run dialog
# State: LetWindowsDecide | WindowsConsoleHost (default) | WindowsTerminal
Set-WindowsTerminalSetting -DefaultCommandTerminalApp 'WindowsTerminal'

# --- Launch on machine startup (default: Disabled)
Set-WindowsTerminalSetting -RunAtStartup 'Disabled'

#==========================================================
#                         Defaults
#==========================================================

#              Appearance
#=======================================

# --- Color scheme
# State: CGA | Campbell (default) | Campbell Powershell | Dark+ | IBM 5153 | One Half Dark | One Half Light |
#        Ottosson | Solarized Dark | Solarized Light | Tango Dark | Tango Light | Vintage
Set-WindowsTerminalSetting -DefaultColorScheme 'One Half Dark'

#               Advanced
#=======================================

# --- History size
# default: 9001 | max: 32767 (even if higher value provided)
Set-WindowsTerminalSetting -DefaultHistorySize 32767

#endregion terminal

#endregion settings


Stop-Transcript
