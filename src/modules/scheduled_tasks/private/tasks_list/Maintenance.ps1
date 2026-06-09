#=================================================================================================================
#                                          Scheduled Tasks - Maintenance
#=================================================================================================================

$ScheduledTasksList += @{
    Maintenance = @(
        @{
            TaskPath = '\Microsoft\Windows\ApplicationData\'
            Task     = @{
                appuriverifierdaily = 'Disabled' # default: Enabled
                DsSvcCleanup        = 'Disabled' # default: Enabled
            }
            Comment  = 'DsSvcCleanup : maintenance for the Data Sharing Service.'
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\DiskCleanup\'
            Task     = @{
                SilentCleanup = 'Disabled' # default: Enabled
            }
            Comment  = 'auto disk cleanup when running low on free disk space.'
        }
        @{
            TaskPath = '\Microsoft\Windows\MUI\'
            Task     = @{
                LPRemove = 'Disabled' # default: Enabled
            }
            Comment  = 'cleanup unused language packs.'
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\Servicing\'
            Task     = @{
                StartComponentCleanup = 'Disabled' # default: Enabled
            }
            Comment  = 'clean Up the WinSxS Folder.'
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\StateRepository\'
            Task     = @{
                MaintenanceTasks = 'Disabled' # default: Enabled
            }
        }
    )
}
