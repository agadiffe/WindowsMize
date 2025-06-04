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

Write-Output -InputObject 'Loading ''Telemetry'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\telemetry"



#=================================================================================================================
#                                                    Telemetry
#=================================================================================================================

# The main telemetry configurations are in the Windows settings app.  
# See 'scripts > win_settings_app > privacy_&_security.ps1'.

Write-Section -Name 'Telemetry'

# .Net
#---------------------------------------
Disable-DotNetTelemetry

# Nvidia
#---------------------------------------
Disable-NvidiaTelemetry

# PowerShell
#---------------------------------------
Disable-PowerShellTelemetry

# App and device inventory
#---------------------------------------
# Windows 11 24H2+ only.
# Disabled | NotConfigured
Set-AppAndDeviceInventory -GPO 'Disabled'

# Application compatibility
#---------------------------------------
# Disabled | NotConfigured
Set-ApplicationCompatibility -GPO 'Disabled'

# Cloud content experiences
#---------------------------------------
# Disabled: also disable Windows Spotlight
# Disabled | NotConfigured
Set-CloudContent -GPO 'NotConfigured'

# Consumer experiences
#---------------------------------------
# Disabled: also disable and gray out: 'settings > bluetooth & devices > mobile devices'
# Disabled | NotConfigured
Set-ConsumerExperience -GPO 'NotConfigured'

# Customer Experience Improvement Program (CEIP)
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-Ceip -GPO 'Disabled'

# Diagnostic log and dump collection limit
#---------------------------------------
# Disabled | NotConfigured
Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'

# Diagnostic auto-logger (system boot log)
#---------------------------------------
# Name: DiagTrack-Listener
# State: Disabled | Enabled (default)
Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'

# Diagnostic tracing
#---------------------------------------
# Protected key. Need to be changed manually.
# See 'Set-DiagnosticTracing.ps1' in 'src > modules > telemetry > private'.

# Error reporting
#---------------------------------------
# Disabled | NotConfigured
Set-ErrorReporting -GPO 'Disabled'

# Group policy settings logging
#---------------------------------------
# Disabled | NotConfigured
Set-GroupPolicySettingsLogging -GPO 'Disabled'

# Handwriting personalization
#---------------------------------------
# Disabled | NotConfigured
Set-HandwritingPersonalization -GPO 'Disabled'

# Inventory collector
#---------------------------------------
# Disabled | NotConfigured
Set-InventoryCollector -GPO 'Disabled'

# KMS client activation data
#---------------------------------------
# Disabled | NotConfigured
Set-KmsClientActivationDataSharing -GPO 'Disabled'

# Microsoft Windows Malicious Software Removal Tool (MSRT) : Heartbeat report
#---------------------------------------
# Disabled | NotConfigured
Set-MsrtDiagnosticReport -GPO 'Disabled'

# OneSettings downloads
#---------------------------------------
# Disabled | NotConfigured
Set-OneSettingsDownloads -GPO 'Disabled'

# User info sharing
#---------------------------------------
# Disabled | Enabled | NotConfigured
Set-UserInfoSharing -GPO 'Disabled'


Stop-Transcript
