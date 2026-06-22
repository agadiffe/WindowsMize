#=================================================================================================================
#                                          Network & Internet - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-NetworkSetting
        # Wi-Fi / Ethernet
        [-ConnectedNetworkProfile {Public | Private}]

        # VPN
        [-VpnOverMeteredNetworks {Disabled | Enabled}]
        [-VpnWhileRoaming {Disabled | Enabled}]

        # Proxy
        [-ProxyAutoDetectSettings {Disabled | Enabled}]

        # Sharing settings
        [-AutoSetupConnectedDevices {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-NetworkSetting
{
    <#
    .EXAMPLE
        PS> Set-NetworkSetting -ConnectedNetworkProfile 'Private' -ProxyAutoDetectSettings 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # Wi-Fi / Ethernet
        [ValidateSet('Public', 'Private')]
        [string] $ConnectedNetworkProfile,

        # VPN
        [state] $VpnOverMeteredNetworks,
        [state] $VpnWhileRoaming,

        # Proxy
        [state] $ProxyAutoDetectSettings,

        # Sharing settings
        [state] $AutoSetupConnectedDevices
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            # Wi-Fi / Ethernet
            'ConnectedNetworkProfile'
            {
                # Public (default) | Private
                Write-Verbose -Message "Setting 'Connected Network' To '$ConnectedNetworkProfile' ..."
                Set-NetConnectionProfile -NetworkCategory $ConnectedNetworkProfile
            }

            # VPN
            'VpnOverMeteredNetworks'    { Set-VpnOverMeteredNetworks -State $VpnOverMeteredNetworks }
            'VpnWhileRoaming'           { Set-VpnWhileRoaming -State $VpnWhileRoaming }

            # Proxy
            'ProxyAutoDetectSettings'   { Set-ProxyAutoDetectSettings -State $ProxyAutoDetectSettings }

            # Sharing settings
            'AutoSetupConnectedDevices' { Set-NetConnectedDevicesAutoSetup -State $AutoSetupConnectedDevices }
        }
    }
}
