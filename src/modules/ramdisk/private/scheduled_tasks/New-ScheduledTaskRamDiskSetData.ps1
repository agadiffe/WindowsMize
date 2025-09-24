#=================================================================================================================
#                                       New Scheduled Task RamDisk Set Data
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskRamDiskSetData
        [-FilePath] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskRamDiskSetData
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskRamDiskSetData -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath
    )

    process
    {
        Write-Verbose -Message 'Setting ''RamDisk - Set Data'' Scheduled Task ...'

        $UserName = (Get-LoggedOnUserInfo).UserName
        $TaskName = "RamDisk - Set Data for '$UserName'"
        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $UserName
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
    }
}
