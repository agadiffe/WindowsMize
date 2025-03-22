#=================================================================================================================
#                     Apps > Offline Maps > Update Automatically When Plugged-In And On Wi-Fi
#=================================================================================================================

<#
.SYNTAX
    Set-OfflineMapsAutoUpdateOnACAndWifi
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-OfflineMapsAutoUpdateOnACAndWifi
{
    <#
    .EXAMPLE
        PS> Set-OfflineMapsAutoUpdateOnACAndWifi -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $OfflineMapsAutoUpdateMsg = 'Offline Maps - Update Automatically When Plugged-In And On Wi-Fi'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $OfflineMapsAutoUpdate = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SYSTEM\Maps'
                    Entries = @(
                        @{
                            Name  = 'AutoUpdateEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$OfflineMapsAutoUpdateMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $OfflineMapsAutoUpdate
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $IsEnabled = $GPO -eq 'Enabled'

                # gpo\ computer config > administrative tpl > windows components > maps
                #   turn off automatic download and update of map data
                #   turn off unsolicited network traffic on the Offline Maps settings page
                # not configured: delete (default) | on: 1 | off: 0
                $OfflineMapsAutoUpdateGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Maps'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'AutoDownloadAndUpdateMapData'
                            Value = $IsEnabled ? '1' : '0'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'AllowUntriggeredNetworkTrafficOnSettingsPage'
                            Value = $IsEnabled ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$OfflineMapsAutoUpdateMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $OfflineMapsAutoUpdateGpo
            }
        }
    }
}
