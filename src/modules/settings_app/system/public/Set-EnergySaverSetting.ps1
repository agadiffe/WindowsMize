#=================================================================================================================
#                               System > Power & Battery > Energy Saver - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverSetting
        [-AlwaysOn {Disabled | Enabled}]
        [-TurnOnAtBatteryLevel <int>]
        [-LowerScreenBrightness {Disabled | Enabled}]
        [-LowerKeyboardBrightness {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-EnergySaverSetting
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverSetting -AlwaysOn 'Disabled' -LowerScreenBrightness 'Enabled' -TurnOnAtBatteryLevel 42
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AlwaysOn,

        [ValidateRange(0, 100)]
        [int] $TurnOnAtBatteryLevel,

        [state] $LowerScreenBrightness,

        [state] $LowerKeyboardBrightness
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
            'AlwaysOn'                { Set-EnergySaverAlwaysOn -State $AlwaysOn }
            'TurnOnAtBatteryLevel'    { Set-EnergySaverTurnOnAtBatteryLevel -Percent $TurnOnAtBatteryLevel }
            'LowerScreenBrightness'   { Set-EnergySaverLowerScreenBrightness -State $LowerScreenBrightness }
            'LowerKeyboardBrightness' { Set-EnergySaverLowerKeyboardBrightness -State $LowerKeyboardBrightness }
        }
    }
}
