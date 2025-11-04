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
Write-Output -InputObject 'Loading ''Network'' Module ...'
$WindowsMizeModuleNames = @( 'network', 'services' )
Import-Module -Name $WindowsMizeModuleNames.ForEach({ "$PSScriptRoot\..\..\src\modules\$_" })


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                                     Network
#=================================================================================================================

Write-Section -Name 'Network'

#==============================================================================
#                         IPv6 transition technologies
#==============================================================================
#region ipv6 transition

Write-Section -Name 'IPv6 transition technologies' -SubSection

# GPO: Disabled | Enabled | NotConfigured (default)

# --- 6to4 (default: Enabled)
Set-NetIPv6Transition -Name '6to4' -State 'Disabled' -GPO 'Disabled'

# --- Teredo (default: Enabled)
Set-NetIPv6Transition -Name 'Teredo' -State 'Disabled' -GPO 'Disabled'

# --- IP-HTTPS (default: Enabled)
Set-NetIPv6Transition -Name 'IP-HTTPS' -State 'Disabled' -GPO 'Disabled'

# --- ISATAP (default: Enabled)
Set-NetIPv6Transition -Name 'ISATAP' -State 'Disabled' -GPO 'Disabled'

#endregion ipv6 transition

#==============================================================================
#                           Network adapter protocol
#==============================================================================
#region protocol

Write-Section -Name 'Network adapter protocol' -SubSection

Export-DefaultNetAdapterProtocolsState

# --- Link-Layer Topology Discovery Mapper I/O Driver (default: Enabled)
Set-NetAdapterProtocol -Name 'LltdIo' -State 'Disabled'

# --- Link-Layer Topology Discovery Responder (default: Enabled)
Set-NetAdapterProtocol -Name 'LltdResponder' -State 'Disabled'

# --- TCP/IPv4 (default: Enabled)
#Set-NetAdapterProtocol -Name 'IPv4' -State 'Enabled'

# --- TCP/IPv6 (default: Enabled)
#Set-NetAdapterProtocol -Name 'IPv6' -State 'Enabled'

# --- Client for Microsoft Networks (access other computers) (default: Enabled)
# Needed by NetworkDiscovery (File Explorer > Network)
#Set-NetAdapterProtocol -Name 'FileSharingClient' -State 'Disabled'

# --- File and Printer Sharing for Microsoft Networks (be accessible by other computers) (default: Enabled)
# Needed by NetworkDiscovery (File Explorer > Network)
#Set-NetAdapterProtocol -Name 'FileSharingServer' -State 'Disabled'

# --- Bridge Driver (default: Enabled) |  old ?
Set-NetAdapterProtocol -Name 'BridgeDriver' -State 'Disabled'

# --- QoS Packet Scheduler (default: Enabled)
Set-NetAdapterProtocol -Name 'QosPacketScheduler' -State 'Disabled'

# --- Hyper-V Extensible Virtual Switch (default: Disabled)
Set-NetAdapterProtocol -Name 'HyperVExtensibleVirtualSwitch' -State 'Disabled'

# --- Microsoft LLDP Protocol Driver (Link-Layer Discovery Protocol) (default: Enabled)
Set-NetAdapterProtocol -Name 'Lldp' -State 'Disabled'

# --- Microsoft Network Adapter Multiplexor Protocol (default: Disabled)
Set-NetAdapterProtocol -Name 'MicrosoftMultiplexor' -State 'Disabled'

#       System Drivers (Services)
#=======================================

Export-DefaultSystemDriversStartupType

# Comment the drivers you want to disable.
$SystemDriversToConfig = @(
    'BridgeDriver' # old ?
    'NetBiosDriver' # needed by old pc/hardware: File and Printer Sharing
    'NetBiosOverTcpIpDriver' # legacy/old | needed by old pc/hardware: File and Printer Sharing
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

#endregion protocol

#==============================================================================
#                                Miscellaneous
#==============================================================================
#region miscellaneous

Write-Section -Name 'Miscellaneous' -SubSection

# --- NetBIOS over TCP/IP
# State: Disabled | Enabled | Default (default)
Set-NetBiosOverTcpIP -State 'Disabled'

# --- Internet Control Message Protocol (ICMP) redirects (default: Enabled)
Set-NetIcmpRedirects -State 'Disabled'

# --- IP source routing (default: Enabled)
Set-NetIPSourceRouting -State 'Disabled'

# --- Link Local Multicast Name Resolution (LLMNR)
# Disabled: Might fail to resolve hostname to IP address.
#   e.g. File Explorer > Network > Computer_Name : error path not found.
#Set-NetLlmnr -GPO 'NotConfigured'

# --- LAN Manager Hosts (LMHOSTS) (default: Enabled)
Set-NetLmhosts -State 'Disabled'

# --- Multicast DNS (mDNS) (default: Enabled)
# Disabled:
#   Might fail to resolve hostname to IP address.
#   e.g. File Explorer > Network > Computer_Name : error path not found.
#   Workstations may not be able to find wireless screen mirroring devices.
#   e.g. Chromecasts, Apple AirPlay, Printers and anything else that relies on MDNS.
#Set-NetMulicastDns -State 'Disabled'

# --- Smart Multi-Homed Name Resolution
Set-NetSmhnr -GPO 'Disabled'

# --- Web Proxy Auto-Discovery protocol (WPAD) (default: Enabled)
#Set-NetProxyAutoDetect -State 'Disabled'

#endregion miscellaneous
