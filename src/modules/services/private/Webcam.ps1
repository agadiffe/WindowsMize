#=================================================================================================================
#                                                Services - Webcam
#=================================================================================================================

$ServicesList += @{
    Webcam = @(
        @{
            DisplayName = 'Windows Camera Frame Server'
            ServiceName = 'FrameServer'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'e.g. Microsoft Teams, Skype, or Camera app.'
        }
        @{
            DisplayName = 'Windows Camera Frame Server Monitor'
            ServiceName = 'FrameServerMonitor'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'e.g. Microsoft Teams, Skype, or Camera app.'
        }
    )
}
