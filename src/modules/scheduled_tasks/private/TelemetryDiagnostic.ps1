#=================================================================================================================
#                                     Scheduled Tasks - Telemetry Diagnostic
#=================================================================================================================

$ScheduledTasksList += @{
    TelemetryDiagnostic = @(
        @{
            TaskPath = '\Microsoft\Windows\DiskDiagnostic\'
            Task     = @{
                'Microsoft-Windows-DiskDiagnosticDataCollector' = 'Disabled'
                'Microsoft-Windows-DiskDiagnosticResolver'      = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\DiskFootprint\'
            Task     = @{
                Diagnostics = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\MemoryDiagnostic\'
            Task     = @{
                ProcessMemoryDiagnosticEvents = 'Disabled'
                RunFullMemoryDiagnostic       = 'Disabled'
            }
        }
        @{
            TaskPath = '\Microsoft\Windows\Power Efficiency Diagnostics\'
            Task     = @{
                AnalyzeSystem = 'Disabled'
            }
        }
    )
}
