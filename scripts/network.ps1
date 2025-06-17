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

Write-Output -InputObject 'Loading ''Network'' Module ...'
$WindowsMizeModulesNames = @(
    'network'
    'services'
)
Import-Module -Name $WindowsMizeModulesNames.ForEach({ "$PSScriptRoot\..\src\modules\$_" })


# Parameters values (if not specified):
#   State: Disabled | Enabled # State's default is in parentheses next to the title.

#=================================================================================================================
#                                                     Network
#=================================================================================================================

Write-Section -Name 'Network'

#==============================================================================
#                                   Firewall
#==============================================================================
#region firewall

Write-Section -Name 'Firewall' -SubSection

# --- Connected Devices Platform service (CDP)
Block-NetFirewallInboundRule -Name 'CDP'

# --- DCOM service control manager
Block-NetFirewallInboundRule -Name 'DCOM'

# --- NetBIOS over TCP/IP
Block-NetFirewallInboundRule -Name 'NetBiosTcpIP'

# --- Server Message Block (SMB) (e.g. File And Printer Sharing)
Block-NetFirewallInboundRule -Name 'SMB'

# --- Miscellaneous programs/services
# lsass.exe, wininit.exe, Schedule, EventLog, services.exe
Block-NetFirewallInboundRule -Name 'MiscProgSrv'

#endregion firewall


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
Set-NetAdapterProtocol -Name 'IPv4' -State 'Enabled'

# --- TCP/IPv6 (default: Enabled)
Set-NetAdapterProtocol -Name 'IPv6' -State 'Enabled'

# --- Client for Microsoft Networks (access other computers) (default: Enabled)
Set-NetAdapterProtocol -Name 'FileSharingClient' -State 'Disabled'

# --- File and Printer Sharing for Microsoft Networks (be accessible by other computers) (default: Enabled)
Set-NetAdapterProtocol -Name 'FileSharingServer' -State 'Disabled'

# --- Bridge Driver |  old ? (default: Enabled)
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
    #'NetBiosDriver' # needed by: File and Printer Sharing
    #'NetBiosOverTcpIpDriver' # legacy/old | needed by old pc/hardware: File and Printer Sharing
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
# GPO: Disabled | NotConfigured
Set-NetLlmnr -GPO 'Disabled'

# --- Smart Multi-Homed Name Resolution
# GPO: Disabled | NotConfigured
Set-NetSmhnr -GPO 'Disabled'

# --- Web Proxy Auto-Discovery protocol (WPAD) (default: Enabled)
#Set-NetProxyAutoDetect -State 'Disabled'

#endregion miscellaneous


Stop-Transcript
