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
Write-Output -InputObject 'Loading ''Applications\Management'' & ''settings_app\optional_features'' Modules ...'
$WindowsMizeModuleNames = @( 'applications\management', 'settings_app\optional_features' )
Import-Module -Name $WindowsMizeModuleNames.ForEach({ "$PSScriptRoot\..\..\src\modules\$_" })


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                             Applications Management
#=================================================================================================================

Write-Section -Name 'Applications Management'

#==============================================================================
#                         Appx & provisioned packages
#==============================================================================
#region appx packages

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
    'Microsoft365'
    'Microsoft365Companions'
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

#endregion appx packages

#==========================================================
#                    Optional features
#==========================================================
#region optional features

Write-Section -Name 'Optional features' -SubSection

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

#endregion optional features
