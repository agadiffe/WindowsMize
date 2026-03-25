#=================================================================================================================
#                                            New Scheduled Task Script
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskScript
        [-FilePath] <string>
        [-Trigger] <ciminstance[]>
        [[-TaskName] <string>]
        [[-RunAsUser] <string>]
        [<CommonParameters>]
#>

function New-ScheduledTaskScript
{
    <#
    .EXAMPLE
        PS> $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        PS> New-ScheduledTaskScript -FilePath 'C:\MyScript.ps1' -Trigger $TaskTrigger

    .EXAMPLE
        PS> $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        PS> New-ScheduledTaskScript -FilePath 'C:\MyScript.ps1' -Trigger $TaskTrigger -TaskName 'MyTaskName' -RunAsUser 'Groot'

    .EXAMPLE
        PS> $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        PS> New-ScheduledTaskScript -FilePath 'C:\MyScript.ps1' -Trigger $TaskTrigger -RunAsUser 'S-1-5-18'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [CimInstance[]] $Trigger,

        [ValidatePattern(
            '^[^/\\:\|<>\?\*"]+$',
            ErrorMessage = 'The TaskName can''t contain these characters: / \ : | < > ? * "')]
        [string] $TaskName = "TempTaskName-$(New-Guid)",

        [string] $RunAsUser = 'S-1-5-18' # 'NT AUTHORITY\SYSTEM'
    )

    process
    {
        $TaskPath = '\'
        $TaskActionParam = @{
            Execute  = 'pwsh.exe'
            Argument = "-NoProfile -ExecutionPolicy Bypass -File ""$FilePath"""
        }
        $TaskAction = New-ScheduledTaskAction @TaskActionParam
        $TaskPrincipal = New-ScheduledTaskPrincipal -UserId $RunAsUser
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
        Register-ScheduledTask @ScheduledTaskParam -Verbose:$false
    }
}
