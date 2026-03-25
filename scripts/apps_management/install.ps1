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
# Id: winget app Id
# Scope (optional): Machine | User
# Some apps doesn't have Machine and/or User scope (e.g. Valve.Steam only have Machine scope).
# e.g. Install-ApplicationWithWinget -Id 'Valve.Steam'

$CustomAppsToInstall = @{
    Machine = @(
        'Valve.Steam'
        'AppId_2'
        'AppId_3'
    )
    User = @(
        'AppId_1'
        'AppId_2'
    )
    NoScope = @(
        'AppId_1'
        'AppId_2'
    )
}
#$CustomAppsToInstall['Machine'] | Install-ApplicationWithWinget -Scope 'Machine'
#$CustomAppsToInstall['User'] | Install-ApplicationWithWinget -Scope 'User'
#$CustomAppsToInstall['NoScope'] | Install-ApplicationWithWinget

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

    # --- Microsoft DirectX 9 (might be needed for older games)
    #'DirectX9EndUserRuntime'

    # --- Microsoft .NET Windows Desktop Runtime
    #'DotNetDesktopRuntime10'
    #'DotNetDesktopRuntime9'
    #'DotNetDesktopRuntime8'
    #'DotNetDesktopRuntime7'
    #'DotNetDesktopRuntime6'
    #'DotNetDesktopRuntime5'
)
$AppsToInstall | Install-Application

# --- Desktop shortcuts
#Remove-AllDesktopShortcuts

# --- Windows Subsystem For Linux
#Install-WindowsSubsystemForLinux
#Install-WindowsSubsystemForLinux -Distribution 'Debian'
