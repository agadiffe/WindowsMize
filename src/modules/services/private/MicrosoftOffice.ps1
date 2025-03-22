#=================================================================================================================
#                                           Services - Microsoft Office
#=================================================================================================================

$ServicesList += @{
    MicrosoftOffice = @(
        @{
            DisplayName = 'Microsoft Office Click-to-Run Service'
            ServiceName = 'ClickToRunSvc'
            StartupType = 'Manual'
            DefaultType = 'Automatic'
            Comment     = 'if tasks are not disabled or modified, will still be launched at startup.
                           slow down first startup (Office apps need this service running).
                           left to Automatic if daily use of Office.'
        }
    )
}
