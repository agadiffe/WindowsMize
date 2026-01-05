#=================================================================================================================
#                                         Scheduled Tasks - Miscellaneous
#=================================================================================================================

$ScheduledTasksList += @{
    Miscellaneous = @(
        @{
            TaskPath = '\Microsoft\Windows\.NET Framework\'
            Task     = @{
                '.NET Framework NGEN v4.0.30319'             = 'Disabled' # default: Enabled
                '.NET Framework NGEN v4.0.30319 64'          = 'Disabled' # default: Enabled
                '.NET Framework NGEN v4.0.30319 64 Critical' = 'Disabled' # default: Disabled
                '.NET Framework NGEN v4.0.30319 Critical'    = 'Disabled' # default: Disabled
            }
            Comment  = 'The two Critical tasks are enabled when computer is idle.'
        }
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
            TaskPath = '\Microsoft\Windows\EnterpriseMgmt\'
            Task     = @{
                MDMMaintenenceTask = 'Disabled' # default: Enabled
            }
            Comment  = 'mobile device management.'
        }
        @{
            TaskPath = '\Microsoft\Windows\input\'
            Task     = @{
                InputSettingsRestoreDataAvailable = 'Disabled' # default: Enabled
                LocalUserSyncDataAvailable        = 'Disabled' # default: Enabled
                MouseSyncDataAvailable            = 'Disabled' # default: Enabled
                PenSyncDataAvailable              = 'Disabled' # default: Enabled
                RemoteMouseSyncDataAvailable      = 'Disabled' # default: Enabled
                RemotePenSyncDataAvailable        = 'Disabled' # default: Enabled
                RemoteTouchpadSyncDataAvailable   = 'Disabled' # default: Enabled
                syncpensettings                   = 'Disabled' # default: Enabled
                TouchpadSyncDataAvailable         = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\International\'
            Task     = @{
                'Synchronize Language Settings' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\LanguageComponentsInstaller\'
            Task     = @{
                Installation               = 'Disabled' # default: Enabled
                ReconcileLanguageResources = 'Disabled' # default: Enabled
                Uninstallation             = 'Disabled' # default: Disabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\License Manager\'
            Task     = @{
                TempSignedLicenseExchange = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Management\Provisioning\'
            Task     = @{
                Cellular = 'Disabled' # default: Enabled
                Logon    = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\MUI\'
            Task     = @{
                LPRemove = 'Disabled' # default: Enabled
            }
            Comment  = 'cleanup unused language packs.'
        }
        @{
            TaskPath = '\Microsoft\Windows\NlaSvc\'
            Task     = @{
                WiFiTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\PerformanceTrace\'
            Task     = @{
                RequestTrace = 'Disabled' # default: Enabled
            }
            Comment  = 'take a Shell performance trace (Win+Shift+Control+T).'
        }
        @{
            TaskPath = '\Microsoft\Windows\Printing\'
            Task     = @{
                EduPrintProv        = 'Disabled' # default: Enabled
                PrinterCleanupTask  = 'Disabled' # default: Enabled
                PrintJobCleanupTask = 'Disabled' # default: Disabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Ras\'
            Task     = @{
                MobilityManager = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Registry\'
            Task     = @{
                RegIdleBackup = 'Disabled' # default: Enabled
            }
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
            TaskPath = '\Microsoft\Windows\SpacePort\'
            Task     = @{
                SpaceAgentTask   = 'Disabled' # default: Enabled
                SpaceManagerTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Subscription\'
            Task     = @{
                EnableLicenseAcquisition = 'Disabled' # default: Enabled
                LicenseAcquisition       = 'Disabled' # default: Disabled
            }
            Comment  = 'activation on Azure AD joined devices.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Task Manager\'
            Task     = @{
                Interactive = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\UPnP\'
            Task     = @{
                UPnPHostConfig = 'Disabled' # default: Enabled
            }
            Comment  = 'Set UPnPHost service to Auto-Start.'
        }
        @{
            TaskPath = '\Microsoft\Windows\User Profile Service\'
            Task     = @{
                HiveUploadTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WCM\'
            Task     = @{
                WiFiTask = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WDI\'
            Task     = @{
                ResolutionHost = 'Disabled' # default: Enabled
            }
            Comment  = 'used by the Diagnostic Policy Service.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Windows Media Sharing\'
            Task     = @{
                UpdateLibrary = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WlanSvc\'
            Task     = @{
                CDSSync = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WOF\'
            Task     = @{
                'WIM-Hash-Management' = 'Disabled' # default: Enabled
                'WIM-Hash-Validation' = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WwanSvc\'
            Task     = @{
                NotificationTask = 'Disabled' # default: Enabled
                OobeDiscovery    = 'Disabled' # default: Enabled
            }
        }
    )
}
