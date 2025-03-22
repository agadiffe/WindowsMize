#=================================================================================================================
#                                Recycle Bin > Display Delete Confirmation Dialog
#=================================================================================================================

<#
.SYNTAX
    Set-RecycleBinConfirmFileDelete
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RecycleBinConfirmFileDelete
{
    <#
    .EXAMPLE
        PS> Set-RecycleBinConfirmFileDelete -State 'Disabled' -GPO 'NotConfigured'
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
        $ConfirmFileDeleteMsg = 'Recycle Bin - Display Delete Confirmation Dialog'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 5th byte, 3rd bit\ on: 0 | off: 1 (default)

                $ConfirmFileDeletePath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer'
                $ConfirmFileDeleteBytes = Get-ItemPropertyValue -Path $ConfirmFileDeletePath -Name 'ShellState'
                Set-ByteBitFlag -Bytes $ConfirmFileDeleteBytes -ByteNum 4 -BitPos 3 -State ($State -eq 'Enabled' ? $false : $true)

                $ConfirmFileDelete = [HkcuExplorerAdvanced]::new('ShellState', $ConfirmFileDeleteBytes, 'Binary')
                $ConfirmFileDelete.WriteVerboseMsg($ConfirmFileDeleteMsg, $State)
                $ConfirmFileDelete.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > file explorer
                #   display confirmation dialog when deleting files
                # not configured: delete (default) | on: 1
                $ConfirmFileDeleteGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ConfirmFileDelete'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ConfirmFileDeleteMsg (GPO)' to '$State' ..."
                Set-RegistryEntry -InputObject $ConfirmFileDeleteGpo
            }
        }
    }
}
