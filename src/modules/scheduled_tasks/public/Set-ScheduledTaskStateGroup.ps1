#=================================================================================================================
#                                         Set Scheduled Task State Group
#=================================================================================================================

class ScheduledTasksGroupName : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:ScheduledTasksList.Keys
    }
}

<#
.SYNTAX
    Set-ScheduledTaskStateGroup
        [-Name] {AdobeAcrobat | Diagnostic | Features | MicrosoftOffice | Miscellaneous | Telemetry |
                 UserChoiceProtectionDriver}
        [<CommonParameters>]
#>

function Set-ScheduledTaskStateGroup
{
    <#
    .EXAMPLE
        PS> $TaskToDisable = @(
                'Diagnostic'
                'Features'
                'FilterDrivers'
                'Miscellaneous'
                'Telemetry'
            )
        PS> $TaskToDisable | Set-ScheduledTaskStateGroup
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([ScheduledTasksGroupName])]
        [string] $Name
    )

    process
    {
        $ScheduledTasksList.$Name | Set-ScheduledTaskState
    }
}
