#=================================================================================================================
#                                      Scheduled Tasks - Microsoft OneDrive
#=================================================================================================================

$OneDriveTaskUserSid = (Get-LoggedOnUserInfo)['Sid']

$ScheduledTasksList += @{
    MicrosoftOneDrive = @(
        @{
            TaskPath = '\'
            Task     = @{
                "OneDrive Reporting Task-$OneDriveTaskUserSid"         = 'Disabled' # default: Enabled
                "OneDrive Standalone Update Task-$OneDriveTaskUserSid" = 'Disabled' # default: Enabled
                "OneDrive Startup Task-$OneDriveTaskUserSid"           = 'Disabled' # default: Enabled
            }
        }
    )
}
