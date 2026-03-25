#=================================================================================================================
#                                          New Scheduled Task User Logon
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskUserLogon
        [-User] <string>
        [-FilePath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskUserLogon
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskUserLogon -User 'Groot' -FilePath 'C:\MyScript.ps1' -TaskName 'MyTaskName'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $User,

        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $TaskName
    )

    process
    {
        Write-Verbose -Message "Setting '$TaskName' User Logon Scheduled Task ..."

        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $User
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger | Out-Null
    }
}
