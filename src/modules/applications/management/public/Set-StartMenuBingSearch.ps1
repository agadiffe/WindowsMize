#=================================================================================================================
#                                             Start Menu Bing Search
#=================================================================================================================

<#
.SYNTAX
    Set-StartMenuBingSearch
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartMenuBingSearch
{
    <#
    .EXAMPLE
        PS> Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'
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
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $StartMenuBingSearchMsg = 'Start Menu Bing Search'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0

                $StartMenuBingSearch = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Search'
                    Entries = @(
                        @{
                            Name  = 'BingSearchEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StartMenuBingSearchMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartMenuBingSearch
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > file explorer
                #   turn off display of recent search entries in the File Explorer search box
                # not configured: delete (default) | on: 1

                $StartMenuBingSearchGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableSearchBoxSuggestions'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$StartMenuBingSearchMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartMenuBingSearchGpo
            }
        }
    }
}
