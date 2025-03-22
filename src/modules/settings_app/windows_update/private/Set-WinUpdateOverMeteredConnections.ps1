#=================================================================================================================
#                           Windows Update > Download Updates Over Metered Connections
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateOverMeteredConnections
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinUpdateOverMeteredConnections
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateOverMeteredConnections -State 'Disabled' -GPO 'NotConfigured'
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
        $WinUpdateMeteredConnectionsMsg = 'Windows Update - Download Updates Over Metered Connections'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $WinUpdateMeteredConnections = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                    Entries = @(
                        @{
                            Name  = 'AllowAutoWindowsUpdateDownloadOverMeteredNetwork'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateMeteredConnectionsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinUpdateMeteredConnections
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
                #   allow updates to be downloaded automatically over metered connections
                # not configured: delete (default) | on: 1 | off: 0
                $WinUpdateMeteredConnectionsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowAutoWindowsUpdateDownloadOverMeteredNetwork'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateMeteredConnectionsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinUpdateMeteredConnectionsGpo
            }
        }
    }
}
