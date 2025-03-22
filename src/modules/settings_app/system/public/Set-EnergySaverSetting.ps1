#=================================================================================================================
#                               System > Power & Battery > Energy Saver - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverSetting
        [-AlwaysOn {Disabled | Enabled}]
        [-LowerBrightness <int>]
        [-TurnOnAtBatteryLevel <int>]
        [<CommonParameters>]
#>

function Set-EnergySaverSetting
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverSetting -AlwaysOn 'Disabled' -LowerBrightness 70 -TurnOnAtBatteryLevel 42
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AlwaysOn,

        [ValidateRange(0, 100)]
        [int] $LowerBrightness,

        [ValidateRange(0, 100)]
        [int] $TurnOnAtBatteryLevel
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'AlwaysOn'             { Set-EnergySaverAlwaysOn -State $AlwaysOn }
            'LowerBrightness'      { Set-EnergySaverLowerBrightness -Percent $LowerBrightness }
            'TurnOnAtBatteryLevel' { Set-EnergySaverTurnOnAtBatteryLevel -Percent $TurnOnAtBatteryLevel }
        }
    }
}
