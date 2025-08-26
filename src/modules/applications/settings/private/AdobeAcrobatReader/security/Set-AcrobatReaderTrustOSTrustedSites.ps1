#=================================================================================================================
#       Acrobat Reader - Preferences > Security (Enhanced) > Auto Trust Sites From My Win OS Security Zones
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustOSTrustedSites
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustOSTrustedSites
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustOSTrustedSites -State 'Disabled' -GPO 'NotConfigured'
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
        $TrustOSTrustedSitesMsg = 'Acrobat Reader - Auto Trust Sites From My Win OS Security Zones'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AcrobatReaderTrustOSTrustedSites = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
                    Entries = @(
                        @{
                            Name  = 'bTrustOSTrustedSites'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TrustOSTrustedSitesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderTrustOSTrustedSites
            }
            'GPO'
            {
                # gpo\ TrustManager > Disabling Privileged Locations
                #   locks the ability to treat OS trusted sites as privileged locations
                # not configured: delete (default) | on: 0 | off: 1
                $AcrobatReaderTrustOSTrustedSitesGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bDisableOSTrustedSites'
                            Value = $GPO -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TrustOSTrustedSitesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderTrustOSTrustedSitesGpo
            }
        }
    }
}
