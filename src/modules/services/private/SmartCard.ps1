#=================================================================================================================
#                                              Services - Smart Card
#=================================================================================================================

$ServicesList += @{
    SmartCard = @(
        @{
            DisplayName = 'Certificate Propagation'
            ServiceName = 'CertPropSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Smart Card'
            ServiceName = 'SCardSvr'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Smart Card Device Enumeration Service'
            ServiceName = 'ScDeviceEnum'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Smart Card Removal Policy'
            ServiceName = 'SCPolicySvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
