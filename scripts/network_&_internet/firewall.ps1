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

#=================================================================================================================
#                                                     Network
#=================================================================================================================

Write-Section -Name 'Network'

#==============================================================================
#                                   Firewall
#==============================================================================
Write-Section -Name 'Firewall' -SubSection

#             Default rules
#=======================================

# By default, Defender Firewall outbound connections that do not match a rule are all allowed.
# It means that disabling a feature will affect only inbound connections.
# i.e. Disabling "CastToDevice" will not prevent casting to other devices.

# --- AllJoyn Router (default: Enabled)
# Internet of Things related.
Set-DefenderFirewallRule -Name 'AllJoynRouter' -State 'Disabled'

# --- Cast to Device functionality (default: Enabled)
Set-DefenderFirewallRule -Name 'CastToDevice' -State 'Disabled'

# --- Connected Devices Platform (default: Enabled)
Set-DefenderFirewallRule -Name 'ConnectedDevicesPlatform' -State 'Disabled'

# --- Delivery Optimization (default: Enabled)
Set-DefenderFirewallRule -Name 'DeliveryOptimization' -State 'Disabled'

# --- DIAL protocol server (default: Enabled)
# Remote control of media Apps on this device.
Set-DefenderFirewallRule -Name 'DIALProtocol' -State 'Disabled'

# --- Microsoft Media Foundation Network Source (default: Enabled)
# Hosting media services or sharing media from this device.
Set-DefenderFirewallRule -Name 'MicrosoftMediaFoundation' -State 'Disabled'

# --- Proximity Sharing over TCP (default: Enabled)
# i.e. Nearby Sharing
Set-DefenderFirewallRule -Name 'ProximitySharing' -State 'Disabled'

# --- Wi-Fi Direct Network Discovery (default: Enabled)
# Connect to devices without router (Peer-to-peer connections) (e.g. miracast, printer, file sharing).
Set-DefenderFirewallRule -Name 'WifiDirectDiscovery' -State 'Disabled'

# --- Wireless Display (default: Enabled)
# Wi-Fi Direct related.
Set-DefenderFirewallRule -Name 'WirelessDisplay' -State 'Disabled'

# --- WLAN Service - WFD Application Services Platform Coordination Protocol (default: Enabled)
# Wi-Fi Direct related.
Set-DefenderFirewallRule -Name 'WiFiDirectCoordinationProtocol' -State 'Disabled'

# --- WLAN Service - WFD Services Kernel Mode Driver Rules (default: Enabled)
# Wi-Fi Direct related.
Set-DefenderFirewallRule -Name 'WiFiDirectKernelModeDriver' -State 'Disabled'

#             Custom rules
#=======================================

# You should still be able to connect to other computers and their replies will be allowed back.
# What might fail is when another computer tries to connect to you (they cannot initiate new SMB/NetBIOS connections).

# --- Connected Devices Platform service (CDP)
Block-DefenderFirewallInboundRule -Name 'CDP'
#Block-DefenderFirewallInboundRule -Name 'CDP' -Reset

# --- DCOM service control manager & Remote Procedure Call (RPC) services
# Might be needed by SMB (e.g. File And Printer Sharing) to be contacted by other computers.
Block-DefenderFirewallInboundRule -Name 'DCOM_RPC'
#Block-DefenderFirewallInboundRule -Name 'DCOM_RPC' -Reset

# --- NetBIOS over TCP/IP
Block-DefenderFirewallInboundRule -Name 'NetBiosTcpIP'
#Block-DefenderFirewallInboundRule -Name 'NetBiosTcpIP' -Reset

# --- Server Message Block (SMB) (e.g. File And Printer Sharing)
Block-DefenderFirewallInboundRule -Name 'SMB'
#Block-DefenderFirewallInboundRule -Name 'SMB' -Reset

# --- Miscellaneous programs/services
# lsass.exe, wininit.exe, Schedule, EventLog, services.exe
Block-DefenderFirewallInboundRule -Name 'MiscProgSrv'
#Block-DefenderFirewallInboundRule -Name 'MiscProgSrv' -Reset
