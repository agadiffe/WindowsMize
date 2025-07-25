#=================================================================================================================
#                                       Scheduled Tasks - Microsoft Office
#=================================================================================================================

# If you prefer to let 'Microsoft Office' to auto update, don't disable these tasks.

$ScheduledTasksList += @{
    MicrosoftOffice = @(
        @{
            TaskPath = '\Microsoft\Office\'
            Task     = @{
                'Office Actions Server'             = 'Disabled'
                'Office Automatic Updates 2.0'      = 'Disabled'
                'Office ClickToRun Service Monitor' = 'Disabled'
                'Office Feature Updates'            = 'Disabled'
                'Office Feature Updates Logon'      = 'Disabled'
                'Office Performance Monitor'        = 'Disabled'
                'Office Startup Boost'              = 'Disabled'
                'Office Startup Boost Logon'        = 'Disabled'
            }
        }
    )
}
