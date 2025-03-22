#=================================================================================================================
#                                        System > Storage > Storage Sense
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSense
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StorageSense
{
    <#
    .EXAMPLE
        PS> Set-StorageSense -State 'Disabled' -GPO 'NotConfigured'
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
        $StorageSenseMsg = 'Storage Sense - Automatic User Content Cleanup'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $StorageSense = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy'
                    Entries = @(
                        @{
                            Name  = '01'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StorageSenseMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StorageSense
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > storage sense
                #   allow storage sense
                # not configured: delete (default) | on: 1 | off: 0
                $StorageSenseGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\StorageSense'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowStorageSenseGlobal'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StorageSenseMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StorageSenseGpo
            }
        }
    }
}
