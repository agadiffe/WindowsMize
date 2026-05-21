#=================================================================================================================
#                               Personnalization > Start > Show Recently Added Apps
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowRecentAddedApps
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartShowRecentAddedApps
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecentAddedApps -State 'Disabled' -GPO 'NotConfigured'
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
        $RecentAddedAppsMsg = 'Start - Show Recently Added Apps'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $StartRecentAddedApps = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
                    Entries = @(
                        @{
                            Name  = 'ShowRecentList'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentAddedAppsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartRecentAddedApps
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   remove "recently added" list from start menu
                # not configured: delete (default) | on: 1
                $StartRecentAddedAppsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'HideRecentlyAddedApps'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentAddedAppsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartRecentAddedAppsGpo
            }
        }
    }
}
