#=================================================================================================================
#                                            Services - Microsoft Edge
#=================================================================================================================

$ServicesListNotConfigured += @{
    MicrosoftEdge = @(
        @{
            DisplayName = 'Microsoft Edge Elevation Service (MicrosoftEdgeElevationService)'
            ServiceName = 'MicrosoftEdgeElevationService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Microsoft Edge Update Service (edgeupdate)'
            ServiceName = 'edgeupdate'
            StartupType = 'Manual'
            DefaultType = 'AutomaticDelayedStart'
        }
        @{
            DisplayName = 'Microsoft Edge Update Service (edgeupdatem)'
            ServiceName = 'edgeupdatem'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
    )
}
