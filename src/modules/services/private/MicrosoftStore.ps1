#=================================================================================================================
#                                           Services - Microsoft Store
#=================================================================================================================

$ServicesList += @{
    MicrosoftStore = @(
        @{
            DisplayName = 'AppX Deployment Service (AppXSVC)'
            ServiceName = 'AppXSvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           infrastructure support for deploying Store applications.'
        }
        @{
            DisplayName = 'Capability Access Manager Service'
            ServiceName = 'camsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'manages UWP apps access.'
        }
        @{
            DisplayName = 'Client License Service (ClipSVC)'
            ServiceName = 'ClipSVC'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with services.msc.
                           infrastructure support for the Microsoft Store.'
        }
        @{
            DisplayName = 'Microsoft Account Sign-in Assistant'
            ServiceName = 'wlidsvc'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed if using microsoft account to log in to computer.
                           needed to install new apps from microsoft store.
                           needed to create new microsoft account (not needed for new local account).
                           not needed to auto-update already installed apps.'
        }
        @{
            DisplayName = 'Microsoft Store Install Service'
            ServiceName = 'InstallService'
            StartupType = 'Manual'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Windows License Manager Service'
            ServiceName = 'LicenseManager'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed by Windows Photos (and probably more Store apps).'
        }
        @{
            DisplayName = 'Windows PushToInstall Service'
            ServiceName = 'PushToInstall'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'install Store apps remotely.'
        }
    )
}
