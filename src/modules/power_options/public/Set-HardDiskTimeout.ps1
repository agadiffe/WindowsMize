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
        [ValidateRange(0, 71582788)]
        [int] $TimeoutMins
    )

    process
    {
        $PowerSourceValue = switch ($PowerSource)
        {
            'PluggedIn' { 'AC' }
            'OnBattery' { 'DC' }
        }

        # value is in minutes
        # never: 0 | default: 20 (PluggedIn), 10 (OnBattery)

        Write-Verbose -Message "Setting 'Hard Disk Timeout ($PowerSource)' to '$TimeoutMins min(s)' ..."
        powercfg.exe -Change Disk-Timeout-$PowerSourceValue $TimeoutMins
    }
}
