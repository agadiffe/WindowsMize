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

[CmdletBinding()]
param
(
    [string] $User
)

if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
{
    Write-Error 'The script cannot be run: LanguageMode is set to ConstrainedLanguage.'
    exit
}

$Global:ProvidedUserName = $User
$Global:ModuleVerbosePreference = 'Continue'
$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename

Import-Module -Name "$PSScriptRoot\src\modules\helper_functions\general"
Start-Transcript -Path "$(Get-LogPath -User)\$ScriptFileName-$(Get-Date -Format 'yyyy-MM-ddTHH-mm-ss').log"


#=================================================================================================================
#                                                     Scripts
#=================================================================================================================

# Uncomment or comment the script you want to execute or not.
$ScriptsToExecute = @(
    # --- Apps Management
    'apps_management\debloat'
    'apps_management\install'

    # --- Apps Settings
    #'apps_settings\Acrobat_Reader'
    'apps_settings\Brave_VLC_Others'
    #'apps_settings\MS_Office'
    'apps_settings\MS_Store_&_Edge'
    'apps_settings\Notepad_Photos_SnippingTool'
    'apps_settings\Terminal'

    # --- Network & Internet
    'network_&_internet\network_&_internet'
    'network_&_internet\firewall'
    'network_&_internet\protocol'

    # --- System & Tweaks
    'system_&_tweaks\file_explorer'
    'system_&_tweaks\power_&_battery'
    'system_&_tweaks\system_properties'
    'system_&_tweaks\services_and_scheduled_tasks'
    #'system_&_tweaks\ramdisk'
    'system_&_tweaks\tweaks'

    # --- Telemetry & Annoyances
    'telemetry_&_annoyances\telemetry'
    'telemetry_&_annoyances\defender_security_center'
    'telemetry_&_annoyances\privacy_&_security'
    'telemetry_&_annoyances\notifications'
    'telemetry_&_annoyances\start_&_taskbar'

    # --- Win Settings App
    'win_settings_app\system'
    'win_settings_app\bluetooth_&_devices'
    'win_settings_app\personnalization'
    'win_settings_app\apps'
    'win_settings_app\accounts'
    'win_settings_app\time_&_language'
    'win_settings_app\gaming'
    'win_settings_app\accessibility'
    'win_settings_app\windows_update'
)
$ScriptsToExecute.ForEach({ & "$PSScriptRoot\scripts\$_.ps1" })

Stop-Transcript
