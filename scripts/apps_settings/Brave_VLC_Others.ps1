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
Write-Output -InputObject 'Loading ''Applications\Settings'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\applications\settings"


#=================================================================================================================
#                                            Applications Config Files
#=================================================================================================================

Write-Section -Name 'Applications Config Files'

#==============================================================================
#                                Brave Browser
#==============================================================================

Write-Section -Name 'Brave Browser' -SubSection

<#
  For now, to customize the settings, open the file:
    src > modules > applications > settings > private > New-BraveBrowserConfigData.ps1
  The settings are organized in the same way as in the GUI.

  Meant to be used on a fresh Brave installation.

  If used on current install, it will override the current settings.
  Including your profiles if you have more than one (the data folder will not be deleted).
  It means that you will have only 1 profile after applying this function.

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
    'KeePassXC'
    'qBittorrent'
    'VLC'
    #'VSCode'
    #'Git'
)
$AppsToConfig.ForEach({ Write-Section -Name $_ -SubSection ; Set-MyAppsSetting -Name $_ })


Stop-Transcript
