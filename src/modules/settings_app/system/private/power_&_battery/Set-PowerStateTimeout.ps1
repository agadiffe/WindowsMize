#=================================================================================================================
#                   System > Power & Battery > Power Mode > Screen, Sleep, & Hibernate Timeouts
#=================================================================================================================

# When plugged in | On battery power
#   turn my screen off after
#   make my device sleep after
#   make my device hibernate after

<#
.SYNTAX
    Set-PowerStateTimeout
        [-Name] {Screen | Sleep | Hibernate}
        [-PowerSource] {PluggedIn | OnBattery}
        [-TimeoutMins] <int>
        [-GPO <object>] # <int> (range: 0-35791394) | NotConfigured
        [<CommonParameters>]
#>

function Set-PowerStateTimeout
{
    <#
    .EXAMPLE
        PS> Set-PowerStateTimeout -Name 'Sleep' -PowerSource 'PluggedIn' -TimeoutMins 10 -GPO 42
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [PowerState] $Name,

        [Parameter(Mandatory)]
        [PowerSource] $PowerSource,

        [ValidateIntRangeOrNotConfigured(0, 35791394)]
        [int] $TimeoutMins,

        [ValidateIntRangeOrNotConfigured(0, 35791394)]
        [object] $GPO
    )

    process
    {
        $SettingGUID = switch ($Name)
        {
            'Screen'    { '3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e' } # VIDEOIDLE
            'Sleep'     { '29f6c1db-86da-48c5-9fdb-f2b67b1f44da' } # STANDBYIDLE
            'Hibernate' { '9d7815a6-7ee4-497e-8888-515a05f02364' } # HIBERNATEIDLE
        }

        $PowerStateTimeoutMsg = "Power - $Name Timeout ($PowerSource)"

        switch ($PSBoundParameters.Keys)
        {
            'TimeoutMins'
            {
                $State = switch ($TimeoutMins)
                {
                    0       { 'Never' }
                    Default { "$TimeoutMins min(s)" }
                }

                Write-Verbose -Message "Setting '$PowerStateTimeoutMsg' to '$State' ..."

                $SubGroupGUID = $Name -eq 'Screen' ?
                    '7516b95f-f776-4464-8c53-06167f40cc99' : # SUB_VIDEO
                    '238c9fa8-0aad-41ed-83f4-97be242c8f20' # SUB_SLEEP

                $PowerPlanGUID = Get-PowerPlanGUID
                $Value = $TimeoutMins * 60

                foreach ($GUID in $PowerPlanGUID)
                {
                    # If GPO is defined, powercfg cannot change the user setting. Use registry editing.

                    # value is in minutes
                    # never: 0 | default (depends): PluggedIn\ 5 15 180, OnBattery\ 3 10 180
                    # GUI values: 1 2 3 5 10 15 20 25 30 45 minute(s), 1 2 3 4 5 hour(s), Never
                    $PowerStateTimeout = @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$GUID\$SubGroupGUID\$SettingGUID"
                        Entries = [System.Collections.ArrayList]@(
                            @{
                                Name  = 'ACSettingIndex'
                                Value = $Value
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'DCSettingIndex'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }

                    switch ($PowerSource)
                    {
                        'PluggedIn' { $PowerStateTimeout['Entries'].RemoveAt(1) }
                        'OnBattery' { $PowerStateTimeout['Entries'].RemoveAt(0) }
                    }

                    Set-RegistryEntrySystemProtected -InputObject $PowerStateTimeout
                }

                powercfg.exe -SetActive SCHEME_CURRENT
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $GpoValue = $GPO * 60

                # gpo\ computer config > administrative tpl > system > power management > sleep settings
                #   specify the system hibernate timeout (on battery)
                #   specify the system hibernate timeout (plugged in)
                #   specify the system sleep timeout (on battery)
                #   specify the system sleep timeout (plugged in)
                # not configured: delete (default) | on: value in seconds (range: 0-2147483647 (INT_MAX)) (never: 0)
                #
                # gpo\ computer config > administrative tpl > system > power management > video and display settings
                #   turn off the display (on battery)
                #   turn off the display (plugged in)
                # not configured: delete (default) | on: value in seconds (range: 0-2147483647 (INT_MAX)) (never: 0)
                $PowerStateTimeoutGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Policies\Microsoft\Power\PowerSettings\$SettingGUID"
                    Entries = [System.Collections.ArrayList]@(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ACSettingIndex'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DCSettingIndex'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                    )
                }

                switch ($PowerSource)
                {
                    'PluggedIn' { $PowerStateTimeoutGpo['Entries'].RemoveAt(1) }
                    'OnBattery' { $PowerStateTimeoutGpo['Entries'].RemoveAt(0) }
                }

                $GpoMsg = switch ($GPO)
                {
                    0               { 'Never' }
                    'NotConfigured' { 'NotConfigured' }
                    Default         { "$GPO min(s)" }
                }

                Write-Verbose -Message "Setting '$PowerStateTimeoutMsg (GPO)' to '$GpoMsg' ..."
                Set-RegistryEntry -InputObject $PowerStateTimeoutGpo
            }
        }
    }
}
