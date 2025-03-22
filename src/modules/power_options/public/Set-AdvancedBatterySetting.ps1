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

# default (depends):
#   Low      : 10%, DoNothing
#   Reserve  : 7%
#   Critical : 5%, Hibernate

<#
.SYNTAX
    Set-AdvancedBatterySetting
        [-Battery] {Low | Critical | Reserve}
        [[-Level] <int>]
        [[-Action] {DoNothing | Sleep | Hibernate | ShutDown}]
        [<CommonParameters>]
#>

function Set-AdvancedBatterySetting
{
    <#
    .DESCRIPTION
        'Reserve Battery' does not support 'Action' parameter.

    .EXAMPLE
        PS> Set-AdvancedBatterySetting -Battery 'Low' -Level 20

    .EXAMPLE
        PS> Set-AdvancedBatterySetting -Battery 'Critical' -Level 10 -Action 'ShutDown'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Low', 'Critical', 'Reserve')]
        [string] $Battery,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(5, 100)]
        [int] $Level,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('DoNothing', 'Sleep', 'Hibernate', 'ShutDown')]
        [string] $Action
    )

    process
    {
        if (-not ($PSBoundParameters.Keys.Count - 1))
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            Write-Error -Message 'Specify at least the ''Level'' or ''Action'' parameter.'
            return
        }

        # [ValidateScript({ $Battery -ne 'Reserve' })] does not work if $Battery is defined after $Action
        if ($Action -and $Battery -eq 'Reserve')
        {
            Write-Error -Message '''Reserve Battery'' does not support ''Action'' parameter.'
            return
        }

        $SettingIndex = switch ($Action)
        {
            'DoNothing' { 0 }
            'Sleep'     { 1 }
            'Hibernate' { 2 }
            'ShutDown'  { 3 }
        }

        $ActionSettingGUID, $LevelSettingGUID = switch ($Battery)
        {
            'Low'      { 'BATACTIONLOW',  'BATLEVELLOW' }
            'Critical' { 'BATACTIONCRIT', 'BATLEVELCRIT' }
            'Reserve'  { '', 'f3c5027d-cd16-4930-aa6b-90db844a8f00' }
        }

        $BatterySettingState = "$(if ($Level) { "'$Level%'" }) $(if ($Action) { if ($Level) { "/" } "'$Action'" })"
        Write-Verbose -Message "Setting '$Battery battery' to $BatterySettingState ..."

        switch ($PSBoundParameters.Keys)
        {
            'Action'
            {
                powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_BATTERY $ActionSettingGUID $SettingIndex
                powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_BATTERY $ActionSettingGUID $SettingIndex
            }
            'Level'
            {
                powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_BATTERY $LevelSettingGUID $Level
                powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_BATTERY $LevelSettingGUID $Level
            }
        }
    }
}
