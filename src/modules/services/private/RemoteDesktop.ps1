#=================================================================================================================
#                                            Services - Remote Desktop
#=================================================================================================================

$ServicesList += @{
    RemoteDesktop = @(
        @{
            DisplayName = 'Remote Desktop Configuration'
            ServiceName = 'SessionEnv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Remote Desktop Services'
            ServiceName = 'TermService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Remote Desktop Services UserMode Port Redirector'
            ServiceName = 'UmRdpService'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Remote Registry'
            ServiceName = 'RemoteRegistry'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
        @{
            DisplayName = 'Routing and Remote Access'
            ServiceName = 'RemoteAccess'
            StartupType = 'Disabled'
            DefaultType = 'Disabled'
        }
    )
}
