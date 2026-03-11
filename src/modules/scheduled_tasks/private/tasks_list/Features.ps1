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
            TaskPath = '\Microsoft\Windows\Flighting\FeatureConfig\'
            Task     = @{
                BootstrapUsageDataReporting    = 'Disabled' # default: Disabled
                GovernedFeatureUsageProcessing = 'Disabled' # default: Enabled
                ReconcileConfigs               = 'Enabled'  # default: Enabled
                ReconcileFeatures              = 'Enabled'  # default: Enabled
                UsageDataFlushing              = 'Disabled' # default: Enabled
                UsageDataReceiver              = 'Disabled' # default: Enabled
                UsageDataReporting             = 'Disabled' # default: Enabled
            }
            Comment  = 'used for gradual feature rollouts and A/B testing of UI changes.
                        reconciles feature flags, processes/collects feature usage telemetry.
                        Disabling prevents feature overrides from being reverted and reduces telemetry.
                        ReconcileConfigs: updates feature configuration definitions.
                        ReconcileFeatures: applies the feature flag states (might (or not) revert changes made by ViVeTool).'
        }
        @{
            TaskPath = '\Microsoft\Windows\Flighting\OneSettings\'
            Task     = @{
                RefreshCache = 'Disabled' # default: Enabled
            }
            Comment  = 'downloads remote feature flags and experiment configuration (A/B testing / staged rollouts).
                        if disabled:
                          most new features will arrive with Windows updates.
                          feature rollouts occur less frequently between updates.
                          prevents most remote A/B testing delivered through Windows flighting.'
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
            TaskPath = '\Microsoft\Windows\Setup\'
            Task     = @{
                PITRTask = 'Disabled' # default: Enabled
            }
            Comment  = 'create Point-In-Time-Restore snapshots at startup.'
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
            TaskPath = '\Microsoft\Windows\WindowsAI\Recall\'
            Task     = @{
                'InitialConfiguration' = 'Disabled' # default: Disabled
                'PolicyConfiguration'  = 'Disabled' # default: Enabled
            }
            Comment  = 'system protected task.'
        }
        @{
            TaskPath = '\Microsoft\Windows\WindowsAI\Settings\'
            Task     = @{
                'InitialConfiguration' = 'Disabled' # default: Enabled
            }
            Comment  = 'system protected task.'
        }
        @{
            TaskPath = '\Microsoft\XblGameSave\'
            Task     = @{
                XblGameSaveTask = 'Disabled' # default: Enabled
            }
        }
    )
}
