#=================================================================================================================
#                                               Services - Network
#=================================================================================================================

$ServicesList += @{
    Network = @(
        @{
            DisplayName = 'Distributed Link Tracking Client'
            ServiceName = 'TrkWks'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Internet Connection Sharing (ICS)'
            ServiceName = 'SharedAccess'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed by Microsoft Defender Application Guard.
                           needed by Mobile hotspot.
                           needed by WSL2.
                           even if Disabled, will be set to Manual and running if WSL2 is launched.'
        }
        @{
            DisplayName = 'Kerberos Local Key Distribution Center'
            ServiceName = 'LocalKdc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Link-Layer Topology Discovery Mapper'
            ServiceName = 'lltdsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'network map.'
        }
        @{
            DisplayName = 'Microsoft iSCSI Initiator Service'
            ServiceName = 'MSiSCSI'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Netlogon'
            ServiceName = 'Netlogon'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'authentication for domain network.'
        }
        @{
            DisplayName = 'Network Connected Devices Auto-Setup'
            ServiceName = 'NcdAutoSetup'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Network Connectivity Assistant'
            ServiceName = 'NcaSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Offline Files'
            ServiceName = 'CscService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Peer Name Resolution Protocol'
            ServiceName = 'PNRPsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'remote assistance.'
        }
        @{
            DisplayName = 'Peer Networking Grouping'
            ServiceName = 'p2psvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'HomeGroup.'
        }
        @{
            DisplayName = 'Peer Networking Identity Manager'
            ServiceName = 'p2pimsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'remote assistance and HomeGroup.'
        }
        @{
            DisplayName = 'PNRP Machine Name Publication Service'
            ServiceName = 'PNRPAutoReg'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'network DNS resolution (P2P).'
        }
        @{
            DisplayName = 'SNMP Trap'
            ServiceName = 'SNMPTrap'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'old/legacy protocol.'
        }
        @{
            DisplayName = 'TCP/IP NetBIOS Helper'
            ServiceName = 'lmhosts'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'old/legacy protocol.'
        }
    )
}


# Not included in main script.

$ServicesListNotConfigured += @{
    Proxy = @(
        @{
            DisplayName = 'WinHTTP Web Proxy Auto-Discovery Service'
            ServiceName = 'WinHttpAutoProxySvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           on 24H2+, required by Windows Connection Manager (Wcmsvc),
                           which is required by WLAN AutoConfig (WlanSvc).
                           needed for vpn & proxy server.
                           settings > network & internet > proxy.'
        }
    )
}
