#=================================================================================================================
#                   Privacy & Security > Search > Show Suggested Search Results > Web Searches
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuSearchWebSuggestions3
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuSearchWebSuggestions3
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuSearchWebSuggestions3 -State 'Disabled' -GPO 'Disabled'
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

        $StartMenuWebSuggestionsMsg = 'Start Menu Bing Search'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0

                $StartMenuWebSuggestions = @{
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

                Write-Verbose -Message "Setting '$StartMenuWebSuggestionsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartMenuWebSuggestions
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > file explorer
                #   turn off display of recent search entries in the File Explorer search box
                # not configured: delete (default) | on: 1

                $StartMenuWebSuggestionsGpo = @{
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

                Write-Verbose -Message "Setting '$StartMenuWebSuggestionsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartMenuWebSuggestionsGpo
            }
        }
    }
}
