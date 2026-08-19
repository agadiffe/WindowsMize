#=================================================================================================================
#                               System > Power & Battery > Energy Saver - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverSetting
        [-AlwaysOn {Disabled | Enabled}]
        [-AlwaysOnGPO {Enabled | NotConfigured}]
        [-TurnOnAtBatteryLevel <int>]
        [-TurnOnAtBatteryLevelGPO <object>] # <int> (range: 0-100) | NotConfigured
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
        [GpoStateWithoutDisabled] $AlwaysOnGPO,

        [ValidateRange(0, 100)]
        [int] $TurnOnAtBatteryLevel,

        [ValidateIntRangeOrNotConfigured(0, 100)]
        [object] $TurnOnAtBatteryLevelGPO,

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
            'AlwaysOnGPO'             { Set-EnergySaverAlwaysOn -GPO $AlwaysOnGPO }
            'TurnOnAtBatteryLevel'    { Set-EnergySaverTurnOnAtBatteryLevel -Percent $TurnOnAtBatteryLevel }
            'TurnOnAtBatteryLevelGPO' { Set-EnergySaverTurnOnAtBatteryLevel -GPO $TurnOnAtBatteryLevelGPO }
            'LowerScreenBrightness'   { Set-EnergySaverLowerScreenBrightness -State $LowerScreenBrightness }
            'LowerKeyboardBrightness' { Set-EnergySaverLowerKeyboardBrightness -State $LowerKeyboardBrightness }
        }
    }
}
