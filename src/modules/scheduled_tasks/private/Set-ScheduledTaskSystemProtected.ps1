#=================================================================================================================
#                                       Set Scheduled Task System Protected
#=================================================================================================================

<#
.SYNTAX
    Set-ScheduledTaskSystemProtected
        [-State] {Disabled | Enabled}
        [-TaskPath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function Set-ScheduledTaskSystemProtected
{
    <#
    .EXAMPLE
        PS> Set-ScheduledTaskSystemProtected -State 'Disabled' -TaskPath '\Microsoft\Windows\WindowsAI\Recall' -TaskName 'PolicyConfiguration'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State,

        [Parameter(Mandatory)]
        [string] $TaskPath,

        [Parameter(Mandatory)]
        [string] $TaskName
    )

    process
    {
        $OutFile = "$([System.IO.Path]::GetTempPath())\TempScriptContent.ps1"
        $TempTaskName = "TempScript42-$(New-Guid)"
        $TaskCommand = $State -eq 'Enabled' ? 'Enable-ScheduledTask' : 'Disable-ScheduledTask'
        $ScriptContent = "$TaskCommand -TaskPath '$TaskPath' -TaskName '$TaskName' | Out-Null"
        # at task creation/modification
        $TaskTrigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Verbose:$false

        Write-Verbose -Message "Setting '$TaskPath\$TaskName' to '$State' ..."

        $ScriptContent | Out-File -FilePath $OutFile
        New-ScheduledTaskScript -FilePath $OutFile -TaskName $TempTaskName -Trigger $TaskTrigger -Verbose:$false | Out-Null
        Unregister-ScheduledTask -TaskPath '\' -TaskName $TempTaskName -Confirm:$false
        Remove-Item -Path $OutFile
    }
}
