#=================================================================================================================
#                                           Scheduled Tasks - Features
#=================================================================================================================

$ScheduledTasksList += @{
    Features = @(
        @{
            TaskPath = '\Microsoft\Windows\AppListBackup\'
            Task     = @{
                Backup               = 'Disabled'
                BackupNonMaintenance = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\CloudRestore\'
            Task     = @{
                Backup  = 'Disabled'
                Restore = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\FileHistory\'
            Task     = @{
                'File History (maintenance mode)' = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Offline Files\'
            Task     = @{
                'Background Synchronization' = 'Disabled'
                'Logon Synchronization'      = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Flighting\OneSettings\'
            Task     = @{
                RefreshCache = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Maps\'
            Task     = @{
                MapsToastTask  = 'Disabled'
                MapsUpdateTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\PushToInstall\'
            Task     = @{
                LoginCheck   = 'Disabled'
                Registration = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\RemoteAssistance\'
            Task     = @{
                RemoteAssistanceTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Shell\'
            Task     = @{
                FamilySafetyMonitor         = 'Disabled'
                FamilySafetyRefreshTask     = 'Disabled'
                IndexerAutomaticMaintenance = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Sysmain\'
            Task     = @{
                ResPriStaticDbSync   = 'Disabled'
                WsSwapAssessmentTask = 'Disabled'
            }
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\SystemRestore\'
            Task     = @{
                SR = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Work Folders\'
            Task     = @{
                'Work Folders Logon Synchronization' = 'Disabled'
                'Work Folders Maintenance Work'      = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\XblGameSave\'
            Task     = @{
                XblGameSaveTask = 'Disabled'
            }
        }
    )
}
