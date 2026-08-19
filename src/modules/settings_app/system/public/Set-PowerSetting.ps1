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
        -PowerSource {PluggedIn | OnBattery}
        [-TimeoutMins <int>]
        [-TimeoutMinsGPO <object>] # <int> (range: 0-35791394) | NotConfigured
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
        PS> Set-PowerSetting -PowerState 'Sleep' -PowerSource 'PluggedIn' -TimeoutMins 10
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

        [Parameter(ParameterSetName = 'PowerMode')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [PowerSource] $PowerSource,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [ValidateIntRangeOrNotConfigured(0, 35791394)]
        [int] $TimeoutMins,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [ValidateIntRangeOrNotConfigured(0, 35791394)]
        [object] $TimeoutMinsGPO
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
                    Set-PowerMode -Mode $PowerMode -PowerSource $PowerSource
                }
                else
                {
                    Set-PowerMode -Mode $PowerMode
                }
            }
            'PowerStateTimeout'
            {
                if (-not $PSBoundParameters.ContainsKey('TimeoutMins') -and -not $PSBoundParameters.ContainsKey('TimeoutMinsGPO'))
                {
                    Write-Error -Message ((Write-InsufficientParameterCount) +
                                         ' Specify at least the ''TimeoutMins'' or ''TimeoutMinsGPO'' parameter.')
                    return
                }

                switch ($PSBoundParameters.Keys)
                {
                    'TimeoutMins'    { Set-PowerStateTimeout -Name $PowerState -PowerSource $PowerSource -TimeoutMins $TimeoutMins }
                    'TimeoutMinsGPO' { Set-PowerStateTimeout -Name $PowerState -PowerSource $PowerSource -GPO $TimeoutMinsGPO }
                }
                
            }
        }
    }
}
