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

$WindowsMizeModuleNames = 'power_options', 'settings_app\system'
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
# TimeoutMins: value in minutes
Set-HardDiskTimeout -PowerSource 'OnBattery' -TimeoutMins 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -TimeoutMins 60

# --- Modern standby (S0) : Network connectivity
# PowerSource: PluggedIn | OnBattery
# State: Disabled | Enabled (default) | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

# --- Battery settings
# default: Low 10%, DoNothing | Reserve 7% | Critical 5%, Hibernate
# Battery: Low | Critical | Reserve
# Percent: value in percentage (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown
# Note: 'Reserve' battery does not support 'Action'.
Set-AdvancedBatterySetting -Battery 'Low'      -Percent 19 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Percent 12
Set-AdvancedBatterySetting -Battery 'Critical' -Percent 9  -Action 'Sleep'

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
# Available only when using the default Balanced power plan.
# PowerMode: BestPowerEfficiency | Balanced | BestPerformance
# PowerSource (optional): PluggedIn | OnBattery
Set-PowerSetting -PowerMode 'Balanced'
#Set-PowerSetting -PowerSource 'PluggedIn' -PowerMode 'Balanced'
#Set-PowerSetting -PowerSource 'OnBattery' -PowerMode 'BestPowerEfficiency'

# --- Battery percentage (default: Disabled)
Set-PowerSetting -BatteryPercentage 'Disabled'

# Screen, sleep, & hibernate timeouts
#=======================================

# --- Turn my screen off after
# --- Make my device sleep after
# --- Make my device hibernate after
# PowerSource: PluggedIn | OnBattery
# PowerState: Screen | Sleep | Hibernate
# TimeoutMins: value in minutes | never: 0

Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Screen'    -TimeoutMins 3
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Sleep'     -TimeoutMins 10
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Hibernate' -TimeoutMins 60

Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Screen'    -TimeoutMins 3
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Sleep'     -TimeoutMins 5
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Hibernate' -TimeoutMins 30

#             Energy saver
#=======================================

# --- Always use energy saver (default: Disabled)
Set-EnergySaverSetting -AlwaysOn 'Disabled'

# --- Turn energy saver on automatically when battery level is at
# range: 0-100 / default: 30 | never: 0 | always: 100
Set-EnergySaverSetting -TurnOnAtBatteryLevel 30

# --- Lower screen brightness when using energy saver (default: Enabled)
Set-EnergySaverSetting -LowerScreenBrightness 'Enabled'

# --- Lower keyboard brightness when using energy saver (default: Enabled)
Set-EnergySaverSetting -LowerKeyboardBrightness 'Enabled'

#  Lid, power & sleep button controls
#=======================================

# --- Pressing the power button will make my PC
# --- Pressing the sleep button will make my PC
# --- Closing the lid will make my PC
# PowerSource: PluggedIn | OnBattery
# Control: PowerButton | SleepButton | LidClose
# Action: DoNothing | Sleep (default) | Hibernate | ShutDown | DisplayOff
# Note: 'LidClose' does not support 'DisplayOff'.

Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'PowerButton' -Action 'Sleep'
Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'SleepButton' -Action 'Sleep'
Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'LidClose'    -Action 'Sleep'

Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'PowerButton' -Action 'Sleep'
Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'SleepButton' -Action 'Sleep'
Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'LidClose'    -Action 'Sleep'

#endregion settings app
