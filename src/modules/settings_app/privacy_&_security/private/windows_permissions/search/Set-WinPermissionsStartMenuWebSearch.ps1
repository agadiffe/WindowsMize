#=================================================================================================================
#                           Privacy & Security > Search > Let Search Apps Show Results
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuWebSearch
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuWebSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuWebSearch -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsStartMenuWebSearchMsg = 'Windows Permissions - Search: Let Search Apps Show Results'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsStartMenuWebSearch = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
                    Entries = @(
                        @{
                            Name  = 'IsGlobalWebSearchProviderToggleEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsStartMenuWebSearchMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsStartMenuWebSearch
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   don't search the web or display web results in Search
                # not configured: delete (default) | on: 0
                $WinPermissionsStartMenuWebSearchGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ConnectedSearchUseWeb'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsStartMenuWebSearchMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsStartMenuWebSearchGpo
            }
        }
    }
}
