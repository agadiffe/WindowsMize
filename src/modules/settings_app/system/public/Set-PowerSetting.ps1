#=================================================================================================================
#                                       System > Power & Battery - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-PowerSetting
        [-BatteryPercentage {Disabled | Enabled}]
        [<CommonParameters>]

    Set-PowerSetting
        -PowerMode {BestPowerEfficiency | Balanced | BestPerformance}
        [-PowerSource {PluggedIn | OnBattery}]
        [<CommonParameters>]

    Set-PowerSetting
        -PowerState {Screen | Sleep | Hibernate}
        -Timeout <int>
        -PowerSource {PluggedIn | OnBattery}
        [<CommonParameters>]

    Set-PowerSetting
        -ButtonControls {PowerButton | SleepButton | LidClose}
        -Action {DoNothing | Sleep | Hibernate | ShutDown | DisplayOff}
        -PowerSource {PluggedIn | OnBattery}
        [<CommonParameters>]
#>

function Set-PowerSetting
{
    <#
    .EXAMPLE
        PS> Set-PowerSetting -BatteryPercentage 'Disabled'

    .EXAMPLE
        PS> Set-PowerSetting -PowerMode 'BestPowerEfficiency' -PowerSource 'OnBattery'

    .EXAMPLE
        PS> Set-PowerSetting -PowerState 'Sleep' -Timeout 10 -PowerSource 'PluggedIn'

    .EXAMPLE
        PS> Set-PowerSetting -ButtonControls 'LidClose' -Action 'Sleep' -PowerSource 'OnBattery'
    #>

    [CmdletBinding(DefaultParameterSetName = 'GeneralSettings')]
    param
    (
        [Parameter(ParameterSetName = 'GeneralSettings')]
        [state] $BatteryPercentage,

        [Parameter(Mandatory, ParameterSetName = 'PowerMode')]
        [PowerMode] $PowerMode,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [PowerState] $PowerState,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [ValidateRange('NonNegative')]
        [int] $Timeout,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ButtonControls')]
        [ButtonControls] $ButtonControls,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ButtonControls')]
        [PowerAction] $Action,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'PowerMode')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ButtonControls')]
        [PowerSource] $PowerSource
    )

    process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'GeneralSettings'
            {
                if (-not $PSBoundParameters.Keys.Count)
                {
                    Write-Error -Message (Write-InsufficientParameterCount)
                    return
                }

                switch ($PSBoundParameters.Keys)
                {
                    'BatteryPercentage' { Set-PowerBatteryPercentage -State $BatteryPercentage }
                }
            }
            'PowerMode'
            {
                if ($PSBoundParameters.ContainsKey('PowerSource'))
                {
                    Set-PowerMode -Value $PowerMode -PowerSource $PowerSource
                }
                else
                {
                    Set-PowerMode -Value $PowerMode
                }
            }
            'PowerStateTimeout' { Set-PowerStateTimeout -Name $PowerState -Timeout $Timeout -PowerSource $PowerSource }
            'ButtonControls'    { Set-PowerButtonControls -Name $ButtonControls -Action $Action -PowerSource $PowerSource }
        }
    }
}
