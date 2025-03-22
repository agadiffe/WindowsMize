#=================================================================================================================
#                                        Scheduled Tasks - Microsoft Edge
#=================================================================================================================

# If you removed Edge, disabling these task will make 'Edge Update' uninstalling itself after a while.

$ScheduledTasksList += @{
    MicrosoftEdge = @(
        @{
            TaskPath = '\'
            Task     = @{
                MicrosoftEdgeUpdateTaskMachineCore = 'Disabled'
                MicrosoftEdgeUpdateTaskMachineUA   = 'Disabled'
            }
        }
    )
}
