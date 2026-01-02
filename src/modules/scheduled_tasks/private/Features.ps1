#=================================================================================================================
#                                           Scheduled Tasks - Features
#=================================================================================================================

$ScheduledTasksList += @{
    Features = @(
        @{
            TaskPath = '\Microsoft\Windows\AppListBackup\'
            Task     = @{
                Backup               = 'Disabled' # default: Enabled
                BackupNonMaintenance = 'Disabled' # default: Enabled
            }
            Comment  = 'Windows Backup.'
        }
        @{
            TaskPath = '\Microsoft\Windows\CloudRestore\'
            Task     = @{
                Backup  = 'Disabled' # default: Enabled
                Restore = 'Disabled' # default: Enabled
            }
            Comment  = 'Windows Backup.'
        }
        @{
            TaskPath = '\Microsoft\Windows\FileHistory\'
            Task     = @{
                'File History (maintenance mode)' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Maps\'
            Task     = @{
                MapsToastTask  = 'Disabled' # default: Enabled
                MapsUpdateTask = 'Disabled' # default: Enabled
            }
            Comment  = 'Windows Maps is drepecated.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Offline Files\'
            Task     = @{
                'Background Synchronization' = 'Disabled' # default: Disabled
                'Logon Synchronization'      = 'Disabled' # default: Disabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\PushToInstall\'
            Task     = @{
                LoginCheck   = 'Disabled' # default: Enabled
                Registration = 'Disabled' # default: Enabled
            }
            Comment  = 'install Store apps remotely.'
        }
        @{
            TaskPath = '\Microsoft\Windows\RemoteAssistance\'
            Task     = @{
                RemoteAssistanceTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Shell\'
            Task     = @{
                FamilySafetyMonitor         = 'Disabled' # default: Enabled
                FamilySafetyRefreshTask     = 'Disabled' # default: Enabled
                IndexerAutomaticMaintenance = 'Disabled' # default: Enabled
                ThemeAssetTask_SyncFODState = 'Disabled' # default: Disabled
                ThemesSyncedImageDownload   = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Speech\'
            Task     = @{
                SpeechModelDownloadTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Sysmain\'
            Task     = @{
                ResPriStaticDbSync   = 'Disabled' # default: Enabled
                WsSwapAssessmentTask = 'Disabled' # default: Enabled
            }
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\SystemRestore\'
            Task     = @{
                SR = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Work Folders\'
            Task     = @{
                'Work Folders Logon Synchronization' = 'Disabled' # default: Enabled
                'Work Folders Maintenance Work'      = 'Disabled' # default: Enabled
            }
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\WindowsAI\Recall\'
            Task     = @{
                'InitialConfiguration' = 'Disabled' # default: Disabled
                'PolicyConfiguration'  = 'Disabled' # default: Enabled
            }
            Comment  = 'cannot be disabled. should be deleted ?'
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\WindowsAI\Settings\'
            Task     = @{
                'InitialConfiguration' = 'Disabled' # default: Enabled
            }
            Comment  = 'cannot be disabled. should be deleted ?'
        }
        @{
            TaskPath = '\Microsoft\XblGameSave\'
            Task     = @{
                XblGameSaveTask = 'Disabled' # default: Enabled
            }
        }
    )
}
