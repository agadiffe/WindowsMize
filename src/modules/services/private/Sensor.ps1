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
            Comment     = 'delivers data from various sensors.
                           e.g. screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in).'
        }
        @{
            DisplayName = 'Sensor Monitoring Service'
            ServiceName = 'SensrSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'monitors sensors to expose data and adapt to system and user state.
                           e.g. screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in).'
        }
        @{
            DisplayName = 'Sensor Service'
            ServiceName = 'SensorService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'manages overall sensor functionality and coordination.
                           e.g. screen auto-rotation, adaptive brightness, location, Windows Hello (face/fingerprint sign-in).
                           if disabled on laptop, break/crash: settings > system > power & battery.
                           do not disable on laptop.'
        }
    )
}
