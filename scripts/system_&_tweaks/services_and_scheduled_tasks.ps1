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

$WindowsMizeModuleNames = @( 'services', 'scheduled_tasks' )
Import-Module -Name $WindowsMizeModuleNames.ForEach({ "$PSScriptRoot\..\..\src\modules\$_" })


#=================================================================================================================
#                                           Services & Scheduled Tasks
#=================================================================================================================

Write-Section -Name 'Services & Scheduled Tasks'

#==============================================================================
#                                   Services
#==============================================================================

Write-Section -Name 'Services' -SubSection

Export-DefaultServicesStartupType
Export-DefaultSystemDriversStartupType

<#
  You can review the services StartupType in "src\modules\services\private".

  Make sure to review every services and configure them according to your usages.
  (especially Features.ps1 and Miscellaneous.ps1 which contains unrelated services in the same group)

  If you want to let the default setting, comment the services group below (e.g. #'FileAndPrinterSharing').

  ThirdParty services (e.g. AdobeAcrobat, Intel, Nvidia):
    Will be set back to 'DefaultType' on each app update.
    Need to be reapplied (or automated) if desired.

  To use a printer occasionally, you only need these two services: 'Print Spooler' and 'SSDP Discovery'.
  If disabled as part of this script, launch them manually with services.msc when needed.
#>

# Minimum recommended:
#   'Deprecated'
#   'RemoteDesktop'
#   'Telemetry'

$ServicesToConfig = @(
    # --- SystemDriver
    'UserChoiceProtectionDriver'
    #'OfflineFilesDriver'
    #'NetworkDataUsageDriver'

    # --- Windows
    'Features'      # adjust to your needs: Features.ps1 (21 Svcs) (e.g. SysMain (disabled)).
    'Miscellaneous' # adjust to your needs: Miscellaneous.ps1 : everything should be ok (61 Svcs).

    #'Autoplay'
    #'Bluetooth'
    #'BluetoothAndCast'
    #'BluetoothAudio'
    'DefenderPhishingProtection' # do not disable if you use Edge with 'Phishing Protection' enabled.
    'Deprecated'
    'DiagnosticAndUsage'
    #'FileAndPrinterSharing' # needed by NetworkDiscovery (File Explorer > Network).
    'HyperV'
    #'MicrosoftOffice'
    'MicrosoftStore' # only 'PushToInstall service' is disabled. all others are left to default state 'Manual'.
    'Network'
    #'NetworkDiscovery' # needed by printer and FileAndPrinterSharing.
    'Printer'
    'RemoteDesktop'
    #'Sensor' # screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in).
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    'Vpn' # only needed if using the built-in Windows VPN feature (i.e. not needed if using 3rd party VPN client).
    #'Webcam' # only needed by MS Store apps. e.g. Microsoft Teams, Skype, or Camera app.
    'WindowsBackupAndSystemRestore' # also used by new PITR feature.
    'WindowsSearch'
    #'WindowsSubsystemForLinux'
    'Xbox'

    # --- ThirdParty
    #'AdobeAcrobat'
    'Intel'
    #'Nvidia'
)
$ServicesToConfig | Set-ServiceStartupTypeGroup

# The backup file used in this function is: log\windows_default_services_winmize.json
# The script must have been executed at least once.
# FilePath: use another compatible file.
#Restore-ServiceStartupTypeFromBackup
#Restore-ServiceStartupTypeFromBackup -FilePath 'X:\Backup\windows_services_default.json'

#==============================================================================
#                               Scheduled Tasks
#==============================================================================

Write-Section -Name 'Scheduled Tasks' -SubSection

Export-DefaultScheduledTasksState

<#
  You can review which tasks are disabled in "src\modules\scheduled_tasks\private".
  Everything should be ok/harmless

  If you use a specific feature, do not disable the related task.
    Add 'SkipTask = $true' to use the default setting.
    Use 'SkipTask = $false' (or delete the key) and change 'Disabled' to 'Enabled' to enable the task.
    e.g. in Features.ps1
    @{
        SkipTask = $true
        TaskPath = '\Microsoft\Windows\SystemRestore\'
        Task     = @{
            SR = 'Disabled'
        }
    }
#>

$TasksToConfig = @(
    #'AdobeAcrobat'
    'Diagnostic'
    'Features'
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'UserChoiceProtectionDriver'
)
$TasksToConfig | Set-ScheduledTaskStateGroup

# The backup file used in this function is: log\windows_default_scheduled_tasks_winmize.json
# The script must have been executed at least once.
# FilePath: use another compatible file.
#Restore-ScheduledTaskStateFromBackup
#Restore-ScheduledTaskStateFromBackup -FilePath 'X:\Backup\windows_scheduled_tasks_default.json'
