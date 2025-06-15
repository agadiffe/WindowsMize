#=================================================================================================================
#            Privacy & Security > App Permissions > Others Devices > Communicate With Unpaired Devices
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsDevicesSyncWithUnpaired
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsDevicesSyncWithUnpaired
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsDevicesSyncWithUnpaired -State 'Disabled' -GPO 'NotConfigured'
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
        $SyncWithDevicesMsg = 'Others Devices: Communicate With Unpaired Devices'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # Win 11
                #---------
                # on: 1 (default) | off: 0
                $SyncWithDevices = [AppPermissionSetting]::new(@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Privacy'
                    Entries = @(
                        @{
                            Name  = 'TailoredExperiencesWithDiagnosticDataEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                })

                $SyncWithDevices.WriteVerboseMsg($SyncWithDevicesMsg, $State)
                $SyncWithDevices.SetRegistryEntry()

                # Win 10
                #---------
                # on: Allow (default) | off: Deny

                $SyncWithDevicesWin10 = [AppPermissionAccess]::new('bluetoothSync', $State)
                $SyncWithDevicesWin10.WriteVerboseMsg("$SyncWithDevicesMsg (Win10)")
                $SyncWithDevicesWin10.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps communicate with unpaired devices
                # not configured: delete (default) | on: 1 | off: 2

                $SyncWithDevicesGpo = [AppPermissionPolicy]::new('LetAppsSyncWithDevices', $GPO)
                $SyncWithDevicesGpo.WriteVerboseMsg("$SyncWithDevicesMsg (GPO)")
                $SyncWithDevicesGpo.SetRegistryEntry()
            }
        }
    }
}
