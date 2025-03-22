#=================================================================================================================
#                                Bluetooth & Devices > Mobile Devices > Phone Link
#=================================================================================================================

<#
.SYNTAX
    Set-MobileDevicesPhoneLink
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MobileDevicesPhoneLink
{
    <#
    .EXAMPLE
        PS> Set-MobileDevicesPhoneLink -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $PhoneLinkMsg = 'Mobile Devices - Phone Link'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $MobileDevicesPhoneLink = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Mobility'
                    Entries = @(
                        @{
                            Name  = 'PhoneLinkEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$PhoneLinkMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $MobileDevicesPhoneLink
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > group policy
                #   phone-PC linking on this device
                # not configured: delete (default) | off: 0
                $MobileDevicesPhoneLinkGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'EnableMmx'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$PhoneLinkMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $MobileDevicesPhoneLinkGpo
            }
        }
    }
}
