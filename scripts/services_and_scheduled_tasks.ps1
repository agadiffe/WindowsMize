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

Write-Output -InputObject 'Loading ''Services and Scheduled_tasks'' Modules ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

$WindowsMizeModulesNames = @(
    'services'
    'scheduled_tasks'
)
Import-Module -Name $WindowsMizeModulesNames.ForEach({ "$PSScriptRoot\..\src\modules\$_" })



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
  You can review the services StartupType in: src > modules > services > private.

  Make sure to review every services and configure them according to your usages.
  (especially Features.ps1 and Miscellaneous.ps1 which contains unrelated services in the same group)

  If you want to let the default setting, comment the services group below (e.g. #'FileAndPrinterSharing').

  ThirdParty services (e.g. AdobeAcrobat, Intel, Nvidia):
    Will be set back to 'DefaultType' on each app update.
    Need to be reapplied (or automated) if desired.

  To use a printer occasionally, you only need these two services: 'Print Spooler' and 'SSDP Discovery'.
  If disabled as part of this script, launch them manually with services.msc when needed.
#>

$ServicesToConfig = @(
    # SystemDriver
    #-----------------
    'UserChoiceProtectionDriver'
    #'OfflineFilesDriver'
    #'NetworkDataUsageDriver'

    # Windows
    #-----------------
    #'Autoplay'
    #'Bluetooth'
    #'BluetoothAndCast'
    #'BluetoothAudio'
    'DefenderPhishingProtection'
    'Deprecated'
    'DiagnosticAndUsage'
    'Features'
    'FileAndPrinterSharing'
    'HyperV'
    #'MicrosoftEdge'
    #'MicrosoftOffice'
    'MicrosoftStore'
    'Miscellaneous'
    'Network'
    #'NetworkDiscovery'
    'Printer'
    'RemoteDesktop'
    'Sensor'
    'SmartCard'
    'Telemetry'
    'VirtualReality'
    #'Vpn'
    #'Webcam'
    'WindowsBackupAndSystemRestore'
    'WindowsSearch'
    'WindowsSubsystemForLinux'
    'Xbox'

    # ThirdParty
    #-----------------
    #'AdobeAcrobat'
    'Intel'
    #'Nvidia'
)
$ServicesToConfig | Set-ServiceStartupTypeGroup


#==============================================================================
#                               Scheduled Tasks
#==============================================================================

Write-Section -Name 'Scheduled Tasks' -SubSection

Export-DefaultScheduledTasksState

<#
  You can review which tasks are disabled in: src > modules > scheduled_tasks > private.

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
    'Features'
    #'MicrosoftEdge'
    #'MicrosoftOffice'
    'Miscellaneous'
    'Telemetry'
    'TelemetryDiagnostic'
    'UserChoiceProtectionDriver'
)
$TasksToConfig | Set-ScheduledTaskStateGroup


Stop-Transcript
