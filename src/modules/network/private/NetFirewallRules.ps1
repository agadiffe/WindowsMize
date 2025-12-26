#=================================================================================================================
#                                            Network - Firewall Rules
#=================================================================================================================

#==============================================================================
# Connected Devices Platform (CDP) Service
#==============================================================================

# Ports 5040 and 5050 should not be exposed to the internet.
# Needed by miracast and project ? if issues, don't block these ports.

$NetFirewallRules += @{
    CDP = @{
        Group = '!Custom block inbound port (CDP)'
        Rules = @(
            @{
                DisplayName = 'Block Inbound Port 5040 TCP (CDP)'
                LocalPort   = '5040'
                Protocol    = 'TCP'
            }
            @{
                DisplayName = 'Block Inbound Port 5050 UDP (CDP)'
                LocalPort   = '5050'
                Protocol    = 'UDP'
            }
        )
    }
}

#==============================================================================
# Distributed Component Object Model (DCOM) Service Control Manager
# Remote Procedure Call (RPC) services
#==============================================================================

# Port 135 exposes where DCOM services can be found on a machine.
# Port 135 should not be exposed to the internet.

# required by several Windows remote‑management and directory services.
# e.g. WMI, Remote Assistance, Active Directory/Group Policy and other RPC/DCOM‑based tools.
# e.g. Used by 'file and printer sharing' to be contacted by other computer.

$NetFirewallRules += @{
    DCOM_RPC = @{
        Group = '!Custom block inbound port (DCOM/RPC)'
        Rules = @(
            @{
                DisplayName = 'Block Inbound Port 135 TCP (DCOM/RPC)'
                LocalPort   = '135'
                Protocol    = 'TCP'
            }
            @{
                DisplayName = 'Block Inbound Port 135 UDP (DCOM/RPC)'
                LocalPort   = '135'
                Protocol    = 'UDP'
            }
        )
    }
}

#==============================================================================
# NetBios over TCP/IP
#==============================================================================

# Ports 137-139 should not be exposed to the internet.
# Port 139 is utilized by NetBIOS Session service.
# Port 138 is utilized by NetBIOS Datagram service.
# Port 137 is utilized by NetBIOS Name service.
# Used by 'file and printer sharing' to contact computer using this old/legacy protocol.

# Even if 'file and printer sharing' is disabled, these ports are still listening.
# To close them, you need to disable 'NetBios over TCP/IP' kernel driver service (NetBT).
# See 'services & scheduled tasks > services > system driver'.

$NetFirewallRules += @{
    NetBiosTcpIP = @{
        Group = '!Custom block inbound port (NetBios TCP/IP)'
        Rules = @(
            @{
                DisplayName = 'Block Inbound Port 139 TCP (NetBios TCP/IP)'
                LocalPort   = '139'
                Protocol    = 'TCP'
            }
            @{
                DisplayName = 'Block Inbound Port 137, 138 UDP (NetBios TCP/IP)'
                LocalPort   = '137', '138'
                Protocol    = 'UDP'
            }
        )
    }
}

#==============================================================================
# Server Message Block (SMB)
#==============================================================================

# Port 445 should not be exposed to the internet.
# Used by 'file and printer sharing' (port is closed if the feature is disabled).
# Needed by Docker and Shared drives ?

$NetFirewallRules += @{
    SMB = @{
        Group = '!Custom block inbound port (SMB)'
        Rules = @{
            DisplayName = 'Block Inbound Port 445 TCP (SMB)'
            LocalPort   = '445'
            Protocol    = 'TCP'
        }
    }
}

#==============================================================================
# Miscellaneous Program/Service
#==============================================================================

# Ports 49664-49669 should not be exposed to the internet.
# Used for remote management (probably) ?

# These ports are shown as listening (locally) in Netstat or TCP View.
# As it is probably dynamic ports, block the program/service.

$NetFirewallRules += @{
    MiscProgSrv = @{
        Group = '!Custom block inbound prog/service (misc)'
        Rules = @(
            @{
                DisplayName = 'Block Inbound TCP - lsass.exe'
                #LocalPort   = '49664'
                Protocol    = 'TCP'
                Program     = '%SystemRoot%\System32\lsass.exe'
            }
            @{
                DisplayName = 'Block Inbound TCP - wininit.exe'
                #LocalPort   = '49665'
                Protocol    = 'TCP'
                Program     = '%SystemRoot%\System32\wininit.exe'
            }
            @{
                DisplayName = 'Block Inbound TCP - Schedule'
                #LocalPort   = '49666'
                Protocol    = 'TCP'
                Program     = '%SystemRoot%\system32\svchost.exe'
                Service     = 'Schedule'
            }
            @{
                DisplayName = 'Block Inbound TCP - EventLog'
                #LocalPort   = '49667'
                Protocol    = 'TCP'
                Program     = '%SystemRoot%\system32\svchost.exe'
                Service     = 'EventLog'
            }
            @{
                DisplayName = 'Block Inbound TCP - services.exe'
                #LocalPort   = '49668' or '49669'
                Protocol    = 'TCP'
                Program     = '%SystemRoot%\System32\services.exe'
            }
        )
    }
}
