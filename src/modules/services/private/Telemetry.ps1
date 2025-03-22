#=================================================================================================================
#                                              Services - Telemetry
#=================================================================================================================

$ServicesList += @{
    Telemetry = @(
        @{
            DisplayName = 'Connected User Experiences and Telemetry'
            ServiceName = 'DiagTrack'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Diagnostic Execution Service'
            ServiceName = 'diagsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Device Management Wireless Application Protocol (WAP) Push message Routing Service'
            ServiceName = 'dmwappushservice'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Inventory and Compatibility Appraisal service'
            ServiceName = 'InventorySvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'aka compattelrunner in windows 10.'
        }
        @{
            DisplayName = 'Microsoft (R) Diagnostics Hub Standard Collector Service'
            ServiceName = 'diagnosticshub.standardcollector.service'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Problem Reports Control Panel Support'
            ServiceName = 'wercplsupport'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Program Compatibility Assistant Service'
            ServiceName = 'PcaSvc'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
        }
        @{
            DisplayName = 'Windows Error Reporting Service'
            ServiceName = 'WerSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
