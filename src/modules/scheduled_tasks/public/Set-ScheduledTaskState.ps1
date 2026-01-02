#=================================================================================================================
#                                            Set Scheduled Task State
#=================================================================================================================

class WinScheduledTask
{
    [bool] $SkipTask
    [string] $TaskPath
    [hashtable] $Task
    [string] $Comment
}

<#
.SYNTAX
    Set-ScheduledTaskState
        [-InputObject] <WinScheduledTask>
        [<CommonParameters>]
#>

function Set-ScheduledTaskState
{
    <#
    .EXAMPLE
        PS> $ScheduledTaskBackupFile = "X:\Backup\windows_default_scheduled_tasks_winmize.txt"
        PS> $ScheduledTaskBackup = Get-Content -Raw -Path $ScheduledTaskBackupFile | ConvertFrom-Json -AsHashtable
        PS> $ScheduledTaskBackup | Set-ScheduledTaskState

    .EXAMPLE
        PS> $FooBarTasks = '[
              {
                "TaskPath": "\\",
                "Task": {
                  "Foo Update Task": "Enabled",
                  "Foo Logging Task": "Disabled"
                }
              },
              {
                "SkipTask": true,
                "TaskPath": "\\",
                "Task": {
                  "Bar Update Task: "Disabled""
                },
                "Comment": "some comment"
              }
            ]' | ConvertFrom-Json -AsHashtable
        PS> $FooBarTasks | Set-ScheduledTaskState
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateScript(
            {
                $AllowedKeyValue = 'Disabled', 'Enabled'
                $_.Task.Values | Where-Object -FilterScript { $AllowedKeyValue -contains $_ }
            },
            ErrorMessage = "Invalid value(s) in the 'Task' hashtable. All values must be either 'Disabled' or 'Enabled'.")]
        [WinScheduledTask] $InputObject
    )

    begin
    {
        $ScheduledTasks = Get-ScheduledTask
        $AllowedTaskToBeDeleted = @(
            'SdbinstMergeDbTask'
            'UsageAndQualityInsights-MaintenanceTask'
        )
    }

    process
    {
        if ($InputObject.SkipTask)
        {
            return
        }

        if (-not $InputObject.TaskPath.EndsWith('\'))
        {
            $InputObject.TaskPath += '\'
        }

        foreach ($Task in $InputObject.Task.GetEnumerator())
        {
            $CurrentTask = $ScheduledTasks |
                Where-Object -FilterScript {
                    $_.TaskPath -eq $InputObject.TaskPath -and
                    $_.TaskName -eq $Task.Key
                }

            $CurrentTaskState = $CurrentTask.State -eq 'Disabled' ? 'Disabled' : 'Enabled'

            if (-not $CurrentTask)
            {
                Write-Verbose -Message "Scheduled Task '$($InputObject.TaskPath)$($Task.Key)' not found"
            }
            elseif ($CurrentTaskState -eq $Task.Value)
            {
                Write-Verbose -Message "'$($InputObject.TaskPath)$($Task.Key)' is already '$CurrentTaskState'"
            }
            else
            {
                Write-Verbose -Message "Setting '$($InputObject.TaskPath)$($Task.Key)' to '$($Task.Value)' ..."

                switch ($Task.Value)
                {
                    'Enabled'
                    {
                        $CurrentTask | Enable-ScheduledTask | Out-Null
                    }
                    'Disabled'
                    {
                        try
                        {
                            $CurrentTask | Disable-ScheduledTask -ErrorAction 'Stop' | Out-Null
                        }
                        catch
                        {
                            if ($AllowedTaskToBeDeleted -contains $CurrentTask.TaskName)
                            {
                                Write-Verbose -Message '    cannot be disabled: deleting task ...'
                                $CurrentTask | Unregister-ScheduledTask -Confirm:$false | Out-Null
                            }
                            else
                            {
                                Write-Verbose -Message '    cannot be disabled.'
                            }
                        }
                    }
                }
            }
        }
    }
}
