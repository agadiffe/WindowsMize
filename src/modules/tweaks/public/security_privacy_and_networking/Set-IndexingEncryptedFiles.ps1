#=================================================================================================================
#                                           Indexing Of Encrypted Files
#=================================================================================================================

<#
.SYNTAX
    Set-IndexingEncryptedFiles
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-IndexingEncryptedFiles
{
    <#
    .EXAMPLE
        PS> Set-IndexingEncryptedFiles -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > search
        #   allow indexing of encrypted files
        # not configured: delete (default) | on: 1 | off: 0
        $IndexingEncryptedFilesGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowIndexingEncryptedStoresOrItems'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Indexing Of Encrypted Files (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $IndexingEncryptedFilesGpo
    }
}
