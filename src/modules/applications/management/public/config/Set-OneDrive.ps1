#=================================================================================================================
#                                             Set OneDrive
#=================================================================================================================

<#
.SYNTAX
    Set-OneDrive
        [-BackupNotifExplorer {Disabled | Enabled}]
        [-BackupNotifToast {Disabled | Enabled}]
        [-BackupNotifStartMenuAndSettingsApp {Disabled | Enabled}]
        [-NewUserAutoInstall {Disabled | Enabled}]
        [-RunAtStartup {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-OneDrive
{
    <#
    .EXAMPLE
        PS> Set-OneDrive -NewUserAutoInstall 'Disabled' -BackupNotifExplorer 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $BackupNotifExplorer,
        [state] $BackupNotifToast,
        [state] $BackupNotifStartMenuAndSettingsApp,
        [state] $NewUserAutoInstall,
        [state] $RunAtStartup
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'BackupNotifExplorer'                { Set-OneDriveBackupNotifExplorer -State $BackupNotifExplorer }
            'BackupNotifToast'                   { Set-OneDriveBackupNotifToast -State $BackupNotifToast }
            'BackupNotifStartMenuAndSettingsApp' { Set-OneDriveBackupNotifStartMenuAndSettingsApp -State $BackupNotifStartMenuAndSettingsApp }
            'NewUserAutoInstall'                 { Set-OneDriveNewUserAutoInstall -State $NewUserAutoInstall }
            'RunAtStartup'                       { Set-OneDriveRunAtStartup -State $RunAtStartup }
        }
    }
}
