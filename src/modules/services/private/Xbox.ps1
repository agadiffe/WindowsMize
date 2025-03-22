#=================================================================================================================
#                                                 Services - Xbox
#=================================================================================================================

$ServicesList += @{
    Xbox = @(
        @{
            DisplayName = 'Xbox Accessory Management Service'
            ServiceName = 'XboxGipSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Xbox Live Auth Manager'
            ServiceName = 'XblAuthManager'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Xbox Live Game Save'
            ServiceName = 'XblGameSave'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Xbox Live Networking Service'
            ServiceName = 'XboxNetApiSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
