#=================================================================================================================
#                                           Services - Cast And Project
#=================================================================================================================

# Not included in main script.

$ServicesListNotConfigured += @{
    CastAndProject = @(
        @{
            DisplayName = 'DevicePicker'
            ServiceName = 'DevicePickerUserSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'Manage Miracast, DLNA, and DIAL UI.'
        }
        @{
            DisplayName = 'Wi-Fi Direct Services Connection Manager Service'
            ServiceName = 'WFDSConMgrSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'wireless display and docking.
                           needed by action center > cast & project.
                           if disabled and Cast icon is clicked, break action center (on Win11 24H2+).
                           if that happens, you need to open services and set back to Manual.
                           (on Win11 23H2, break action center functionality if Cast icon is not hidden).'
        }
    )
}
