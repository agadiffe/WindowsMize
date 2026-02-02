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
        $LogFilePath = @{
            All     = "$(Get-LogPath)\windows_default_scheduled_tasks_all.json"
            WinMize = "$(Get-LogPath)\windows_default_scheduled_tasks_winmize.json"
        }

        if ((Test-Path -Path @($LogFilePath.Values)) -contains $false)
        {
            $AllTasks = Get-ScheduledTask
            $WinMizeScheduledTasks = Get-WinMizeScheduledTask -AllTasks $AllTasks
            foreach ($Key in $LogFilePath.Keys)
            {
                if (-not (Test-Path -Path $LogFilePath.$Key))
                {
                    Write-Verbose -Message "Exporting Default Scheduled Tasks State ($Key) ..."

                    New-ParentPath -Path $LogFilePath.$Key

                    $ScheduledTasks = $Key -eq 'WinMize' ? $WinMizeScheduledTasks : $AllTasks

                    $ScheduledTasks |
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
                        Out-File -FilePath $LogFilePath.$Key
                }
            }
        }
    }
}


<#
.SYNTAX
    Get-WinMizeScheduledTask
        [-AllTasks <CimInstance[]>]
        [<CommonParameters>]
#>

function Get-WinMizeScheduledTask
{
    <#
    .EXAMPLE
        PS> Get-WinMizeScheduledTask

    .EXAMPLE
        PS> $AllTasks = Get-ScheduledTask
        PS> Get-WinMizeScheduledTask -AllTasks $AllTasks
    #>

    [CmdletBinding()]
    param
    (
        [CimInstance[]] $AllTasks
    )

    process
    {
        $TaskRequests = foreach ($Category in $ScheduledTasksList.Values)
        {
            foreach ($Entry in $Category)
            {
                foreach ($TaskName in $Entry.Task.Keys)
                {
                    "$($Entry.TaskPath)$TaskName"
                }
            }
        }

        if (-not $AllTasks)
        {
            $AllTasks = Get-ScheduledTask
        }

        $AllTasks | Where-Object -FilterScript { $TaskRequests -contains "$($_.TaskPath)$($_.TaskName)" }
    }
}
