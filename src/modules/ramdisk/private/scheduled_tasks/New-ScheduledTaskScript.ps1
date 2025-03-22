#=================================================================================================================
#                                            New Scheduled Task Script
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskScript
        [-FilePath] <string>
        [-TaskName] <string>
        [-Trigger] <ciminstance>
        [<CommonParameters>]
#>

function New-ScheduledTaskScript
{
    <#
    .EXAMPLE
        PS> $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        PS> New-ScheduledTaskScript -FilePath 'C:\MyScript.ps1' -TaskName 'MyTaskName' -Trigger $TaskTrigger
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $TaskName,

        [Parameter(Mandatory)]
        [CimInstance] $Trigger
    )

    process
    {
        $TaskPath = '\'
        $TaskActionParam = @{
            Execute  = 'pwsh.exe'
            Argument = "-NoProfile -ExecutionPolicy Bypass -File ""$FilePath"""
        }
        $TaskAction = New-ScheduledTaskAction @TaskActionParam
        $SystemSID = 'S-1-5-18' # 'NT AUTHORITY\SYSTEM'
        $TaskPrincipal = New-ScheduledTaskPrincipal -UserID $SystemSID
        $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

        $ScheduledTaskParam = @{
            TaskName  = $TaskName
            TaskPath  = $TaskPath
            Action    = $TaskAction
            Trigger   = $Trigger
            Principal = $TaskPrincipal
            Settings  = $TaskSettings
        }

        Unregister-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Confirm:$false -ErrorAction 'SilentlyContinue'
        Register-ScheduledTask @ScheduledTaskParam -Verbose:$false | Out-Null
    }
}
