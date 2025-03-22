#=================================================================================================================
#                                                 Services - VPN
#=================================================================================================================

$ServicesList += @{
    Vpn = @(
        @{
            DisplayName = 'IKE and AuthIP IPsec Keying Modules'
            ServiceName = 'IKEEXT'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Remote Access Connection Manager'
            ServiceName = 'RasMan'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Secure Socket Tunneling Protocol Service'
            ServiceName = 'SstpSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
