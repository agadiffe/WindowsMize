#=================================================================================================================
#                                        Scheduled Tasks - System Drivers
#=================================================================================================================

$ScheduledTasksList += @{
    UserChoiceProtectionDriver = @(
        @{
            TaskPath = '\Microsoft\Windows\AppxDeploymentClient\'
            Task     = @{
                'UCPD velocity' = 'Disabled' # default: Enabled
            }
            Comment  = 're-enable userChoice Protection Driver (UCPD) if disabled.'
        }
    )
}
