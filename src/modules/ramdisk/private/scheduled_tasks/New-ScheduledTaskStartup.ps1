#=================================================================================================================
#                                           New Scheduled Task Startup
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskStartup
        [-FilePath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskStartup
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskStartup -FilePath 'C:\MyScript.ps1' -TaskName 'MyTaskName'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $TaskName
    )

    process
    {
        Write-Verbose -Message "Setting '$TaskName' Startup Scheduled Task ..."

        $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
    }
}
