#=================================================================================================================
#                                              Services - Deprecated
#=================================================================================================================

$ServicesList += @{
    Deprecated = @(
        @{
            DisplayName = 'ActiveX Installer (AxInstSV)'
            ServiceName = 'AxInstSV'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Internet Explorer related.'
        }
        @{
            DisplayName = 'AllJoyn Router Service'
            ServiceName = 'AJRouter'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Internet of Things related.'
        }
        @{
            DisplayName = 'Application Layer Gateway Service'
            ServiceName = 'ALG'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'plug-ins support for Internet connection sharing.'
        }
        @{
            DisplayName = 'Sync Host'
            ServiceName = 'OneSyncSvc'
            StartupType = 'Disabled'
            DefaultType = 'AutomaticDelayedStart'
        }
        @{
            DisplayName = 'WebClient'
            ServiceName = 'WebClient'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'WebDAV.'
        }
    )
}
