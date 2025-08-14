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
            DisplayName = 'Cloud Backup and Restore Service'
            ServiceName = 'CloudBackupRestoreSvc'
            StartupType = 'Disabled'
            DefaultType = 'Manual'
            Comment     = 'Windows Backup.'
        }
        @{
            DisplayName = 'Microsoft Software Shadow Copy Provider'
            ServiceName = 'swprv'
            StartupType = 'Manual'
            DefaultType = 'Manual'
            Comment     = 'needed by Windows Backup and System Restore.'
        }
        @{
            DisplayName = 'Volume Shadow Copy'
            ServiceName = 'VSS'
            StartupType = 'Manual'
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
