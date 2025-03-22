#=================================================================================================================
#                             Network Protocol - 6to4 (IPv6 transition technologies)
#=================================================================================================================

<#
.SYNTAX
    Set-NetProtocol6to4
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NetProtocol6to4
{
    <#
    .EXAMPLE
        PS> Set-NetProtocol6to4 -State 'Disabled' -GPO 'NotConfigured'
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
        $NetworkProtocol6to4Msg = 'Network Protocol 6to4'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                Write-Verbose -Message "Setting '$NetworkProtocol6to4Msg' to '$State' ..."
                Set-Net6to4Configuration -State $State -Verbose:$false
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
                #   set 6to4 state
                # not configured: delete (default) | on: 'Default', 'Enabled', 'Disabled'
                $NetworkProtocol6to4Gpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = '6to4_State'
                            Value = $GPO
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NetworkProtocol6to4Msg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NetworkProtocol6to4Gpo
            }
        }
    }
}
