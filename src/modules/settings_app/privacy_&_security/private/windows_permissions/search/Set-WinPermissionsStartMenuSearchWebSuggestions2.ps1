#=================================================================================================================
#                           Privacy & Security > Search > Let Search Apps Show Results
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuSearchWebSuggestions2
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuSearchWebSuggestions2
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuSearchWebSuggestions2 -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsStartMenuWebSuggestionsMsg = 'Windows Permissions - Search: Let Search Apps Show Results'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsStartMenuWebSuggestions = @{
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

                Write-Verbose -Message "Setting '$WinPermissionsStartMenuWebSuggestionsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsStartMenuWebSuggestions
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   don't search the web or display web results in Search
                # not configured: delete (default) | on: 0
                $WinPermissionsStartMenuWebSuggestionsGpo = @{
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

                Write-Verbose -Message "Setting '$WinPermissionsStartMenuWebSuggestionsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsStartMenuWebSuggestionsGpo
            }
        }
    }
}
