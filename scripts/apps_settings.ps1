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

Write-Output -InputObject 'Loading ''Applications\Settings'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\applications\settings"



#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

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
# It means that you will have only 1 profile after applying this function.

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

# App theme
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
# Dropdown GUI values: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72
# default: 11 (range 1-99)
Set-WindowsNotepadSetting -FontSize 11

# Word wrap
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -WordWrap 'Enabled'

# Formatting
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -Formatting 'Enabled'


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

# Recent Files
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -RecentFiles 'Enabled'


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

# Status bar
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -StatusBar 'Enabled'

# Continue Previous Session tip (notepad automatically saves your progress)
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -ContinuePreviousSessionTip 'Disabled'

# Formatting tips
#---------------------------------------
# Disabled | Enabled (default)
Set-WindowsNotepadSetting -FormattingTips 'Disabled'

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


Stop-Transcript
