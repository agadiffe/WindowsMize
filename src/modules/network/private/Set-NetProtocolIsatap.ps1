#=================================================================================================================
#                            Network Protocol - ISATAP (IPv6 transition technologies)
#=================================================================================================================

<#
.SYNTAX
    Set-NetProtocolIsatap
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NetProtocolIsatap
{
    <#
    .EXAMPLE
        PS> Set-NetProtocolIsatap -State 'Disabled' -GPO 'NotConfigured'
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
        $NetworkProtocolIsatapMsg = 'Network Protocol ISATAP'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                Write-Verbose -Message "Setting '$NetworkProtocolIsatapMsg' to '$State' ..."
                Set-NetIsatapConfiguration -State $State -Verbose:$false
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
                #   set isatap state
                # not configured: delete (default) | on: 'Default', 'Enabled', 'Disabled'
                $NetworkProtocolIsatapGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ISATAP_State'
                            Value = $GPO
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NetworkProtocolIsatapMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NetworkProtocolIsatapGpo
            }
        }
    }
}
