#=================================================================================================================
#                                       System > Power & Battery - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-PowerSetting
        -PowerMode {BestPowerEfficiency | Balanced | BestPerformance}
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
        PS> Set-PowerSetting -PowerMode 'BestPowerEfficiency'

    .EXAMPLE
        PS> Set-PowerSetting -PowerState 'Sleep' -Timeout 10 -PowerSource 'PluggedIn'

    .EXAMPLE
        PS> Set-PowerSetting -ButtonControls 'LidClose' -Action 'Sleep' -PowerSource 'OnBattery'
    #>

    [CmdletBinding(DefaultParameterSetName = 'PowerMode')]
    param
    (
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

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'PowerStateTimeout')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ButtonControls')]
        [PowerSource] $PowerSource
    )

    process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'PowerMode'         { Set-PowerMode -Value $PowerMode }
            'PowerStateTimeout' { Set-PowerStateTimeout -Name $PowerState -Timeout $Timeout -PowerSource $PowerSource }
            'ButtonControls'    { Set-PowerButtonControls -Name $ButtonControls -Action $Action -PowerSource $PowerSource }
        }
    }
}
