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

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\log\$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Power_options'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\power_options"



#=================================================================================================================
#                                                  Power Options
#=================================================================================================================

Write-Section -Name 'Power Options'

# Fast startup
#---------------------------------------
# Disabled | Enabled (default)
Set-FastStartup -State 'Disabled'

# Hibernate
#---------------------------------------
# Disabled (also disable 'Fast startup') | Enabled (default)
Set-Hibernate -State 'Disabled'

# Turn off hard disk after idle time
#---------------------------------------
# default: 20 (PluggedIn), 10 (OnBattery)
# PowerSource: PluggedIn | OnBattery
# Timeout: value in minutes
Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60

# Modern standby (S0) : Network connectivity
#---------------------------------------
# PowerSource: PluggedIn | OnBattery
# State: Disabled | Enabled (default) | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

# Battery settings
#---------------------------------------
# default (depends): Low 10%, DoNothing | Reserve 7% | Critical 5%, Hibernate
# Battery: Low | Critical | Reserve
# Level: value in percent (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown
Set-AdvancedBatterySetting -Battery 'Low'      -Level 15 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 10
Set-AdvancedBatterySetting -Battery 'Critical' -Level 7  -Action 'ShutDown'


Stop-Transcript
