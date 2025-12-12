#=================================================================================================================
#                                       Scheduled Tasks - Microsoft Office
#=================================================================================================================

# If you prefer to let 'Microsoft Office' to auto update, don't disable these tasks.

$ScheduledTasksList += @{
    MicrosoftOffice = @(
        @{
            TaskPath = '\Microsoft\Office\'
            Task     = @{
                'Office Actions Server'              = 'Disabled' # default: Enabled
                'Office Automatic Updates 2.0'       = 'Disabled' # default: Enabled
                'Office Background Push Maintenance' = 'Disabled' # default: Enabled
                'Office ClickToRun Service Monitor'  = 'Disabled' # default: Enabled
                'Office Feature Updates'             = 'Disabled' # default: Enabled
                'Office Feature Updates Logon'       = 'Disabled' # default: Enabled
                'Office Performance Monitor'         = 'Disabled' # default: Enabled
                'Office Startup Boost'               = 'Disabled' # default: Enabled
                'Office Startup Boost Logon'         = 'Disabled' # default: Enabled
                'Office Startup Maintenance'         = 'Disabled' # default: Enabled
            }
        }
    )
}
