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
        $TempTaskName = "TempScript42-$(New-Guid)"
        # at task creation/modification
        $TaskTrigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Verbose:$false

        Write-Verbose -Message "Invoking command as SYSTEM ..."
        Write-Verbose -Message "    SYSTEM command begin:"
        Write-Verbose -Message "$Command"
        Write-Verbose -Message "    SYSTEM command end."

        $Command | Out-File -FilePath $OutFile
        New-ScheduledTaskScript -FilePath $OutFile -TaskName $TempTaskName -Trigger $TaskTrigger -Verbose:$false | Out-Null

        while ((Get-ScheduledTask -TaskPath '\' -TaskName $TempTaskName).State -eq 'Running')
        {
            Start-Sleep -Seconds 0.1
        }

        Unregister-ScheduledTask -TaskPath '\' -TaskName $TempTaskName -Confirm:$false
        Remove-Item -Path $OutFile -ErrorAction 'SilentlyContinue'
    }
}
