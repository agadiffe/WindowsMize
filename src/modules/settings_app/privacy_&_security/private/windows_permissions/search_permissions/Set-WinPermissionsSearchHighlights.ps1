#=================================================================================================================
#                        Privacy & Security > Search Permissions > Show Search Highlights
#=================================================================================================================

# Also disabled if Set-StartMenuBingSearch is disabled (applications > management).

<#
.SYNTAX
    Set-WinPermissionsSearchHighlights
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsSearchHighlights
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsSearchHighlights -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsSearchHighlightsMsg = 'Windows Permissions - Search Permissions: Show Search Highlights'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsSearchHighlights = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
                    Entries = @(
                        @{
                            Name  = 'IsDynamicSearchBoxEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsSearchHighlightsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsSearchHighlights
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   allow search highlights
                # not configured: delete (default) | off: 0
                $WinPermissionsSearchHighlightsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'EnableDynamicContentInWSB'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsSearchHighlightsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsSearchHighlightsGpo
            }
        }
    }
}
