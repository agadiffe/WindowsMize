#=================================================================================================================
#                                                Services - Sensor
#=================================================================================================================

$ServicesList += @{
    Sensor = @(
        @{
            DisplayName = 'Sensor Data Service'
            ServiceName = 'SensorDataService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Sensor Monitoring Service'
            ServiceName = 'SensrSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Sensor Service'
            ServiceName = 'SensorService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'manages different sensors functionality.
                           if disabled on laptop, break/crash settings > system > power & battery.
                           do not disable on laptop.'
        }
    )
}
