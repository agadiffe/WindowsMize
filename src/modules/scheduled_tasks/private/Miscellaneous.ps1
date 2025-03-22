#=================================================================================================================
#                                         Scheduled Tasks - Miscellaneous
#=================================================================================================================

$ScheduledTasksList += @{
    Miscellaneous = @(
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\Chkdsk\'
            Task     = @{
                ProactiveScan = 'Disabled'
            }
            Comment  = 'should be disabled ?'
        }
        @{
            TaskPath = '\Microsoft\Windows\Data Integrity Scan\'
            Task     = @{
                'Data Integrity Check And Scan'          = 'Disabled'
                'Data Integrity Scan'                    = 'Disabled'
                'Data Integrity Scan for Crash Recovery' = 'Disabled'
            }
            Comment  = 'apply to ReFS volumes with integrity streams enabled.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Diagnosis\'
            Task     = @{
                RecommendedTroubleshootingScanner = 'Disabled'
                Scheduled                         = 'Disabled'
                UnexpectedCodepath                = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Input\'
            Task     = @{
                InputSettingsRestoreDataAvailable = 'Disabled'
                LocalUserSyncDataAvailable        = 'Disabled'
                MouseSyncDataAvailable            = 'Disabled'
                PenSyncDataAvailable              = 'Disabled'
                syncpensettings                   = 'Disabled'
                TouchpadSyncDataAvailable         = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\International\'
            Task     = @{
                'Synchronize Language Settings' = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\LanguageComponentsInstaller\'
            Task     = @{
                Installation               = 'Disabled'
                ReconcileLanguageResources = 'Disabled'
                Uninstallation             = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\License Manager\'
            Task     = @{
                TempSignedLicenseExchange = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Management\Provisioning\'
            Task     = @{
                Cellular = 'Disabled'
                Logon    = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Windows Media Sharing\'
            Task     = @{
                UpdateLibrary = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\MUI\'
            Task     = @{
                LPRemove = 'Disabled'
            }
            Comment  = 'cleanup unused language packs.'
        }
        @{
            TaskPath = '\Microsoft\Windows\NlaSvc\'
            Task     = @{
                WiFiTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Ras\'
            Task     = @{
                MobilityManager = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\RecoveryEnvironment\'
            Task     = @{
                VerifyWinRE = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\ReFsDedupSvc\'
            Task     = @{
                Initialization = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Registry\'
            Task     = @{
                RegIdleBackup = 'Disabled'
            }
        }
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\Servicing\'
            Task     = @{
                StartComponentCleanup = 'Disabled'
            }
            Comment  = 'clean Up the WinSxS Folder.'
        }
        @{
            TaskPath = '\Microsoft\Windows\SpacePort\'
            Task     = @{
                SpaceAgentTask   = 'Disabled'
                SpaceManagerTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Speech\'
            Task     = @{
                SpeechModelDownloadTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Storage Tiers Management\'
            Task     = @{
                'Storage Tiers Management Initialization' = 'Disabled'
                'Storage Tiers Optimization'              = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Subscription\'
            Task     = @{
                EnableLicenseAcquisition = 'Disabled'
                LicenseAcquisition       = 'Disabled'
            }
            Comment  = 'activation on Azure AD joined devices.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Task Manager\'
            Task     = @{
                Interactive = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\TextServicesFramework\'
            Task     = @{
                MsCtfMonitor = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\UPnP\'
            Task     = @{
                UPnPHostConfig = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\User Profile Service\'
            Task     = @{
                HiveUploadTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WDI\'
            Task     = @{
                ResolutionHost = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Windows Filtering Platform\'
            Task     = @{
                BfeOnServiceStartTypeChange = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WOF\'
            Task     = @{
                'WIM-Hash-Management' = 'Disabled'
                'WIM-Hash-Validation' = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WwanSvc\'
            Task     = @{
                NotificationTask = 'Disabled'
                OobeDiscovery    = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Printing\'
            Task     = @{
                EduPrintProv        = 'Disabled'
                PrinterCleanupTask  = 'Disabled'
                PrintJobCleanupTask = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WlanSvc\'
            Task     = @{
                CDSSync = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\WCM\'
            Task     = @{
                WiFiTask = 'Disabled'
            }
        }
    )
}
