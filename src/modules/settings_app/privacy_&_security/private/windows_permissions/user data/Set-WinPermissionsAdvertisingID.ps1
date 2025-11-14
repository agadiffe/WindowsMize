#=================================================================================================================
#                        Privacy & Security > Recommendations And Offers > Advertising ID
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsAdvertisingID
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsAdvertisingID
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsAdvertisingID -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsAdvertisingIDMsg = 'Windows Permissions - Advertising ID'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsAdvertisingID = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
                    Entries = @(
                        @{
                            Name  = 'Enabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsAdvertisingIDMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsAdvertisingID
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > user profiles
                #   turn off the advertising ID
                # not configured: delete (default) | on: 1
                $WinPermissionsAdvertisingIDGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisabledByGroupPolicy'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsAdvertisingIDMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsAdvertisingIDGpo
            }
        }
    }
}
