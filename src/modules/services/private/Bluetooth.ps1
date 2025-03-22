#=================================================================================================================
#                                              Services - Bluetooth
#=================================================================================================================

$ServicesList += @{
    Bluetooth = @(
        @{
            DisplayName = 'Bluetooth Support Service'
            ServiceName = 'bthserv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'bluetooth devices discovery.'
        }
        @{
            DisplayName = 'Bluetooth User Support Service'
            ServiceName = 'BluetoothUserService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
    BluetoothAndCast = @(
        @{
            DisplayName = 'Device Association Service'
            ServiceName = 'DeviceAssociationService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'needed by bluetooth.
                           needed by Miracast (action center > cast).
                           if disabled open an overrun warning message when cast icon is clicked.
                           pairing with wired/wireless devices.'
        }
        @{
            DisplayName = 'DeviceAssociationBroker'
            ServiceName = 'DeviceAssociationBrokerSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           enables apps to pair devices.
                           needed only for gamepads-Xbox ?'
        }
        @{
            DisplayName = 'DevicesFlow'
            ServiceName = 'DevicesFlowUserSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'on 24H2+ DO NOT DISABLE. needed by action center.
                           connect/pair WiFi displays and Bluetooth devices.'
        }
    )
    BluetoothAudio = @(
        @{
            DisplayName = 'AVCTP service'
            ServiceName = 'BthAvctpSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed for audio bluetooth/wireless devices.'
        }
        @{
            DisplayName = 'Bluetooth Audio Gateway Service'
            ServiceName = 'BTAGService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
