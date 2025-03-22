#=================================================================================================================
#                                  Services - Windows Backup And System Restore
#=================================================================================================================

$ServicesList += @{
    WindowsBackupAndSystemRestore = @(
        @{
            DisplayName = 'Block Level Backup Engine Service'
            ServiceName = 'wbengine'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'File History Service'
            ServiceName = 'fhsvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
        @{
            DisplayName = 'Microsoft Software Shadow Copy Provider'
            ServiceName = 'swprv'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed by Windows Backup and System Restore.'
        }
        @{
            DisplayName = 'Volume Shadow Copy'
            ServiceName = 'VSS'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'needed by Windows Backup and System Restore.'
        }
        @{
            DisplayName = 'Windows Backup'
            ServiceName = 'SDRSVC'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
        }
    )
}
