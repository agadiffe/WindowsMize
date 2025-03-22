#=================================================================================================================
#                               Bluetooth & Devices > Devices - Bluetooth Settings
#=================================================================================================================

<#
.SYNTAX
    Set-BluetoothSetting
        [-BluetoothGPO {Disabled | NotConfigured}]
        [-DiscoveryMode {Default | Advanced}]
        [-LowEnergyAudio {Disabled | Enabled}]
        [-ShowQuickPairConnectionNotif {Disabled | Enabled}]
        [-ShowQuickPairConnectionNotifGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-BluetoothSetting
{
    <#
    .EXAMPLE
        PS> Set-BluetoothSetting -BluetoothGPO 'Disabled' -LowEnergyAudio 'Default'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoStateWithoutEnabled] $BluetoothGPO,

        [BluetoothDiscoveryMode] $DiscoveryMode,

        [state] $LowEnergyAudio,

        [state] $ShowQuickPairConnectionNotif,

        [GpoStateWithoutEnabled] $ShowQuickPairConnectionNotifGPO
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
            'BluetoothGPO'                    { Set-Bluetooth -GPO $BluetoothGPO }
            'DiscoveryMode'                   { Set-BluetoothDiscoveryMode -Value $DiscoveryMode }
            'LowEnergyAudio'                  { Set-BluetoothLowEnergyAudio -State $LowEnergyAudio }
            'ShowQuickPairConnectionNotif'    { Set-BluetoothShowQuickPairConnectionNotif -State $ShowQuickPairConnectionNotif  }
            'ShowQuickPairConnectionNotifGPO' { Set-BluetoothShowQuickPairConnectionNotif -GPO $ShowQuickPairConnectionNotifGPO }
        }
    }
}
