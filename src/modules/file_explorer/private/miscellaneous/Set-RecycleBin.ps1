#=================================================================================================================
#                                                   Recycle Bin
#=================================================================================================================

# Disabled: Don't move files to the Recycle Bin. Remove files immediately when deleted.

<#
.SYNTAX
    Set-RecycleBin
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RecycleBin
{
    <#
    .DESCRIPTION
        The 'State' parameter applies only to all existing volumes.
        Use the group policy to apply the setting to existing and new drives.

    .EXAMPLE
        PS> Set-RecycleBin -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $RecycleBinMsg = 'Recycle Bin'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 (default) | off: 1
                $RecycleBin = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket\Volume\*'
                    Entries = @(
                        @{
                            Name  = 'NukeOnDelete'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecycleBinMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $RecycleBin
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > file explorer
                #   do not move deleted files to the Recycle Bin
                # not configured: delete (default) | on: 1
                $RecycleBinGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoRecycleFiles'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecycleBinMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $RecycleBinGpo
            }
        }
    }
}
