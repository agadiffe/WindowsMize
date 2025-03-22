#=================================================================================================================
#                                         Services - Diagnostic And Usage
#=================================================================================================================

# Could be considered as telemetry.

$ServicesList += @{
    DiagnosticAndUsage = @(
        @{
            DisplayName = 'Data Usage'
            ServiceName = 'DusmSvc'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'need DPS service running.
                           disable/break:
                           task manager > app history.
                           settings > network & internet > top banner.
                           settings > network & internet > advanced network settngs > data usage (& limit).
                           settings > system > power > top banner battery levels.
                           settings > system > power > battery usage.'
        }
        @{
            DisplayName = 'Diagnostic Policy Service'
            ServiceName = 'DPS'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'cannot be changed with registry editing.
                           disable/break: task manager > processes > network column.
                           network activity will not update and stay at 0 Mbps.'
        }
        @{
            DisplayName = 'Diagnostic Service Host'
            ServiceName = 'WdiServiceHost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Diagnostic System Host'
            ServiceName = 'WdiSystemHost'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'cannot be changed with registry editing.'
        }
        @{
            DisplayName = 'Recommended Troubleshooting Service'
            ServiceName = 'TroubleshootingSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
