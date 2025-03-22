#=================================================================================================================
#                                           Scheduled Tasks - Telemetry
#=================================================================================================================

$ScheduledTasksList += @{
    Telemetry = @(
        @{
            TaskPath = '\Microsoft\Windows\ApplicationData\'
            Task     = @{
                appuriverifierdaily = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Application Experience\'
            Task     = @{
                MareBackup                              = 'Disabled'
                'Microsoft Compatibility Appraiser'     = 'Disabled'
                'Microsoft Compatibility Appraiser Exp' = 'Disabled'
                PcaPatchDbTask                          = 'Disabled'
                PcaWallpaperAppDetect                   = 'Disabled'
                ProgramDataUpdater                      = 'Disabled'
                SdbinstMergeDbTask                      = 'Disabled'
                StartupAppTask                          = 'Disabled'
            }
            Comment  = 'SdbinstMergeDbTask cannot be disabled.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Autochk\'
            Task     = @{
                Proxy = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\CloudExperienceHost\'
            Task     = @{
                CreateObjectTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Customer Experience Improvement Program\'
            Task     = @{
                Consolidator = 'Disabled'
                UsbCeip      = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Device Information\'
            Task     = @{
                Device        = 'Disabled'
                'Device User' = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\DUSM\'
            Task     = @{
                dusmtask = 'Disabled'
            }
            Comment  = 'Data Usage Subscription Management.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Feedback\Siuf\'
            Task     = @{
                DmClient                   = 'Disabled'
                DmClientOnScenarioDownload = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Flighting\FeatureConfig\'
            Task     = @{
                BootstrapUsageDataReporting = 'Disabled'
                ReconcileFeatures           = 'Disabled'
                UsageDataFlushing           = 'Disabled'
                UsageDataReporting          = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\StateRepository\'
            Task     = @{
                MaintenanceTasks = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Maintenance\'
            Task     = @{
                WinSAT = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\NetTrace\'
            Task     = @{
                GatherNetworkInfo = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\PI\'
            Task     = @{
                'Sqm-Tasks' = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Windows Error Reporting\'
            Task     = @{
                QueueReporting = 'Disabled'
            }
        }
    )
}
