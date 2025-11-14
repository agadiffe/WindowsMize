#=================================================================================================================
#                                      Network - Block Firewall Inbound Rule
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderFirewallRule
        [-Name] {AllJoynRouter | CastToDevice | ConnectedDevicesPlatform | DeliveryOptimization | DIALProtocol |
                 MicrosoftMediaFoundation | ProximitySharing | WifiDirectDiscovery | WirelessDisplay |
                 WiFiDirectCoordinationProtocol | WiFiDirectKernelModeDriver}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderFirewallRule
{
    <#
    .DESCRIPTION
        By default, Defender Firewall outbound connections that do not match a rule are all allowed.
        It means that disabling a feature will affect only inbound rules.
        e.g. Disabling "CastToDevice" will not prevent casting to other devices.

    .EXAMPLE
        PS> Set-DefenderFirewallRule -Name 'CastToDevice', 'DIALProtocol' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(
            'AllJoynRouter',
            'CastToDevice',
            'ConnectedDevicesPlatform',
            'DeliveryOptimization',
            'DIALProtocol',
            'MicrosoftMediaFoundation',
            'ProximitySharing',
            'WifiDirectDiscovery',
            'WirelessDisplay',
            'WiFiDirectCoordinationProtocol',
            'WiFiDirectKernelModeDriver')]
        [string[]] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        foreach ($Item in $Name)
        {
            $GroupID, $SettingMsg = switch ($Item)
            {
                'AllJoynRouter'                  { '@FirewallAPI.dll,-37002', 'AllJoyn Router' }
                'CastToDevice'                   { '@FirewallAPI.dll,-36001', 'Cast to Device functionality' }
                'ConnectedDevicesPlatform'       { '@FirewallAPI.dll,-37402', 'Connected Devices Platform' }
                'DeliveryOptimization'           { '@%systemroot%\system32\dosvc.dll,-100', 'Delivery Optimization' }
                'DIALProtocol'                   { '@FirewallAPI.dll,-37101', 'DIAL protocol server' }
                'MicrosoftMediaFoundation'       { '@FirewallAPI.dll,-54001', 'Microsoft Media Foundation Network Source' }
                'ProximitySharing'               { '@FirewallAPI.dll,-36251', 'Proximity Sharing' }
                'WifiDirectDiscovery'            { '@FirewallAPI.dll,-36851', 'Wi-Fi Direct Network Discovery' }
                'WirelessDisplay'                { '@wifidisplay.dll,-100', 'Wireless Display' }
                'WiFiDirectCoordinationProtocol' { '@wlansvc.dll,-36864', 'WLAN Service - WFD Application Services Platform Coordination Protocol' }
                'WiFiDirectKernelModeDriver'     { '@wlansvc.dll,-36865', 'WLAN Service - WFD Services Kernel Mode Driver Rules' }
            }

            Write-Verbose -Message "Setting 'Defender Firewall rule - $SettingMsg ($GroupID)' to '$State' ..."
            $FirewallRule = Get-NetFirewallRule -Group $GroupID -ErrorAction 'SilentlyContinue'
            if ($FirewallRule)
            {
                $FirewallRule | Set-NetFirewallRule -Enabled ($State -eq 'Enabled' ? 'True' : 'False')
            }
            else
            {
                Write-Verbose -Message "    Firewall rule not found"
            }
        }
    }
}
