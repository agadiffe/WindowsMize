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

Write-Output -InputObject 'Loading ''Applications\Management'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\applications\management"


#=================================================================================================================
#                                             Applications Management
#=================================================================================================================

Write-Section -Name 'Applications Management'

#==============================================================================
#                                Installation
#==============================================================================
#region installation

Write-Section -Name 'Installation' -SubSection

# --- Custom applications
# Name: winget name of the app
# Scope (optional): Machine | User
# e.g. Install-ApplicationWithWinget -Name 'Valve.Steam' -Scope 'Machine'

$CustomAppsToInstall = @(
    'Valve.Steam'
    'AppName2'
    'AppName3'
)
#$CustomAppsToInstall | Install-ApplicationWithWinget -Scope 'Machine'

# --- Predefined applications
$AppsToInstall = @(
    # --- Development
    #'Git'
    #'VSCode'

    # --- Multimedia
    'VLC'

    # --- Password Manager
    #'Bitwarden'
    #'KeePassXC'
    #'ProtonPass'

    # --- PDF Viewer
    #'AcrobatReader'
    #'SumatraPDF'

    # --- Utilities
    #'7zip'
    #'Notepad++'
    #'qBittorrent'

    # --- Web Browser
    'Brave'
    #'Firefox'
    #'MullvadBrowser'

    # --- Microsoft Visual C++ Redistributable
    #'VCRedist2015+.ARM'
    'VCRedist2015+'
    #'VCRedist2013'
    #'VCRedist2012'
    #'VCRedist2010'
    #'VCRedist2008'
    #'VCRedist2005'

    # --- Microsoft DirectX (might be needed for older games)
    #'DirectXEndUserRuntime'

    # --- Microsoft .NET Windows Desktop Runtime
    #'DotNetDesktopRuntime5'
    #'DotNetDesktopRuntime6'
    #'DotNetDesktopRuntime7'
    #'DotNetDesktopRuntime8'
    #'DotNetDesktopRuntime9'
)
$AppsToInstall | Install-Application

# --- Desktop shortcuts
Remove-AllDesktopShortcuts

# --- Windows Subsystem For Linux
#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'

#endregion installation

#==============================================================================
#                         Appx & provisioned packages
#==============================================================================
#region appx packages

# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.
#   GPO:   Disabled | NotConfigured # GPO's default is always NotConfigured.

Write-Section -Name 'Appx & provisioned packages' -SubSection

# --- Promoted/Sponsored apps (e.g. Spotify, LinkedIn)
# Windows 11 only.
Remove-StartMenuPromotedApps

# --- Bing Search in Start Menu (default: Enabled)
Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'

# --- Recall
# GPO: Disabled | Enabled | NotConfigured
Set-Recall -GPO 'Disabled'

# --- Widgets
Set-Widgets -GPO 'Disabled'

# --- Microsoft Store : Push to install service (remote app installation)
Set-MicrosoftStorePushToInstall -GPO 'Disabled'

# --- Copilot | old (This policy isn't for the new Copilot app experience)
Set-Copilot -GPO 'Disabled'

# --- Cortana | old
Set-Cortana -GPO 'Disabled'

#       Preinstalled default apps
#=======================================
# aka: Bloatware

Export-DefaultAppxPackagesNames

# --- Microsoft Edge
Remove-MicrosoftEdge

# --- OneDrive
Remove-OneDrive

# --- OneDrive : Auto install for new user (default: Enabled)
Set-OneDriveNewUserAutoInstall -State 'Disabled'

# --- Microsoft Windows Malicious Software Removal Tool
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

#endregion appx packages


Stop-Transcript
