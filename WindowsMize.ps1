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

if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
{
    Write-Error 'The script cannot be run: LanguageMode is set to ConstrainedLanguage.'
    exit
}

Import-Module -Name "$PSScriptRoot\..\..\src\modules\helper_functions\general"
$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\$ScriptFileName.log"


#=================================================================================================================
#                                                     Scripts
#=================================================================================================================

# Uncomment or comment the script you want to execute or not.
$ScriptsToExecute = @(
    'apps_management\debloat'
    'apps_management\install'

    #'apps_settings\Acrobat_Reader'
    'apps_settings\Brave_VLC_Others'
    #'apps_settings\MS_Office'
    'apps_settings\MS_Store_&_Edge'
    'apps_settings\Notepad_Photos_SnippingTool'
    'apps_settings\Terminal'

    'network\network_&_internet'
    'network\firewall'
    'network\protocol'

    'file_explorer'
    'power_&_battery'
    'system_properties'
    'services_and_scheduled_tasks'
    #'ramdisk'

    'tweaks'
    'telemetry'
    'win_settings_app\defender_security_center'
    'win_settings_app\privacy_&_security'
    'win_settings_app\notifications'
    'win_settings_app\start_&_taskbar'

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
