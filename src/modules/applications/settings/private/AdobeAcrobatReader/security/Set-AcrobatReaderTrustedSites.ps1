#=================================================================================================================
#              Acrobat Reader - Preferences > Security (Enhanced) > Privileged Locations > Add Host
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustedSites
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustedSites
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustedSites -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ TrustManager > Disabling Privileged Locations
        #   disables and locks the ability to specify host-based privileged locations
        # not configured: delete (default) | off: 1
        $AcrobatReaderTrustedSitesGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bDisableTrustedSites'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Privileged Locations: Add Host (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderTrustedSitesGpo
    }
}
