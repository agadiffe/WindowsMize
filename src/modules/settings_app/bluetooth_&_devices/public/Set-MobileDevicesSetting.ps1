#=================================================================================================================
#                                 Bluetooth & Devices > Mobile Devices - Settings
#=================================================================================================================

# For GPO, see: telemetry > Set-ConsumerExperience

<#
.SYNTAX
    Set-MobileDevicesSetting
        [-MobileDevices {Disabled | Enabled}]
        [-PhoneLink {Disabled | Enabled}]
        [-PhoneLinkGPO {Disabled | NotConfigured}]
        [-ShowUsageSuggestions {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MobileDevicesSetting
{
    <#
    .EXAMPLE
        PS> Set-MobileDevicesSetting -MobileDevices 'Disabled' -ShowUsageSuggestions 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $MobileDevices,

        [state] $PhoneLink,

        [GpoStateWithoutEnabled] $PhoneLinkGPO,

        [state] $ShowUsageSuggestions
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
            'MobileDevices'        { Set-MobileDevices -State $MobileDevices }
            'PhoneLink'            { Set-MobileDevicesPhoneLink -State $PhoneLink }
            'PhoneLinkGPO'         { Set-MobileDevicesPhoneLink -GPO $PhoneLinkGPO }
            'ShowUsageSuggestions' { Set-MobileDevicesShowUsageSuggestions -State $ShowUsageSuggestions }
        }
    }
}
