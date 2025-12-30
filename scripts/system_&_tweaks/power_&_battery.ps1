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

$WindowsMizeModuleNames = @( 'power_options', 'settings_app\system' )
Import-Module -Name $WindowsMizeModuleNames.ForEach({ "$PSScriptRoot\..\..\src\modules\$_" })


# Parameters values (if not specified):
#   State: Disabled | Enabled

#=================================================================================================================
#                                                 Power & Battery
#=================================================================================================================
#region control panel

Write-Section -Name 'Power & Battery (Control Panel)'

# --- Fast startup (default: Enabled)
Set-FastStartup -State 'Disabled'

# --- Hibernate (default: Enabled)
# Disabled: also disable 'Fast startup'
Set-Hibernate -State 'Disabled'

# --- Turn off hard disk after idle time
# PowerSource: PluggedIn (default: 20) | OnBattery (default: 10)
# Timeout: value in minutes
Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60

# --- Modern standby (S0) : Network connectivity
# PowerSource: PluggedIn | OnBattery
# State: Disabled | Enabled (default) | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

# --- Battery settings
# default: Low 10%, DoNothing | Reserve 7% | Critical 5%, Hibernate
# Battery: Low | Critical | Reserve
# Level: value in percent (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown

Set-AdvancedBatterySetting -Battery 'Low'      -Level 19 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 12
Set-AdvancedBatterySetting -Battery 'Critical' -Level 9  -Action 'Sleep'

#endregion control panel


#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================
#region settings app

#==============================================================================
#                                    System
#==============================================================================

Write-Section -Name 'Windows Settings App - System'

#==========================================================
#                    Power (& battery)
#==========================================================

Write-Section -Name 'Power (& battery)' -SubSection

# --- Power Mode
# Available only when using the Balanced power plan.
# Applies only to the active power state (e.g. Laptop: PluggedIn or OnBattery).
# State: BestPowerEfficiency | Balanced (default) | BestPerformance
Set-PowerSetting -PowerMode 'Balanced'

# --- Battery percentage (default: Disabled)
Set-PowerSetting -BatteryPercentage 'Disabled'

# Screen, sleep, & hibernate timeouts
#=======================================

# --- Turn my screen off after
# --- Make my device sleep after
# --- Make my device hibernate after
# PowerSource: PluggedIn | OnBattery
# PowerState: Screen | Sleep | Hibernate
# Timeout: value in minutes | never: 0

Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Sleep'     -Timeout 10
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Hibernate' -Timeout 60

Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Screen'    -Timeout 3
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Sleep'     -Timeout 5
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Hibernate' -Timeout 30

#             Energy saver
#=======================================

# --- Always use energy saver (default: Disabled)
Set-EnergySaverSetting -AlwaysOn 'Disabled'

# --- Turn energy saver on automatically when battery level is at
# default: 30 | never: 0 | always: 100
Set-EnergySaverSetting -TurnOnAtBatteryLevel 30

# --- Lower screen brightness when using energy saver
# If you use a custom value and turn off the feature in the GUI,
# when you turn it back on, the default value will be used.
# Enabled: 70 (default) (range 0-99) | Disabled: 100
Set-EnergySaverSetting -LowerBrightness 70

#  Lid, power & sleep button controls
#=======================================

# --- Pressing the power button will make my PC
# --- Pressing the sleep button will make my PC
# --- Closing the lid will make my PC
# PowerSource: PluggedIn | OnBattery
# ButtonControls: PowerButton | SleepButton | LidClose
# Action: DoNothing | Sleep (default) | Hibernate | ShutDown | DisplayOff

Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'PluggedIn' -ButtonControls 'LidClose'    -Action 'Sleep'

Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'PowerButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'SleepButton' -Action 'Sleep'
Set-PowerSetting -PowerSource 'OnBattery' -ButtonControls 'LidClose'    -Action 'Sleep'

#endregion settings app
