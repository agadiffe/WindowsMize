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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\helper_functions\general"

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$(Get-LogPath -User)\win_settings_app_$ScriptFileName.log"

Write-Output -InputObject 'Loading ''Win_settings_app\Gaming'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\gaming"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                    Gaming
#==============================================================================

Write-Section -Name 'Windows Settings App - Gaming'

# --- Allow your controller to open Game Bar (default: Disabled)
Set-GamingSetting -OpenGameBarWithController 'Disabled'

# --- Captures: Record what happened (default: Disabled)
# GPO: Disabled | NotConfigured
Set-GamingSetting -GameRecording 'Disabled' -GameRecordingGPO 'NotConfigured'

# --- Game Mode (default: Enabled)
Set-GamingSetting -GameMode 'Disabled'


Stop-Transcript
