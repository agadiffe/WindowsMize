#=================================================================================================================
#                                                Services - HyperV
#=================================================================================================================

$ServicesList += @{
    HyperV = @(
        @{
            DisplayName = 'HV Host Service'
            ServiceName = 'HvHost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Data Exchange Service'
            ServiceName = 'vmickvpexchange'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Guest Service Interface'
            ServiceName = 'vmicguestinterface'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Guest Shutdown Service'
            ServiceName = 'vmicshutdown'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Heartbeat Service'
            ServiceName = 'vmicheartbeat'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V PowerShell Direct Service'
            ServiceName = 'vmicvmsession'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Remote Desktop Virtualization Service'
            ServiceName = 'vmicrdv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Time Synchronization Service'
            ServiceName = 'vmictimesync'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Hyper-V Volume Shadow Copy Requestor'
            ServiceName = 'vmicvss'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
