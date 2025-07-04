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

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\log\$ScriptFileName.log"

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)

Write-Output -InputObject 'Loading ''Power_options'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\power_options"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

#=================================================================================================================
#                                                  Power Options
#=================================================================================================================

Write-Section -Name 'Power Options'

# --- Fast startup (default: Enabled)
Set-FastStartup -State 'Disabled'

# --- Hibernate (default: Enabled)
# Disabled: also disable 'Fast startup'
Set-Hibernate -State 'Disabled'

# --- Turn off hard disk after idle time (default: 20 (PluggedIn), 10 (OnBattery))
# PowerSource: PluggedIn | OnBattery
# Timeout: value in minutes
Set-HardDiskTimeout -PowerSource 'OnBattery' -Timeout 20
Set-HardDiskTimeout -PowerSource 'PluggedIn' -Timeout 60

# --- Modern standby (S0) : Network connectivity (default: Enabled)
# PowerSource: PluggedIn | OnBattery
# State: Disabled | Enabled | ManagedByWindows
Set-ModernStandbyNetworkConnectivity -PowerSource 'OnBattery' -State 'Disabled'
Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'

# --- Battery settings (default: Low 10%, DoNothing | Reserve 7% | Critical 5%, Hibernate)
# Battery: Low | Critical | Reserve
# Level: value in percent (range: 5-100)
# Action: DoNothing | Sleep | Hibernate | ShutDown

Set-AdvancedBatterySetting -Battery 'Low'      -Level 15 -Action 'DoNothing'
Set-AdvancedBatterySetting -Battery 'Reserve'  -Level 10
Set-AdvancedBatterySetting -Battery 'Critical' -Level 7  -Action 'Hibernate'


Stop-Transcript
