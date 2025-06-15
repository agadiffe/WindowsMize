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

Write-Output -InputObject 'Loading ''Network'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

$WindowsMizeModulesNames = @(
    'network'
    'services'
)
Import-Module -Name $WindowsMizeModulesNames.ForEach({ "$PSScriptRoot\..\src\modules\$_" })



#=================================================================================================================
#                                                     Network
#=================================================================================================================

Write-Section -Name 'Network'

#==============================================================================
#                                   Firewall
#==============================================================================

Write-Section -Name 'Firewall' -SubSection

# Connected Devices Platform service (CDP)
#---------------------------------------
Block-NetFirewallInboundRule -Name 'CDP'

# DCOM service control manager
#---------------------------------------
Block-NetFirewallInboundRule -Name 'DCOM'

# NetBIOS over TCP/IP
#---------------------------------------
Block-NetFirewallInboundRule -Name 'NetBiosTcpIP'

# Server Message Block (SMB) (e.g. File And Printer Sharing)
#---------------------------------------
Block-NetFirewallInboundRule -Name 'SMB'

# Miscellaneous programs/services
# lsass.exe, wininit.exe, Schedule, EventLog, services.exe
#---------------------------------------
Block-NetFirewallInboundRule -Name 'MiscProgSrv'


#==============================================================================
#                         IPv6 transition technologies
#==============================================================================

Write-Section -Name 'IPv6 transition technologies' -SubSection

# 6to4
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name '6to4' -State 'Disabled' -GPO 'Disabled'

# Teredo
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'Teredo' -State 'Disabled' -GPO 'Disabled'

# IP-HTTPS
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'IP-HTTPS' -State 'Disabled' -GPO 'Disabled'

# ISATAP
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-NetIPv6Transition -Name 'ISATAP' -State 'Disabled' -GPO 'Disabled'


#==============================================================================
#                           Network adapter protocol
#==============================================================================

Write-Section -Name 'Network adapter protocol' -SubSection

Export-DefaultNetAdapterProtocolsState

# Link-Layer Topology Discovery Mapper I/O Driver
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'LltdIo' -State 'Disabled'

# Link-Layer Topology Discovery Responder
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'LltdResponder' -State 'Disabled'

# TCP/IPv4
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'IPv4' -State 'Enabled'

# TCP/IPv6
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'IPv6' -State 'Enabled'

# Client for Microsoft Networks (access other computers)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'FileSharingClient' -State 'Disabled'

# File and Printer Sharing for Microsoft Networks (be accessible by other computers)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'FileSharingServer' -State 'Disabled'

# Bridge Driver |  old ?
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'BridgeDriver' -State 'Disabled'

# QoS Packet Scheduler
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'QosPacketScheduler' -State 'Disabled'

# Hyper-V Extensible Virtual Switch
#---------------------------------------
# Disabled (default) | Enabled
Set-NetAdapterProtocol -Name 'HyperVExtensibleVirtualSwitch' -State 'Disabled'

# Microsoft LLDP Protocol Driver (Link-Layer Discovery Protocol)
#---------------------------------------
# Disabled | Enabled (default)
Set-NetAdapterProtocol -Name 'Lldp' -State 'Disabled'

# Microsoft Network Adapter Multiplexor Protocol
#---------------------------------------
# Disabled (default) | Enabled
Set-NetAdapterProtocol -Name 'MicrosoftMultiplexor' -State 'Disabled'

#       System Drivers (Services)
#=======================================

Export-DefaultSystemDriversStartupType

# Comment the drivers you want to disable.
$SystemDriversToConfig = @(
    'BridgeDriver' # old ?
    #'NetBiosDriver' # needed by: File and Printer Sharing
    #'NetBiosOverTcpIpDriver' # legacy/old | needed by (if really old pc): File and Printer Sharing
    'LldpDriver'
    'LltdIoDriver'
    'LltdResponderDriver'
    'MicrosoftMultiplexorDriver'
    'QosPacketSchedulerDriver' # not really needed on small home network
)
# Disable the above selected drivers.
#$SystemDriversToConfig | Set-ServiceStartupTypeGroup

# Restore to default the above selected drivers.
#$SystemDriversToConfig | Set-ServiceStartupTypeGroup -RestoreDefault


#==============================================================================
#                                Miscellaneous
#==============================================================================

Write-Section -Name 'Miscellaneous' -SubSection

# NetBIOS over TCP/IP
#---------------------------------------
# Disabled | Enabled | Default (default)
Set-NetBiosOverTcpIP -State 'Disabled'

# Internet Control Message Protocol (ICMP) redirects
#---------------------------------------
# Disabled | Enabled (default)
Set-NetIcmpRedirects -State 'Disabled'

# IP source routing
#---------------------------------------
# Disabled | Enabled (default)
Set-NetIPSourceRouting -State 'Disabled'

# Link Local Multicast Name Resolution (LLMNR)
#---------------------------------------
# Disabled | NotConfigured
Set-NetLlmnr -GPO 'Disabled'

# Smart Multi-Homed Name Resolution
#---------------------------------------
# Disabled | NotConfigured
Set-NetSmhnr -GPO 'Disabled'

# Web Proxy Auto-Discovery protocol (WPAD)
#---------------------------------------
# Disabled | Enabled (default)
#Set-NetWpad -State 'Disabled'


Stop-Transcript
