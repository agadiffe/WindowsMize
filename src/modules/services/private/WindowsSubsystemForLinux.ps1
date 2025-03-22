#=================================================================================================================
#                                     Services - Windows Subsystem For Linux
#=================================================================================================================

$ServicesList += @{
    WindowsSubsystemForLinux = @(
        @{
            DisplayName = 'Hyper-V Host Compute Service'
            ServiceName = 'vmcompute'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed by WSL'
        }
        @{
            DisplayName = 'P9RdrService'
            ServiceName = 'P9RdrService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Plan 9 Redirector Service.
                           Enables trigger-starting plan9 file servers (supported by WSL).'
        }
        @{
            DisplayName = 'Windows Subsystem for Linux'
            ServiceName = 'WslInstaller'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with services.msc.
                           left to Automatic if daily use of WSL.
                           seems to be removed in latest version.'
        }
        @{
            DisplayName = 'WSL Service'
            ServiceName = 'WSLService'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'left to Automatic if daily use of WSL.'
        }
    )
}
