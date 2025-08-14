#=================================================================================================================
#                                         Scheduled Tasks - Adobe Acrobat
#=================================================================================================================

# Even with this task disabled, Adobe Acrobat Reader will still check for update at program startup.
# Will be reset to enabled after update.

$ScheduledTasksList += @{
    AdobeAcrobat = @(
        @{
            TaskPath = '\'
            Task     = @{
                'Adobe Acrobat Update Task' = 'Disabled' # default: Enabled
            }
        }
    )
}
