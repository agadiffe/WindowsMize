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
Write-Output -InputObject 'Loading ''Applications\Settings'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\applications\settings"


# Parameters values (if not specified):
#   State: Disabled | Enabled

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

Write-Section -Name 'Applications Settings'

#==============================================================================
#                               Windows Terminal
#==============================================================================
Write-Section -Name 'Windows Terminal' -SubSection

#==========================================================
#                         Startup
#==========================================================

# --- Default profile
# State: WindowsPowerShell (default) | CommandPrompt | PowerShellCore
Set-WindowsTerminalSetting -DefaultProfile 'PowerShellCore'

# --- Default terminal application
# e.g. command-line from Start Menu or Run dialog
# State: LetWindowsDecide | WindowsConsoleHost (default) | WindowsTerminal
Set-WindowsTerminalSetting -DefaultCommandTerminalApp 'WindowsTerminal'

# --- Launch on machine startup (default: Disabled)
Set-WindowsTerminalSetting -RunAtStartup 'Disabled'

#==========================================================
#                         Defaults
#==========================================================

#              Appearance
#=======================================

# --- Color scheme
# State: CGA | Campbell (default) | Campbell Powershell | Dark+ | IBM 5153 | One Half Dark | One Half Light |
#        Ottosson | Solarized Dark | Solarized Light | Tango Dark | Tango Light | Vintage
Set-WindowsTerminalSetting -DefaultColorScheme 'One Half Dark'

#               Advanced
#=======================================

# --- History size
# default: 9001 | max: 32767 (even if higher value provided)
Set-WindowsTerminalSetting -DefaultHistorySize 32767
