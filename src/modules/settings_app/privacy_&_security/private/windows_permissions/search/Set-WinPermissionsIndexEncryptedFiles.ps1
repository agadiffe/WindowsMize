#=================================================================================================================
#                 Privacy & Security > Search > Advanced Indexing Options > Index Encrypted Files
#=================================================================================================================

# Full volume encryption (such as BitLocker Drive Encryption or a non-Microsoft solution)
# must be used for the location of the index to maintain security for encrypted files.

# Indexing and allowing users to search encrypted files could potentially reveal confidential
# data stored within the encrypted files.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-WinPermissionsIndexEncryptedFiles
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WinPermissionsIndexEncryptedFiles
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsIndexEncryptedFiles -GPO 'Disabled'
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
        $IndexEncryptedFilesGpo = @{
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

        Write-Verbose -Message "Setting 'Windows Permissions - Search: Index Encrypted Files (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $IndexEncryptedFilesGpo
    }
}
