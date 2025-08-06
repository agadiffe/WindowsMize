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

Write-Output -InputObject 'Loading ''Applications\Settings'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\applications\settings"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================
#region settings

Write-Section -Name 'Applications Settings'

#==============================================================================
#                            Adobe Acrobat Reader
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

# --- Show online storage when openings files (default: Disabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileOpen 'Disabled'

# --- Show online storage when saving files (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileSave 'Disabled'

# --- Show me messages when I launch Adobe Acrobat (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowMessagesAtLaunch 'Disabled'

# --- Send crash reports
# State: Ask (default) | Always | Never
Set-AdobeAcrobatReaderSetting -SendCrashReports 'Never'

#              Javascript
#=======================================

# --- Enable Acrobat Javascript (default: Enabled)
Set-AdobeAcrobatReaderSetting -Javascript 'Disabled'

#          Security (enhanced)
#=======================================

# --- Protected mode at startup (default: Enabled)
Set-AdobeAcrobatReaderSetting -ProtectedMode 'Enabled'

# --- Run in AppContainer (default: Enabled)
Set-AdobeAcrobatReaderSetting -AppContainer 'Enabled'

# --- Protected view (default: Disabled)
Set-AdobeAcrobatReaderSetting -ProtectedView 'Disabled'

# --- Enhanced security (default: Enabled)
Set-AdobeAcrobatReaderSetting -EnhancedSecurity 'Enabled'

# --- Automatically trust documents with valid certification (default: Disabled)
Set-AdobeAcrobatReaderSetting -TrustCertifiedDocuments 'Disabled'

# --- Automatically trust sites from my Win OS security zones (default: Enabled)
Set-AdobeAcrobatReaderSetting -TrustOSTrustedSites 'Disabled'

#             Trust manager
#=======================================

# --- Allow opening of non-PDF file attachments with external applications (default: Enabled)
Set-AdobeAcrobatReaderSetting -OpenFileAttachments 'Disabled'

#                 Units
#=======================================

# --- Page units
# Points | Inches | Millimeters | Centimeters | Picas
Set-AdobeAcrobatReaderSetting -PageUnits 'Centimeters'

#==========================================================
#                      Miscellaneous
#==========================================================

# --- Home page : Collapse recommended tools for you
# State: Expand (default) | Collapse
Set-AdobeAcrobatReaderSetting -RecommendedTools 'Collapse'

# --- First launch introduction and UI tutorial overlay (default: Enabled)
Set-AdobeAcrobatReaderSetting -FirstLaunchExperience 'Disabled'

# --- Upsell (offers to buy extra tools) (default: Enabled)
Set-AdobeAcrobatReaderSetting -Upsell 'Disabled'

# --- Usage statistics (default: Enabled)
# Doesn't work for Acrobat DC ?
Set-AdobeAcrobatReaderSetting -UsageStatistics 'Disabled'

# --- Online services and features (e.g. Sign, Sync) (default: Enabled)
Set-AdobeAcrobatReaderSetting -OnlineServices 'Disabled'

# --- Adobe cloud (default: Enabled)
Set-AdobeAcrobatReaderSetting -AdobeCloud 'Disabled'

# --- SharePoint (default: Enabled)
Set-AdobeAcrobatReaderSetting -SharePoint 'Disabled'

# --- Webmail (default: Enabled)
Set-AdobeAcrobatReaderSetting -Webmail 'Disabled'

#endregion adobe reader

#==============================================================================
#                               Microsoft Edge
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
#                              Microsoft Office
#==============================================================================
#region office

Write-Section -Name 'Microsoft Office' -SubSection

#==========================================================
#                         Options
#==========================================================

#                General
#=======================================

# --- Privacy settings : Turn on optional connected experiences (default: Enabled)
Set-MicrosoftOfficeSetting -ConnectedExperiences 'Disabled'

# --- Enable Linkedin features in my Office applications (default: Enabled)
Set-MicrosoftOfficeSetting -LinkedinFeatures 'Disabled'

# --- Show the Start screen when this application starts (default: Enabled)
Set-MicrosoftOfficeSetting -ShowStartScreen 'Disabled'

#==========================================================
#                         Privacy
#==========================================================

# --- Customer experience improvement program (default: Enabled)
Set-MicrosoftOfficeSetting -Ceip 'Disabled'

# --- Feedback (default: Enabled)
Set-MicrosoftOfficeSetting -Feedback 'Disabled'

# --- Logging (default: Enabled)
Set-MicrosoftOfficeSetting -Logging 'Disabled'

# --- Telemetry (default: Enabled)
Set-MicrosoftOfficeSetting -Telemetry 'Disabled'

#endregion office

#==============================================================================
#                               Microsoft Store
#==============================================================================
#region ms store

Write-Section -Name 'Microsoft Store' -SubSection

# --- App updates (default: Enabled)
Set-MicrosoftStoreSetting -AutoAppsUpdates 'Enabled'

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
# System (default) | Light | Dark
Set-WindowsNotepadSetting -Theme 'System'

#            Text Formatting
#=======================================

# --- Font family
# example: Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman
Set-WindowsNotepadSetting -FontFamily 'Consolas'

# --- Font style
# Regular (default) | Italic | Bold | Bold Italic
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
# NewTab (default) | NewWindow
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
# System | Light | Dark (default)
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
# ZoomInOut (default) | NextPreviousItems
Set-WindowsPhotosSetting -MouseWheelBehavior 'ZoomInOut'

# --- Zoom preference (media smaller than window)
# FitWindow | ViewActualSize (default)
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
# System (default) | Light | Dark
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
# WindowsPowerShell (default) | CommandPrompt | PowerShellCore
Set-WindowsTerminalSetting -DefaultProfile 'PowerShellCore'

# --- Default terminal application (e.g. command-line from Start Menu or Run dialog)
# LetWindowsDecide | WindowsConsoleHost (default) | WindowsTerminal
Set-WindowsTerminalSetting -DefaultCommandTerminalApp 'WindowsTerminal'

# --- Launch on machine startup (default: Disabled)
Set-WindowsTerminalSetting -RunAtStartup 'Disabled'

#==========================================================
#                         Defaults
#==========================================================

#              Appearance
#=======================================

# --- Color scheme
# CGA | Campbell (default) | Campbell Powershell | Dark+ | IBM 5153 | One Half Dark | One Half Light |
# Ottosson | Solarized Dark | Solarized Light | Tango Dark | Tango Light | Vintage
Set-WindowsTerminalSetting -DefaultColorScheme 'One Half Dark'

#               Advanced
#=======================================

# --- History size
# default: 9001 | max: 32767 (even if higher value provided)
Set-WindowsTerminalSetting -DefaultHistorySize 32767

#endregion terminal

#endregion settings


#=================================================================================================================
#                                            Applications Config Files
#=================================================================================================================
#region config files

Write-Section -Name 'Applications Settings'

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


Stop-Transcript
