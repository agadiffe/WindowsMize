#=================================================================================================================
#                                            Invoke Command As System
#=================================================================================================================

<#
.SYNTAX
    Invoke-CommandAsSystem
        [-Command] <string>
        [<CommonParameters>]
#>

function Invoke-CommandAsSystem
{
    <#
    .EXAMPLE
        PS> Invoke-CommandAsSystem -Command "Remove-Item -Path 'X:\ProtectedPath\file.txt'"
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Command
    )

    process
    {
        $OutFile = "$([System.IO.Path]::GetTempPath())\TempScriptContent.ps1"
        $TaskTriggerParam = @{
            ClassName = 'MSFT_TaskRegistrationTrigger' # at task creation/modification
            Namespace = 'Root/Microsoft/Windows/TaskScheduler'
        }
        $TaskTrigger = Get-CimClass @TaskTriggerParam -Verbose:$false

        Write-Verbose -Message "Invoking command as SYSTEM ..."
        Write-Verbose -Message "    SYSTEM command begin:"
        Write-Verbose -Message "$Command"
        Write-Verbose -Message "    SYSTEM command end."

        $Command | Out-File -FilePath $OutFile
        $TaskData = New-ScheduledTaskScript -FilePath $OutFile -Trigger $TaskTrigger -Verbose:$false

        while ((Get-ScheduledTask -TaskPath $TaskData.TaskPath -TaskName $TaskData.TaskName).State -eq 'Running')
        {
            Start-Sleep -Seconds 0.1
        }

        Unregister-ScheduledTask -TaskPath $TaskData.TaskPath -TaskName $TaskData.TaskName -Confirm:$false
        Remove-Item -Path $OutFile -ErrorAction 'SilentlyContinue'
    }
}
