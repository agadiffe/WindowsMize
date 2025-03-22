#=================================================================================================================
#                 System > Power & Battery > Energy Saver > Auto Turn On When Battery Level Is At
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverTurnOnAtBatteryLevel
        [-Percent] <int>
        [<CommonParameters>]
#>

function Set-EnergySaverTurnOnAtBatteryLevel
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverTurnOnAtBatteryLevel -Percent 30
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [int] $Percent
    )

    process
    {
        # default: 30 | never: 0 | always: 100
        $State = switch ($Percent)
        {
            0       { 'Never' }
            100     { 'Always' }
            Default { "$Percent%" }
        }

        Write-Verbose -Message "Setting 'Energy Saver - Auto Turn On When Battery Level Is At' to '$State' ..."
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD $Percent
    }
}
