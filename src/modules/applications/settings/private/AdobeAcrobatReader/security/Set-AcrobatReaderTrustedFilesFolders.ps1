#=================================================================================================================
#     Acrobat Reader - Preferences > Security (Enhanced) > Privileged Locations > Add File / Add Folder Path
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustedFilesFolders
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustedFilesFolders
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustedFilesFolders -GPO 'Disabled'
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
        #   disables trusted folders AND files and prevents users from specifying a privileged location for directories
        # not configured: delete (default) | off: 1
        $AcrobatReaderTrustedFilesFoldersGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bDisableTrustedFolders'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Privileged Locations: Add File / Add Folder Path (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderTrustedFilesFoldersGpo
    }
}
