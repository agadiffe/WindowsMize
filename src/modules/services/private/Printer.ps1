#=================================================================================================================
#                                               Services - Printer
#=================================================================================================================

$ServicesList += @{
    Printer = @(
        @{
            DisplayName = 'Print Device Configuration Service'
            ServiceName = 'PrintDeviceConfigurationService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed by Windows protected print mode.
                           settings > bluetooth & devices > printers & scanners.'
        }
        @{
            DisplayName = 'Print Spooler'
            ServiceName = 'Spooler'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
        }
        @{
            DisplayName = 'Printer Extensions and Notifications'
            ServiceName = 'PrintNotify'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'PrintScanBrokerService'
            ServiceName = 'PrintScanBrokerService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'probably related to Windows protected print mode'
        }
        @{
            DisplayName = 'PrintWorkflow'
            ServiceName = 'PrintWorkflowUserSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           Cloud/internet printers. Not needed by local printers.'
        }
    )
}
