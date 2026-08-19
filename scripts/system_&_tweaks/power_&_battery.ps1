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
#   GPO:   Disabled | NotConfigured (default)

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
#   Note (Action): 'Reserve' battery does not support 'Action'.
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
# TimeoutMins: value in minutes (never: 0)
# TimeoutMinsGPO: value in minutes (never: 0) | NotConfigured
# GUI values: 1 2 3 5 10 15 20 25 30 45 minute(s), 1 2 3 4 5 hour(s), Never

Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Screen'    -TimeoutMins 3  -TimeoutMinsGPO 'NotConfigured'
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Sleep'     -TimeoutMins 10 -TimeoutMinsGPO 'NotConfigured'
Set-PowerSetting -PowerSource 'PluggedIn' -PowerState 'Hibernate' -TimeoutMins 60 -TimeoutMinsGPO 'NotConfigured'

Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Screen'    -TimeoutMins 3  -TimeoutMinsGPO 'NotConfigured'
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Sleep'     -TimeoutMins 5  -TimeoutMinsGPO 'NotConfigured'
Set-PowerSetting -PowerSource 'OnBattery' -PowerState 'Hibernate' -TimeoutMins 30 -TimeoutMinsGPO 'NotConfigured'

#             Energy saver
#=======================================

# --- Always use energy saver (default: Disabled)
# GPO: Enabled | NotConfigured
Set-EnergySaverSetting -AlwaysOn 'Disabled' -AlwaysOnGPO 'NotConfigured'

# --- Turn energy saver on automatically when battery level is at
# State: value in percentage (range: 0-100) (default: 30 | never: 0 | on battery: 100)
# GPO: value in percentage (range: 0-100) (never: 0 | on battery: 100) | NotConfigured
# GUI values: Never | 10% | 20% | 30% | 40% | 50% | On 
# The GUI will show 'Never' if you choose another value than the predefined ones, but it will work as intended.
Set-EnergySaverSetting -TurnOnAtBatteryLevel 30 -TurnOnAtBatteryLevelGPO 'NotConfigured'

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
#   Note (Action): 'LidClose' does not support 'DisplayOff'.
# ActionGPO: DoNothing | Sleep | Hibernate | ShutDown | NotConfigured

Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'PowerButton' -Action 'Sleep' -ActionGPO 'NotConfigured'
Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'SleepButton' -Action 'Sleep' -ActionGPO 'NotConfigured'
Set-DevicePhysicalControlAction -PowerSource 'PluggedIn' -Control 'LidClose'    -Action 'Sleep' -ActionGPO 'NotConfigured'

Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'PowerButton' -Action 'Sleep' -ActionGPO 'NotConfigured'
Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'SleepButton' -Action 'Sleep' -ActionGPO 'NotConfigured'
Set-DevicePhysicalControlAction -PowerSource 'OnBattery' -Control 'LidClose'    -Action 'Sleep' -ActionGPO 'NotConfigured'

#endregion settings app
