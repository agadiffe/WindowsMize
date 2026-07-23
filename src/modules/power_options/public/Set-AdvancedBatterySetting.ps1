#=================================================================================================================
#                                        Power Options - Battery Settings
#=================================================================================================================

# For battery longevity, you should NEVER let your battery fall below 10% (or even better: 15%).

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
#   > change advanced power settings > battery
#     > low battery level
#     > low battery action
#     > critical battery level
#     > critical battery action
#     > reserve battery level

# 'Low' will display a warning to plug-in your computer.
# 'Reserve' will display a final warning (and presumably disable some features/services ?).
# 'Critical' will shutdown (or else) your computer.

<#
.SYNTAX
    Set-AdvancedBatterySetting
        [-Battery] {Low | Critical | Reserve}
        [[-Percent] <int>]
        [[-Action] {DoNothing | Sleep | Hibernate | ShutDown}]
        [<CommonParameters>]
#>

function Set-AdvancedBatterySetting
{
    <#
    .DESCRIPTION
        'Reserve' battery does not support 'Action'.
        At least 'Percent' or 'Action' must be specified.

    .EXAMPLE
        PS> Set-AdvancedBatterySetting -Battery 'Low' -Percent 20

    .EXAMPLE
        PS> Set-AdvancedBatterySetting -Battery 'Critical' -Percent 10 -Action 'ShutDown'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Low', 'Critical', 'Reserve')]
        [string] $Battery,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(5, 100)]
        [int] $Percent,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('DoNothing', 'Sleep', 'Hibernate', 'ShutDown')]
        [string] $Action
    )

    process
    {
        if (-not $PSBoundParameters.ContainsKey('Percent') -and -not $PSBoundParameters.ContainsKey('Action'))
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            Write-Error -Message 'Specify at least the ''Percent'' or ''Action'' parameter.'
            return
        }

        if ($Battery -eq 'Reserve' -and $PSBoundParameters.ContainsKey('Action'))
        {
            Write-Error -Message '''Reserve'' battery does not support ''Action''.'
            return
        }

        $ActionSettingGUID, $LevelSettingGUID = switch ($Battery)
        {
            'Low'      { 'BATACTIONLOW',  'BATLEVELLOW' }
            'Critical' { 'BATACTIONCRIT', 'BATLEVELCRIT' }
            'Reserve'  { '', 'f3c5027d-cd16-4930-aa6b-90db844a8f00' }
        }

        $Msg = @()
        if ($PSBoundParameters.ContainsKey('Percent')) { $Msg += "$Percent%" }
        if ($PSBoundParameters.ContainsKey('Action'))  { $Msg += $Action }
        $BatterySettingMsg = $Msg -join ' / '

        Write-Verbose -Message "Setting '$Battery battery' to '$BatterySettingMsg' ..."

        # default (depends):
        #   Low      : 10%, DoNothing
        #   Reserve  : 7%
        #   Critical : 5%, Hibernate

        switch ($PSBoundParameters.Keys)
        {
            'Action'
            {
                $SettingIndex = switch ($Action)
                {
                    'DoNothing' { 0 }
                    'Sleep'     { 1 }
                    'Hibernate' { 2 }
                    'ShutDown'  { 3 }
                }

                powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_BATTERY $ActionSettingGUID $SettingIndex
                powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_BATTERY $ActionSettingGUID $SettingIndex
            }
            'Percent'
            {
                powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_BATTERY $LevelSettingGUID $Percent
                powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_BATTERY $LevelSettingGUID $Percent
            }
        }
    }
}
