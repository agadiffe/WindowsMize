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


#=================================================================================================================
#                                                     Scripts
#=================================================================================================================

# Uncomment or comment the script you want to execute or not.
$ScriptsToExecute = @(
    'tweaks'
    'telemetry'
    'network'
    'power_options'
    'system_properties'
    'file_explorer'
    'apps_management'
    'apps_settings'
    #'ramdisk'
    'win_settings_app\system'
    'win_settings_app\bluetooth_&_devices'
    'win_settings_app\network_&_internet'
    'win_settings_app\personnalization'
    'win_settings_app\apps'
    'win_settings_app\accounts'
    'win_settings_app\time_&_language'
    'win_settings_app\gaming'
    'win_settings_app\accessibility'
    'win_settings_app\privacy_&_security'
    'win_settings_app\defender_security_center'
    'win_settings_app\windows_update'
    'services_and_scheduled_tasks'
)
$ScriptsToExecute.ForEach({ & "$PSScriptRoot\scripts\$_.ps1" })
