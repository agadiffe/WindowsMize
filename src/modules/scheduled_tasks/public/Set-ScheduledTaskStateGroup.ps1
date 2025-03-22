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
        [-Name] {AdobeAcrobat | Features | MicrosoftEdge | MicrosoftOffice | Miscellaneous | Telemetry |
                 TelemetryDiagnostic | UserChoiceProtectionDriver}
        [<CommonParameters>]
#>

function Set-ScheduledTaskStateGroup
{
    <#
    .EXAMPLE
        PS> $TaskToDisable = @(
                'Features'
                'FilterDrivers'
                'Miscellaneous'
                'Telemetry'
                'TelemetryDiagnostic'
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
