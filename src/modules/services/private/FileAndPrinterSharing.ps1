#=================================================================================================================
#                                       Services - File And Printer Sharing
#=================================================================================================================

# settings > network & internet > advanced network settings > advanced sharing settings

$ServicesList += @{
    FileAndPrinterSharing = @(
        @{
            DisplayName = 'Server'
            ServiceName = 'LanmanServer'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'file and printer sharing (SMB server).
                           needed to share files & folders to other computer.
                           if disabled, removes the sharing tab from folder properties.'
        }
        @{
            DisplayName = 'Workstation'
            ServiceName = 'LanmanWorkstation'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'connect to remote computer/server.
                           file and printer sharing (SMB client).'
        }
    )
}
