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

<#
- These 2 below steps are automated if you use Run_WindowsMize.bat.
  - PowerShell 7 (aka PowerShell Core).
    Open a terminal and run:
      winget install --exact --id 'Microsoft.PowerShell' --accept-source-agreements --accept-package-agreements
  - Before running the script, sets the PowerShell execution policies:
      Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process' -Force

- Update
  Make sure your Windows is fully updated:
    settings > windows update > check for updates
    microsoft store > library (or downloads) > get updates

- Backup
  Make sure to backup all of your data.
  e.g. browser bookmarks, apps settings, personal files, passwords database
#>


#==============================================================================
#                                    Usage
#==============================================================================

<#
  The scripts are located in the 'scripts' folder.
  Configure their settings according to your preferences.

  To don't run a function, comment it (i.e. Add the "#" character before it).
  e.g. #Disable-PowerShellTelemetry
  To run a function, uncomment it (i.e. Remove the "#" character before it).
  e.g. Disable-PowerShellTelemetry

  Mostly all functions have a '-State' and/or '-GPO' parameters.
  Example:
  # Bing Search in Start Menu
  #---------------------------------------
  # State: Disabled | Enabled (default)
  # GPO: Disabled | NotConfigured
  Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'

  The 2 comments below the title are the accepted values for the parameters.
  Change the parameters value according to your preferences.
  e.g.
  Set-StartMenuBingSearch -State 'Enabled' -GPO 'NotConfigured'
#>



#=================================================================================================================
#                                                     Scripts
#=================================================================================================================

# Comment or uncomment the script you want to execute.
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

foreach ($Name in $ScriptsToExecute)
{
    & "$PSScriptRoot\scripts\$Name.ps1"
}
