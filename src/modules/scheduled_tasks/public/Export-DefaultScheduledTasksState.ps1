#=================================================================================================================
#                                      Export Default Scheduled Tasks State
#=================================================================================================================

<#
.SYNTAX
    Export-DefaultScheduledTasksState [<CommonParameters>]
#>

function Export-DefaultScheduledTasksState
{
    [CmdletBinding()]
    param ()

    process
    {
        $ScheduledTasks = @{
            All     = @{
                LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_scheduled_tasks_all.json"
                GetData     = 'Get-ScheduledTask'
            }
            WinMize = @{
                LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_scheduled_tasks_winmize.json"
                GetData     = '$ScheduledTasksList.Values |
                    ForEach-Object -Process {
                        Get-ScheduledTask -TaskPath $_.TaskPath -TaskName $_.Task.Keys -ErrorAction SilentlyContinue
                    }'
            }
        }

        foreach ($Key in $ScheduledTasks.Keys)
        {
            if (-not (Test-Path -Path $ScheduledTasks.$Key.LogFilePath))
            {
                Write-Verbose -Message "Exporting Default Scheduled Tasks State ($Key) ..."

                New-ParentPath -Path $ScheduledTasks.$Key.LogFilePath

                (Invoke-Expression -Command $ScheduledTasks.$Key.GetData) |
                    Group-Object -Property 'TaskPath' |
                    ForEach-Object -Process {
                        $TaskDictionary = [ordered]@{}
                        $_.Group |
                            ForEach-Object -Process {
                                $TaskState = $_.State -eq 'Disabled' ? 'Disabled' : 'Enabled'
                                $TaskDictionary.$($_.TaskName) = $TaskState
                            }

                        [ordered]@{
                            TaskPath = $_.Name
                            Task     = $TaskDictionary
                        }
                    } |
                    ConvertTo-Json -EnumsAsStrings |
                    Out-File -FilePath $ScheduledTasks.$Key.LogFilePath
            }
        }
    }
}
