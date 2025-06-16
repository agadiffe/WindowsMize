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

Write-Output -InputObject 'Loading ''System_properties'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\system_properties"


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

#=================================================================================================================
#                                                System Properties
#=================================================================================================================

Write-Section -Name 'System Properties'

#==============================================================================
#                                   Hardware
#==============================================================================

Write-Section -Name 'Hardware' -SubSection

# --- FDevice installation settings (default: Enabled)
#   Choose whether Windows downloads manufacters' apps and custom icons available for your devices.
# GPO: Disabled | NotConfigured
Set-ManufacturerAppsAutoDownload -State 'Disabled' -GPO 'NotConfigured'


#==============================================================================
#                                   Advanced
#==============================================================================
#region advanced

Write-Section -Name 'Advanced' -SubSection

#==========================================================
#                       Performance
#==========================================================

# --- FVisual effects
# Value: ManagedByWindows (default) | BestAppearance | BestPerformance | Custom
# Setting: <VisualEffectsCustomSetting> (see below)

#Set-VisualEffects -Value 'ManagedByWindows'

$VisualEffectsCustomSettings = @{
    'Animate controls and elements inside windows'    = 'Enabled'
    'Animate windows when minimizing and maximizing'  = 'Enabled'
    'Animations in the taskbar'                       = 'Enabled'
    'Enable Peek'                                     = 'Enabled'
    'Fade or slide menus into view'                   = 'Enabled'
    'Fade or slide ToolTips into view'                = 'Enabled'
    'Fade out menu items after clicking'              = 'Enabled'
    'Save taskbar thumbnail previews'                 = 'Disabled'
    'Show shadows under mouse pointer'                = 'Enabled'
    'Show shadows under windows'                      = 'Enabled'
    'Show thumbnails instead of icons'                = 'Enabled'
    'Show translucent selection rectangle'            = 'Enabled'
    'Show window contents while dragging'             = 'Enabled'
    'Slide open combo boxes'                          = 'Enabled'
    'Smooth edges of screen fonts'                    = 'Enabled'
    'Smooth-scroll list boxes'                        = 'Enabled'
    'Use drop shadows for icon labels on the desktop' = 'Enabled'
}
Set-VisualEffects -Value 'Custom' -Setting $VisualEffectsCustomSettings

# --- FAdvanced > Virtual memory
# AllDrivesAutoManaged: Disabled | Enabled (default)
# Drive: drive to config (e.g. 'C:')
# State: CustomSize | SystemManaged | NoPagingFile
# InitialSize/MaximumSize: size in MB

#Set-PagingFileSize -AllDrivesAutoManaged 'Enabled'
Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 512 -MaximumSize 2048
#Set-PagingFileSize -Drive 'X:', 'Y:' -State 'SystemManaged'

# --- FData execution prevention
#   Essential Windows programs and services only (OptIn)
#   All programs and services except those I select (OptOut)
# State: OptIn (default) | OptOut
Set-DataExecutionPrevention -State 'OptIn'

#==========================================================
#                   Startup and recovery
#==========================================================

#            System failure
#=======================================

# --- FWrite an event to the system log (default: Enabled)
Set-SystemFailureSetting -WriteEventToSystemLog 'Enabled'

# --- FAutomatically restart (default: Enabled)
Set-SystemFailureSetting -AutoRestart 'Disabled'

# --- FWrite debugging information
# Requires a minimum paging file size according to the selected setting.
# None | Complete (<YOUR_RAM> MB + 257 MB) | Kernel (800 MB) | Small (1 MB) | Automatic (800 MB) (default) | Active (800 MB)
Set-SystemFailureSetting -WriteDebugInfo 'None'

# --- FOverwrite any existing file (default: Enabled)
Set-SystemFailureSetting -OverwriteExistingDebugFile 'Enabled'

# --- FDisable automatic deletion of memory dumps when disk space is low (default: Disabled)
Set-SystemFailureSetting -AlwaysKeepMemoryDumpOnLowDiskSpace 'Disabled'

#endregion advanced

#==============================================================================
#                              System protection
#==============================================================================
#region sys protection

Write-Section -Name 'System protection' -SubSection

# --- FProtection settings
# Also controlled by the group 'Services & Scheduled Tasks > WindowsBackupAndSystemRestore' in the
# file 'scripts\services_and_scheduled_tasks.ps1'. The services are left to default state 'Manual'.

# AllDrivesDisabled: turn off System Restore
# Drive: drive to config (e.g. 'C:')
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured

Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
#Set-SystemRestore -Drive $env:SystemDrive -State 'Enabled'

#endregion sys protection

#==============================================================================
#                                    Remote
#==============================================================================
#region remote

Write-Section -Name 'Remote' -SubSection

# --- FRemote assistance
#   Allow remote assistance connections to this computer (ViewOnly)
#   Allow this computer to be controlled remotely (FullControl)
# State: Disabled | FullControl | ViewOnly (default) # GPO: State + NotConfigured
Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured'

# Advanced settings
#  InvitationMaxTime     : number (range 1-99), default: 6
#  InvitationMaxTimeUnit : Minutes | Hours (default) | Days
#  EncryptedOnly         : Disabled (Windows default) | Enabled (script default)
#  EncryptedOnlyGPO      : Disabled | Enabled | NotConfigured (default)
#  InvitationMethodGPO   : SimpleMAPI (default) | Mailto
$RemoteAssistanceProperties = @{
    State                 = 'ViewOnly'
    GPO                   = 'NotConfigured'
    InvitationMaxTime     = 6
    InvitationMaxTimeUnit = 'Hours'
    EncryptedOnly         = 'Enabled'
    EncryptedOnlyGPO      = 'NotConfigured'
    InvitationMethodGPO   = 'SimpleMAPI' # ignored if 'GPO' is 'NotConfigured'
}
#Set-RemoteAssistance @RemoteAssistanceProperties

# --- FRemote Desktop
# See 'Windows Settings App > System > Remote Desktop'

#endregion remote


Stop-Transcript
