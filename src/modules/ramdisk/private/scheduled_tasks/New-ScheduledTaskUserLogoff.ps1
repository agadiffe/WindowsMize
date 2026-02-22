#=================================================================================================================
#                                         New Scheduled Task User Logoff
#=================================================================================================================

<#
.SYNTAX
    New-ScheduledTaskUserLogoff
        [-User] <string>
        [-FilePath] <string>
        [-TaskName] <string>
        [<CommonParameters>]
#>

function New-ScheduledTaskUserLogoff
{
    <#
    .EXAMPLE
        PS> New-ScheduledTaskUserLogoff -User 'Groot' -FilePath 'C:\MyScript.ps1' -TaskName 'MyTaskName'
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
        Write-Verbose -Message "Setting '$TaskName' User Logoff Scheduled Task ..."

        $TaskTrigger = @()
        $RepetitionTrigger = New-ScheduledTaskTrigger -Daily -At '1pm'
        $TaskTrigger += $RepetitionTrigger

        $UserSid = (Get-LoggedOnUserInfo).Sid
        # at event trigger (logoff & shutdow/restart)
        $ClassTrigger = Get-CimClass -ClassName 'MSFT_TaskEventTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Verbose:$false
        $EventTrigger = New-CimInstance -CimClass $ClassTrigger -ClientOnly
        $EventTrigger.Enabled = $true
        $EventTrigger.Subscription = @"
            <QueryList>
              <Query Id="0" Path="System">
                <Select Path="System">
                  *[
                    (
                      System[Provider[@Name='Microsoft-Windows-Winlogon'] and (EventID=7002)] and
                      EventData[Data[@Name='UserSid']='$UserSid']
                    )
                    or
                    (
                      System[Provider[@Name='User32'] and (EventID=1074)]
                    )
                  ]
                </Select>
              </Query>
            </QueryList>
"@
        $TaskTrigger += $EventTrigger
 
        New-ScheduledTaskScript -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
        Set-ScheduledTask -TaskPath '\' -TaskName $TaskName -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) | Out-Null
    }
}
