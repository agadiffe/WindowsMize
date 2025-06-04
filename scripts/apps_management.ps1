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

Write-Output -InputObject 'Loading ''Applications\Management'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\applications\management"



#=================================================================================================================
#                                             Applications Management
#=================================================================================================================

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

# Recall
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-Recall -GPO 'Disabled'

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


Stop-Transcript
