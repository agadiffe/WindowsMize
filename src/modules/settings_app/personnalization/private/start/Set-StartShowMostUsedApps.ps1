#=================================================================================================================
#                                 Personnalization > Start > Show Most Used Apps
#=================================================================================================================

# Requires 'settings > privacy > general > let Windows improve Start and search results by tracking app launches'

<#
.SYNTAX
    Set-StartShowMostUsedApps
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartShowMostUsedApps
{
    <#
    .EXAMPLE
        PS> Set-StartShowMostUsedApps -State 'Disabled' -GPO 'NotConfigured'
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
        $MostUsedAppsMsg = 'Start - Show Most Used Apps'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $StartMostUsedApps = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
                    Entries = @(
                        @{
                            Name  = 'ShowFrequentList'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$MostUsedAppsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartMostUsedApps
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   show or hide "most used" list from start menu
                # not configured: delete (default) | on: 1 | off: 2
                $StartMostUsedAppsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'ShowOrHideMostUsedApps'
                            Value = $GPO -eq 'Enabled' ? '1' : '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$MostUsedAppsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartMostUsedAppsGpo
            }
        }
    }
}
