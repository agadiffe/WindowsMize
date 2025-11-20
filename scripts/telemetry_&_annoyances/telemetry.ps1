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
Write-Output -InputObject 'Loading ''Telemetry'' Module ...'
Import-Module -Name "$PSScriptRoot\..\..\src\modules\telemetry"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                                    Telemetry
#=================================================================================================================

Write-Section -Name 'Telemetry'

#==============================================================================
#                                Miscellaneous
#==============================================================================

# --- .Net
Disable-DotNetTelemetry

# --- Nvidia
Disable-NvidiaTelemetry

# --- PowerShell
Disable-PowerShellTelemetry

# --- Diagnostic auto-logger (system boot log) (default: Enabled)
Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'

# --- Diagnostic tracing
# Protected key. Need to be changed manually.
# See "src\modules\telemetry\private\Set-DiagnosticTracing.ps1".
#Set-DiagnosticTracing -State 'Disabled'

#==============================================================================
#                                 Group Policy
#==============================================================================

# --- App and device inventory
# Windows 11 24H2+ only.
Set-AppAndDeviceInventory -GPO 'Disabled'

# --- Application compatibility
Set-ApplicationCompatibility -GPO 'Disabled'

# --- Cloud content experiences
# Disabled: also disable Windows Spotlight
Set-CloudContent -GPO 'NotConfigured'

# --- Consumer experiences
# Disabled: also disable and gray out: 'settings > bluetooth & devices > mobile devices'
Set-ConsumerExperience -GPO 'NotConfigured'

# --- Customer Experience Improvement Program (CEIP)
# GPO: Disabled | Enabled | NotConfigured
Set-Ceip -GPO 'Disabled'

# --- Diagnostic log and dump collection limit
Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'

# --- Error reporting
Set-ErrorReporting -GPO 'Disabled'

# --- Group policy settings logging
Set-GroupPolicySettingsLogging -GPO 'Disabled'

# --- Handwriting personalization
Set-HandwritingPersonalization -GPO 'Disabled'

# --- KMS client activation data
Set-KmsClientActivationDataSharing -GPO 'Disabled'

# --- Microsoft Windows Malicious Software Removal Tool (MSRT) : Heartbeat report
Set-MsrtDiagnosticReport -GPO 'Disabled'

# --- OneSettings downloads
Set-OneSettingsDownloads -GPO 'Disabled'

# --- User info sharing
# GPO: Disabled | Enabled | NotConfigured
Set-UserInfoSharing -GPO 'Disabled'
