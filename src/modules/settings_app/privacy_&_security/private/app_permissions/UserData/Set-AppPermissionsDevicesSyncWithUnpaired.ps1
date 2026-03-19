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
                # on: Allow (default) | off: Deny

                $SyncWithDevices = [AppPermissionAccess]::new('bluetoothSync', $State)
                $SyncWithDevices.WriteVerboseMsg($SyncWithDevicesMsg)
                $SyncWithDevices.SetRegistryEntry()
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
