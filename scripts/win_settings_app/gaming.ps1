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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\gaming"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                                    Gaming
#==============================================================================

Write-Section -Name 'Windows Settings App - Gaming'

#               Xbox Mode
#=======================================

# --- Xbox mode (default: Enabled)
Set-XboxModeSetting -XboxMode 'Disabled'

# --- Show Xbox mode in Task View (default: Enabled)
Set-XboxModeSetting -ShowInTaskView 'Enabled'

# --- Show accessibility control hints in Task View (default: Enabled)
Set-XboxModeSetting -ShowControlHintsInTaskView 'Enabled'

# --- Confirmation prompts (enter/exit Xbox mode) (default: Enabled)
Set-XboxModeSetting -ConfirmationPrompts 'Enabled'

#               Game Bar
#=======================================

# --- Allow your controller to open Game Bar (default: Enabled)
Set-GamingSetting -OpenGameBarWithController 'Disabled'

# --- Use View + Menu as Guide button in apps (default: Enabled)
Set-GamingSetting -UseViewMenuAsGuideButtonInApps 'Disabled'

#               Captures
#=======================================

# --- Record what happened (default: Disabled)
Set-GamingSetting -GameRecording 'Disabled' -GameRecordingGPO 'NotConfigured'

#               Game Mode
#=======================================

# --- Game Mode (default: Enabled)
Set-GamingSetting -GameMode 'Disabled'
