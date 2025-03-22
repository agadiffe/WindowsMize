#=================================================================================================================
#                                    Bluetooth & Devices > Devices - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-UsbSetting
        [-NotifOnErrors {Disabled | Enabled}]
        [-BatterySaver {Disabled | Enabled}]
        [-NotifOnWeakCharger {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-UsbSetting
{
    <#
    .EXAMPLE
        PS> Set-UsbSetting -NotifOnErrors 'Enabled' -BatterySaver 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $NotifOnErrors,

        [state] $BatterySaver,

        [state] $NotifOnWeakCharger
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
            'NotifOnErrors'      { Set-UsbNotificationOnErrors -State $NotifOnErrors }
            'BatterySaver'       { Set-UsbBatterySaver -State $BatterySaver }
            'NotifOnWeakCharger' { Set-UsbNotificationOnWeakCharger -State $NotifOnWeakCharger }
        }
    }
}
