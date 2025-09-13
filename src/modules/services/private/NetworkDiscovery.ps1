#=================================================================================================================
#                                          Services - Network Discovery
#=================================================================================================================

# settings > network & internet > advanced network settings > advanced sharing settings

$ServicesList += @{
    NetworkDiscovery = @(
        @{
            DisplayName = 'Function Discovery Resource Publication'
            ServiceName = 'FDResPub'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Function Discovery Provider Host'
            ServiceName = 'fdPHost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'SSDP Discovery'
            ServiceName = 'SSDPSRV'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'UPnP Device Host'
            ServiceName = 'upnphost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
