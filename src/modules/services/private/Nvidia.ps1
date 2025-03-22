#=================================================================================================================
#                                                Services - Nvidia
#=================================================================================================================

$ServicesList += @{
    Nvidia = @(
        @{
            DisplayName = 'NVIDIA Display Container LS'
            ServiceName = 'NVDisplay.ContainerLocalSystem'
            StartupType = 'Manual'
            DefaultType = 'Automatic'
            Comment     = 'needed for NVIDIA Control Panel (service must be running).
                           left to Automatic if you use a lot the Nvidia Control Panel.
                           enable when gaming ? needed for some driver features (probably not) ?'
        }
    )
}