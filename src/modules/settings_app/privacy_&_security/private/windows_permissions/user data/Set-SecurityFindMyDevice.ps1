#=================================================================================================================
#                                       Privacy & Security > Find My Device
#=================================================================================================================

<#
.SYNTAX
    Set-SecurityFindMyDevice
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SecurityFindMyDevice
{
    <#
    .EXAMPLE
        PS> Set-SecurityFindMyDevice -State 'Disabled' -GPO 'NotConfigured'
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
        $SecurityFindMyDeviceMsg = 'Security - Find My Device'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $SecurityFindMyDevice = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\MdmCommon\SettingValues'
                    Entries = @(
                        @{
                            Name  = 'LocationSyncEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$SecurityFindMyDeviceMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $SecurityFindMyDevice
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > find my device
                #   turn on/off find my device
                # not configured: delete (default) | on: 1 | off: 0
                $SecurityFindMyDeviceGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\FindMyDevice'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowFindMyDevice'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$SecurityFindMyDeviceMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $SecurityFindMyDeviceGpo
            }
        }
    }
}
