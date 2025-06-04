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
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Win_settings_app\Gaming'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\gaming"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                    Gaming
#==============================================================================

Write-Section -Name 'Windows Settings App - Gaming'

#==========================================================
#                         Game Bar
#==========================================================
#region game bar

Write-Section -Name 'Game Bar' -SubSection

# Allow your controller to open Game Bar
#---------------------------------------
# Disabled (default) | Enabled
Set-GamingSetting -OpenGameBarWithController 'Disabled'

#endregion game bar


#==========================================================
#                         Captures
#==========================================================
#region captures

Write-Section -Name 'Captures' -SubSection

# Record what happened
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-GamingSetting -GameRecording 'Disabled' -GameRecordingGPO 'NotConfigured'

#endregion captures


#==========================================================
#                        Game Mode
#==========================================================
#region game mode

Write-Section -Name 'Game Mode' -SubSection

# Game Mode
#---------------------------------------
# Disabled | Enabled (default)
Set-GamingSetting -GameMode 'Disabled'

#endregion game mode


Stop-Transcript
