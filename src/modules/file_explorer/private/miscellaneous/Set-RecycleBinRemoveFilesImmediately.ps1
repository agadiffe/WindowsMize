#=================================================================================================================
#                                     Recycle Bin > Remove Files Immediately
#=================================================================================================================

# Don't move files to the Recycle Bin. Remove files immediately when deleted.

<#
.SYNTAX
    Set-RecycleBinRemoveFilesImmediately
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RecycleBinRemoveFilesImmediately
{
    <#
    .DESCRIPTION
        The 'State' parameter applies only to all existing volumes.
        Use the group policy to apply the setting to existing and new drives.

    .EXAMPLE
        PS> Set-RecycleBinRemoveFilesImmediately -State 'Disabled' -GPO 'NotConfigured'
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
        $RemoveFilesImmediatelyMsg = 'Recycle Bin - Remove Files Immediately When Deleted'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $RemoveFilesImmediately = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\BitBucket\Volume\*'
                    Entries = @(
                        @{
                            Name  = 'NukeOnDelete'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RemoveFilesImmediatelyMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $RemoveFilesImmediately
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > file explorer
                #   do not move deleted files to the Recycle Bin
                # not configured: delete (default) | on: 1
                $RemoveFilesImmediatelyGpo = @{
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

                Write-Verbose -Message "Setting '$RemoveFilesImmediatelyMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $RemoveFilesImmediatelyGpo
            }
        }
    }
}
