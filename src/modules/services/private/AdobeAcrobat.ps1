#=================================================================================================================
#                                            Services - Adobe Acrobat
#=================================================================================================================

$ServicesList += @{
    AdobeAcrobat = @(
        @{
            DisplayName = 'Adobe Acrobat Update Service'
            ServiceName = 'AdobeARMservice'
            StartupType = 'Manual'
            DefaultType = 'Automatic'
            Comment     = 'Adobe Acrobat checks for update at program startup even if this service is not running.'
        }
    )
}
