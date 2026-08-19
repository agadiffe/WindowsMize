#=================================================================================================================
#                 System > Power & Battery > Energy Saver > Auto Turn On When Battery Level Is At
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverTurnOnAtBatteryLevel
        [[-Percent] <int>]
        [-GPO <object>] # <int> (range: 0-100) | NotConfigured
        [<CommonParameters>]
#>

function Set-EnergySaverTurnOnAtBatteryLevel
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverTurnOnAtBatteryLevel -Percent 30 -GPO 42

    .EXAMPLE
        PS> Set-EnergySaverTurnOnAtBatteryLevel -Percent 30 -GPO NotConfigured
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ValidateRange(0, 100)]
        [int] $Percent,

        [ValidateIntRangeOrNotConfigured(0, 100)]
        [object] $GPO
    )

    process
    {
        $SettingGUID = 'e69653ca-cf7f-4f05-aa73-cb833fa90ad4' # ESBATTTHRESHOLD
        $TurnOnAtBatteryLevelMsg = 'Energy Saver - Auto Turn On When Battery Level Is At'

        switch ($PSBoundParameters.Keys)
        {
            'Percent'
            {
                $State = switch ($Percent)
                {
                    0       { 'Never' }
                    100     { 'On Battery' }
                    Default { "$Percent%" }
                }

                Write-Verbose -Message "Setting '$TurnOnAtBatteryLevelMsg' to '$State' ..."

                $SubGroupGUID = 'de830923-a562-41af-a086-e3a2c6bad2da' # SUB_ENERGYSAVER
                $PowerPlanGUID = Get-PowerPlanGUID

                foreach ($GUID in $PowerPlanGUID)
                {
                    # If GPO is defined, powercfg cannot change the user setting. Use registry editing.

                    # default: 30 | never: 0 | on battery: 100
                    # GUI values: Never | 10% | 20% | 30% | 40% | 50% | On Battery
                    $TurnOnAtBatteryLevel = @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$GUID\$SubGroupGUID\$SettingGUID"
                        Entries = @(
                            @{
                                Name  = 'DCSettingIndex'
                                Value = $Percent
                                Type  = 'DWord'
                            }
                        )
                    }

                    Set-RegistryEntrySystemProtected -InputObject $TurnOnAtBatteryLevel
                }

                powercfg.exe -SetActive SCHEME_CURRENT
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > power management > energy saver settings
                #   energy saver battery threshold (on battery)
                # not configured: delete (default) | on: percent value (range: 0-100) (never: 0 | on battery: 100)
                $TurnOnAtBatteryLevelGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Policies\Microsoft\Power\PowerSettings\$SettingGUID"
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DCSettingIndex'
                            Value = $GPO
                            Type  = 'DWord'
                        }
                    )
                }

                $GpoMsg = switch ($GPO)
                {
                    0               { 'Never' }
                    100             { 'On Battery' }
                    'NotConfigured' { 'NotConfigured' }
                    Default         { "$GPO%" }
                }

                Write-Verbose -Message "Setting '$TurnOnAtBatteryLevelMsg (GPO)' to '$GpoMsg' ..."
                Set-RegistryEntry -InputObject $TurnOnAtBatteryLevelGpo
            }
        }
    }
}
