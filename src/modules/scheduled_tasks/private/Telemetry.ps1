#=================================================================================================================
#                                           Scheduled Tasks - Telemetry
#=================================================================================================================

$ScheduledTasksList += @{
    Telemetry = @(
        @{
            TaskPath = '\Microsoft\Windows\Application Experience\'
            Task     = @{
                MareBackup                              = 'Disabled' # default: Enabled
                'Microsoft Compatibility Appraiser'     = 'Disabled' # default: Enabled
                'Microsoft Compatibility Appraiser Exp' = 'Disabled' # default: Enabled
                PcaPatchDbTask                          = 'Disabled' # default: Enabled
                PcaWallpaperAppDetect                   = 'Disabled' # default: Enabled
                ProgramDataUpdater                      = 'Disabled' # default: Enabled
                SdbinstMergeDbTask                      = 'Disabled' # default: Enabled
                StartupAppTask                          = 'Disabled' # default: Enabled
            }
            Comment  = 'SdbinstMergeDbTask cannot be disabled.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Autochk\'
            Task     = @{
                Proxy = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\CloudExperienceHost\'
            Task     = @{
                CreateObjectTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Customer Experience Improvement Program\'
            Task     = @{
                Consolidator = 'Disabled' # default: Enabled
                UsbCeip      = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Device Information\'
            Task     = @{
                Device        = 'Disabled' # default: Enabled
                'Device User' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\DUSM\'
            Task     = @{
                dusmtask = 'Disabled' # default: Enabled
            }
            Comment  = 'Data Usage Subscription Management.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Feedback\Siuf\'
            Task     = @{
                DmClient                   = 'Disabled' # default: Enabled
                DmClientOnScenarioDownload = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Flighting\FeatureConfig\'
            Task     = @{
                BootstrapUsageDataReporting    = 'Disabled' # default: Disabled
                GovernedFeatureUsageProcessing = 'Disabled' # default: Enabled
                ReconcileConfigs               = 'Disabled' # default: Enabled
                ReconcileFeatures              = 'Disabled' # default: Enabled
                UsageDataFlushing              = 'Disabled' # default: Enabled
                UsageDataReceiver              = 'Disabled' # default: Enabled
                UsageDataReporting             = 'Disabled' # default: Enabled
            }
            Comment  = 'FeatureConfig tasks (reconciles feature flags, processes/collects feature usage telemetry).
                        Disabling prevents feature overrides from being reverted and reduces telemetry.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Flighting\OneSettings\'
            Task     = @{
                RefreshCache = 'Disabled' # default: Enabled
            }
            Comment  = 'Config/experiments refresh (feature rollouts and configuration updates).
                        Also collects and reports telemetry data back to Microsoft.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Maintenance\'
            Task     = @{
                WinSAT = 'Disabled' # default: Enabled
            }
            Comment  = 'Measures system performance and capabilities.'
        }
        @{
            TaskPath = '\Microsoft\Windows\NetTrace\'
            Task     = @{
                GatherNetworkInfo = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\PI\'
            Task     = @{
                'Sqm-Tasks' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\StateRepository\'
            Task     = @{
                MaintenanceTasks = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Sustainability\'
            Task     = @{
                PowerGridForecastTask   = 'Disabled' # default: Enabled
                SustainabilityTelemetry = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\TextServicesFramework\'
            Task     = @{
                MsCtfMonitor = 'Disabled' # default: Enabled
            }
            Comment  = 'keylogger and typing for Store apps ?'
        }
        @{
            TaskPath = '\Microsoft\Windows\UsageAndQualityInsights\'
            Task     = @{
                'UsageAndQualityInsights-MaintenanceTask' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Windows Error Reporting\'
            Task     = @{
                QueueReporting = 'Disabled' # default: Enabled
            }
        }
    )
}
