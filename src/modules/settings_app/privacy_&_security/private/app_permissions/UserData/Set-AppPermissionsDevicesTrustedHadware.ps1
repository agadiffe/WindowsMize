#=================================================================================================================
#                   Privacy & Security > App Permissions > Others Devices > Use Trusted Devices
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsDevicesTrustedHadware
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AppPermissionsDevicesTrustedHadware
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsDevicesTrustedHadware -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > app privacy
        #   let Windows apps access trusted devices
        # not configured: delete (default) | on: 1 | off: 2

        $TrustedHadwareGpo = [AppPermissionPolicy]::new('LetAppsAccessTrustedDevices', $GPO)
        $TrustedHadwareGpo.WriteVerboseMsg("Others Devices: Use Trusted Devices (GPO)")
        $TrustedHadwareGpo.SetRegistryEntry()
    }
}
