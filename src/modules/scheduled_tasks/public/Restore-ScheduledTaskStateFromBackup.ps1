#=================================================================================================================
#                                    Restore Service Startup Type From Backup
#=================================================================================================================

<#
.SYNTAX
    Restore-ScheduledTaskStateFromBackup
        [-FilePath] <string>
        [<CommonParameters>]
#>

function Restore-ScheduledTaskStateFromBackup
{
    <#
    .EXAMPLE
        PS> Restore-ScheduledTaskStateFromBackup

    .EXAMPLE
        PS> Restore-ScheduledTaskStateFromBackup -FilePath "X:\Backup\windows_scheduled_tasks_default.json"
    #>

    [CmdletBinding()]
    param
    (
        [ValidateScript(
            { Test-Path -Path $_ -PathType 'Leaf'},
            ErrorMessage = 'The specified file does not exist or is not accessible.')]
        [string] $FilePath
    )

    process
    {
        $ScheduledTaskBackupFile = "$(Get-LogPath)\windows_default_scheduled_tasks_winmize.json"
        $ScheduledTaskBackup = Get-Content -Raw -Path $ScheduledTaskBackupFile | ConvertFrom-Json -AsHashtable
        $ScheduledTaskBackup | Set-ScheduledTaskState
    }
}
