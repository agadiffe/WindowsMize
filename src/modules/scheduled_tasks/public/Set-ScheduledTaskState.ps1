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
        PS> $ScheduledTaskBackupFile = 'X:\Backup\windows_default_scheduled_tasks_winmize.json'
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
                  "Bar Update Task": "Disabled"
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
                $AllowedKeyValues = 'Disabled', 'Enabled'
                $_.Task.Values | Where-Object -FilterScript { $AllowedKeyValues -contains $_ }
            },
            ErrorMessage = "Invalid value(s) in the 'Task' hashtable. All values must be either 'Disabled' or 'Enabled'.")]
        [WinScheduledTask] $InputObject
    )

    begin
    {
        $ScheduledTasks = Get-ScheduledTask
        $AllowedProtectedTaskToBeChanged = @(
            '\Microsoft\Windows\Application Experience\SdbinstMergeDbTask'
            '\Microsoft\Windows\UsageAndQualityInsights\UsageAndQualityInsights-MaintenanceTask'
            '\Microsoft\Windows\WindowsAI\Recall\InitialConfiguration'
            '\Microsoft\Windows\WindowsAI\Recall\PolicyConfiguration'
            '\Microsoft\Windows\WindowsAI\Settings\InitialConfiguration'
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

                try
                {
                    switch ($Task.Value)
                    {
                        'Enabled'  { $CurrentTask | Enable-ScheduledTask -ErrorAction 'Stop' | Out-Null }
                        'Disabled' { $CurrentTask | Disable-ScheduledTask -ErrorAction 'Stop' | Out-Null }
                    }  
                }
                catch
                {
                    if ($AllowedProtectedTaskToBeChanged -contains "$($CurrentTask.TaskPath)$($CurrentTask.TaskName)")
                    {
                        Write-Verbose -Message '    system protected task: editing with SYSTEM privileges ...'

                        $TaskCommand = $Task.Value -eq 'Enabled' ? 'Enable-ScheduledTask' : 'Disable-ScheduledTask'
                        $Command = "$TaskCommand -TaskPath '$($CurrentTask.TaskPath)' -TaskName '$($CurrentTask.TaskName)' | Out-Null"
                        Invoke-CommandAsSystem -Command $Command -Verbose:$false
                    }
                    else
                    {
                        Write-Verbose -Message "    cannot be $($Task.Value)."
                    }
                }
            }
        }
    }
}
