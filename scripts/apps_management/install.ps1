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
Write-Output -InputObject 'Loading ''Applications\Management'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\applications\management"


#=================================================================================================================
#                                             Applications Management
#=================================================================================================================

Write-Section -Name 'Applications Management'

#==============================================================================
#                                Installation
#==============================================================================

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

    # --- VPN
    #'ProtonVPN'
    #'MullvadVPN'

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

    # --- Microsoft DirectX (DX9) (might be needed for older games)
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
#Remove-AllDesktopShortcuts

# --- Windows Subsystem For Linux
#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'
