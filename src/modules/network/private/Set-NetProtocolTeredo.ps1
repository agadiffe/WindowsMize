#=================================================================================================================
#                            Network Protocol - Teredo (IPv6 transition technologies)
#=================================================================================================================

<#
.SYNTAX
    Set-NetProtocolTeredo
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NetProtocolTeredo
{
    <#
    .EXAMPLE
        PS> Set-NetProtocolTeredo -State 'Disabled' -GPO 'NotConfigured'
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
        $NetworkProtocolTeredoMsg = 'Network Protocol Teredo'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                Write-Verbose -Message "Setting '$NetworkProtocolTeredoMsg' to '$State' ..."
                Set-NetTeredoConfiguration -Type ($State -eq 'Enabled' ? 'Client' : 'Disabled') -Verbose:$false
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
                #   set teredo state
                # not configured: delete (default) | on: 'Default', 'Disabled', 'Client', 'Enterprise Client'
                $NetworkProtocolTeredoGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'Teredo_State'
                            Value = $GPO -eq 'Enabled' ? 'Client' : 'Disabled'
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NetworkProtocolTeredoMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NetworkProtocolTeredoGpo
            }
        }
    }
}
