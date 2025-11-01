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
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

Write-Section -Name 'Applications Settings'

#==============================================================================
#                                Microsoft Edge
#==============================================================================
#region edge

Write-Section -Name 'Microsoft Edge' -SubSection

# Basic settings if you don't use Edge and didn't removed it.
# Prevent Edge to run all the time in the background.

# GPO: Disabled | Enabled | NotConfigured

# --- Prelaunch at startup
Set-MicrosoftEdgePolicy -Prelaunch 'Disabled'

# --- Startup boost
Set-MicrosoftEdgePolicy -StartupBoost 'Disabled'

# --- Continue running background extensions and apps when Microsoft Edge is closed
Set-MicrosoftEdgePolicy -BackgroundMode 'Disabled'

#endregion edge

#==============================================================================
#                               Microsoft Store
#==============================================================================
#region ms store

Write-Section -Name 'Microsoft Store' -SubSection

# --- App updates (default: Enabled)
Set-MicrosoftStoreSetting -AutoAppUpdates 'Enabled' -AutoAppUpdatesGPO 'NotConfigured'

# --- Notifications for app installations (default: Enabled)
Set-MicrosoftStoreSetting -AppInstallNotifications 'Enabled'

# --- Video autoplay (default: Enabled)
Set-MicrosoftStoreSetting -VideoAutoplay 'Disabled'

# --- Personalized experiences (default: Enabled)
Set-MicrosoftStoreSetting -PersonalizedExperiences 'Disabled'

#endregion ms store
