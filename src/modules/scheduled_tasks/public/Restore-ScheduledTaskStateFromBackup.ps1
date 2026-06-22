#=================================================================================================================
#                                    Restore Scheduled Tasks State From Backup
#=================================================================================================================

<#
.SYNTAX
    Restore-ScheduledTaskStateFromBackup
        [[-FilePath] <string>]
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
        [string] $FilePath = "$(Get-LogPath)\windows_default_scheduled_tasks_winmize.json"
    )

    process
    {
        if (-not (Test-Path -Path $FilePath -PathType 'Leaf'))
        {
            Write-Error -Message 'The specified file does not exist or is not accessible.'
            return
        }

        $ScheduledTaskBackup = Get-Content -Raw -Path $FilePath | ConvertFrom-Json -AsHashtable
        $ScheduledTaskBackup | Set-ScheduledTaskState
    }
}
