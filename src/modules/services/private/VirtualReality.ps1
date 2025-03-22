#=================================================================================================================
#                                           Services - Virtual Reality
#=================================================================================================================

$ServicesList += @{
    VirtualReality = @(
        @{
            DisplayName = 'Spatial Data Service'
            ServiceName = 'SharedRealitySvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Volumetric Audio Compositor Service'
            ServiceName = 'VacSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Mixed Reality OpenXR Service'
            ServiceName = 'MixedRealityOpenXRSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Perception Service'
            ServiceName = 'spectrum'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows Perception Simulation Service'
            ServiceName = 'perceptionsimulation'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
