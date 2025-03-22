#=================================================================================================================
#                           Network Protocol - IP-HTTPS (IPv6 transition technologies)
#=================================================================================================================

<#
.SYNTAX
    Set-NetProtocolIPHttps
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NetProtocolIPHttps
{
    <#
    .EXAMPLE
        PS> Set-NetProtocolIPHttps -State 'Disabled' -GPO 'NotConfigured'
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
        $NetworkProtocolIPHttpsMsg = 'Network Protocol IP-HTTPS'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                Write-Verbose -Message "Setting '$NetworkProtocolIPHttpsMsg' to '$State' ..."

                $IPHttpsConfig = Get-NetIPHttpsConfiguration
                $IsGpoConfigured = $IPHttpsConfig.ConfigurationType -eq 'GroupPolicy'
                if ($IsGpoConfigured)
                {
                    Write-Verbose -Message "    '$NetworkProtocolIPHttpsMsg' is already configured with group policy"
                }
                else
                {
                    # Does nothing if there is no IP-HTTPS profile.
                    # Throw an error if IP-HTTPS is configured with GPO.
                    Set-NetIPHttpsConfiguration -State $State -Verbose:$false
                }
            }
            'GPO'
            {
                $GpoStateValue, $GpoUrlValue = switch ($GPO)
                {
                    'Enabled'  { '2', 'about:blank' } # 'https://example.com:443/IPHTTPs'
                    'Disabled' { '3', 'about:blank' }
                }

                # gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
                #   set ip-https state
                # not configured: delete (default) | on: Default (0), Enabled (2), Disabled (3)
                $NetworkProtocolIPHttpsGpo = @{
                    RemoveKey = $GPO -eq 'NotConfigured'
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\TCPIP\v6Transition\IPHTTPS\IPHTTPSInterface'
                    Entries = @(
                        @{
                            Name  = 'IPHTTPS_ClientState'
                            Value = $GpoStateValue
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'IPHTTPS_ClientUrl'
                            Value = $GpoUrlValue
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NetworkProtocolIPHttpsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NetworkProtocolIPHttpsGpo
            }
        }
    }
}
