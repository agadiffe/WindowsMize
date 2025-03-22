#=================================================================================================================
#                                       New Scheduled Task RamDisk Creation
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskRamDiskCreation
        [-FilePath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskRamDiskCreation
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskRamDiskCreation -FilePath 'C:\MyScript.ps1' -TaskName 'MyTaskName'
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
        Write-Verbose -Message "Setting '$TaskName' Scheduled Task ..."

        $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
    }
}
