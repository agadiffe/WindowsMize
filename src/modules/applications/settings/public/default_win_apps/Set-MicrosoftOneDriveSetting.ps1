#=================================================================================================================
#                                             Set OneDrive
#=================================================================================================================

<#
.SYNTAX
    Set-MicrosoftOneDriveSetting
        [-BackupNotifExplorer {Disabled | Enabled}]
        [-BackupNotifToast {Disabled | Enabled}]
        [-NewUserAutoInstall {Disabled | Enabled}]
        [-RunAtStartup {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MicrosoftOneDriveSetting
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftOneDriveSetting -NewUserAutoInstall 'Disabled' -BackupNotifExplorer 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $BackupNotifExplorer,
        [state] $BackupNotifToast,
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
            'BackupNotifExplorer' { Set-OneDriveBackupNotifExplorer -State $BackupNotifExplorer }
            'BackupNotifToast'    { Set-OneDriveBackupNotifToast -State $BackupNotifToast }
            'NewUserAutoInstall'  { Set-OneDriveNewUserAutoInstall -State $NewUserAutoInstall }
            'RunAtStartup'        { Set-OneDriveRunAtStartup -State $RunAtStartup }
        }
    }
}
