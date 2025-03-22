#=================================================================================================================
#                          System > Storage > Storage Sense > Cleanup Of Temporary Files
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseCleanupTempFiles
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StorageSenseCleanupTempFiles
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseCleanupTempFiles -State 'Disabled' -GPO 'NotConfigured'
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
        $CleanupTempFilesMsg = 'Storage Sense - Cleanup Of Temporary Files'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $CleanupTempFiles = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy'
                    Entries = @(
                        @{
                            Name  = '04'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$CleanupTempFilesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $CleanupTempFiles
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > storage sense
                #   allow storage sense temporary files cleanup
                # not configured: delete (default) | on: 1 | off: 0
                $CleanupTempFilesGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\StorageSense'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowStorageSenseTemporaryFilesCleanup'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$CleanupTempFilesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $CleanupTempFilesGpo
            }
        }
    }
}
