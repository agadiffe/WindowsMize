#=================================================================================================================
#                                   Personnalization > Start > Recent (Section)
#=================================================================================================================

<#
.SYNTAX
    Set-StartRecentSection
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartRecentSection
{
    <#
    .EXAMPLE
        PS> Set-StartRecentSection -State 'Disabled' -GPO 'NotConfigured'
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
        $RecentSectionMsg = 'Start - Recent Section'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $RecentSection = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
                    Entries = @(
                        @{
                            Name  = 'ShowRecentSection'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentSectionMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $RecentSection
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   remove recommended section from Start Menu
                # not configured: delete (default) | on: 1
                $RecentSectionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'HideRecommendedSection'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentSectionMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $RecentSectionGpo
            }
        }
    }
}
