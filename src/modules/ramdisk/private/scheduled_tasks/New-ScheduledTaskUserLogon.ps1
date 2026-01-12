#=================================================================================================================
#                                          New Scheduled Task User Logon
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskUserLogon
        [-FilePath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskUserLogon
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskUserLogon -FilePath 'C:\MyScript.ps1' -TaskName 'RamDisk - Set Data'
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
        Write-Verbose -Message "Setting '$TaskName' User Logon Scheduled Task ..."

        $UserName = (Get-LoggedOnUserInfo).UserName
        $TaskName = "$TaskName ($UserName)"
        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $UserName
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
    }
}
