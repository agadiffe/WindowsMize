#=================================================================================================================
#                                            Power Options - Hibernate
#=================================================================================================================

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
#   > change advanced power settings > hard disk > turn off hard disk after

<#
.SYNTAX
    Set-HardDiskTimeout
        [-PowerSource] {PluggedIn | OnBattery}
        [-TimeoutMins] <int>
        [<CommonParameters>]
#>

function Set-HardDiskTimeout
{
    <#
    .EXAMPLE
        PS> Set-HardDiskTimeout -PowerSource 'PluggedIn' -TimeoutMins 42
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PowerSourceMode] $PowerSource,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(0, 1193046)]
        [int] $TimeoutMins
    )

    process
    {
        # SUB_DISK: '0012ee47-9041-4b5d-9b77-535fba8b1442'
        # DISKIDLE: '6738e2c4-e8a5-4a42-b16a-e040e769756e'

        Write-Verbose -Message "Setting 'Hard Disk Timeout ($PowerSource)' to '$TimeoutMins min(s)' ..."

        $PowerPlanGUID = Get-PowerPlanGUID
        $SetValueIndex = $PowerSource -eq 'PluggedIn' ? '-SetACValueIndex' : '-SetDCValueIndex'
        $Value = $TimeoutMins * 60

        foreach ($GUID in $PowerPlanGUID)
        {
            # value is in minutes
            # never: 0 | default: 20 (PluggedIn), 10 (OnBattery)
            powercfg.exe $SetValueIndex $GUID SUB_DISK DISKIDLE $Value
        }
    }
}
