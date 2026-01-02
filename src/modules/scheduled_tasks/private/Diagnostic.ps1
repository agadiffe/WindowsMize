#=================================================================================================================
#                                          Scheduled Tasks - Diagnostic
#=================================================================================================================

$ScheduledTasksList += @{
    Diagnostic = @(
        @{
            SkipTask = $true
            TaskPath = '\Microsoft\Windows\Chkdsk\'
            Task     = @{
                ProactiveScan = 'Disabled' # default: Enabled
            }
            Comment  = 'check disk Health at startup (S.M.A.R.T).'
        }
        @{
            TaskPath = '\Microsoft\Windows\Data Integrity Scan\'
            Task     = @{
                'Data Integrity Check And Scan'          = 'Disabled' # default: Enabled
                'Data Integrity Scan'                    = 'Disabled' # default: Enabled
                'Data Integrity Scan for Crash Recovery' = 'Disabled' # default: Enabled
            }
            Comment  = 'ReFS related. Do nothing on NTFS.'
        }
        @{
            TaskPath = '\Microsoft\Windows\Diagnosis\'
            Task     = @{
                RecommendedTroubleshootingScanner = 'Disabled' # default: Enabled
                Scheduled                         = 'Disabled' # default: Enabled
                UnexpectedCodepath                = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\DiskDiagnostic\'
            Task     = @{
                'Microsoft-Windows-DiskDiagnosticDataCollector' = 'Disabled' # default: Enabled
                'Microsoft-Windows-DiskDiagnosticResolver'      = 'Disabled' # default: Disabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\DiskFootprint\'
            Task     = @{
                Diagnostics = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\MemoryDiagnostic\'
            Task     = @{
                AutomaticOfflineMemoryDiagnostic = 'Disabled' # default: Disabled
                ProcessMemoryDiagnosticEvents    = 'Disabled' # default: Enabled
                RunFullMemoryDiagnostic          = 'Disabled' # default: Disabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Power Efficiency Diagnostics\'
            Task     = @{
                AnalyzeSystem = 'Disabled' # default: Enabled
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\RecoveryEnvironment\'
            Task     = @{
                VerifyWinRE = 'Disabled' # default: Disabled
            }
        }
    )
}
