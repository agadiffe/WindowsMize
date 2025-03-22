#=================================================================================================================
#                      System > Multitasking > Show Tabs From Apps When Snapping or Alt+Tab
#=================================================================================================================

<#
.SYNTAX
    Set-MultitaskingShowAppsTabsOnSnapAndAltTab
        [[-State] {TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled}]
        [-GPO {TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MultitaskingShowAppsTabsOnSnapAndAltTab
{
    <#
    .EXAMPLE
        PS> Set-MultitaskingShowAppsTabsOnSnapAndAltTab -State 'ThreeMostRecent' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [AppsTabsOnSnapMode] $State,

        [GpoAppsTabsOnSnapMode] $GPO
    )

    process
    {
        $AppsTabsOnSnapAndAltTabMsg = 'Multitasking - Show Tabs From Apps When Snapping Or Pressing Alt+Tab'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 20 most recent tabs: 0 | 5 most recent tabs: 1 | 3 most recent tabs: 2 (default) | Don't show tabs: 3
                $AppsTabsOnSnapAndAltTab = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'MultiTaskingAltTabFilter'
                            Value = [int]$State
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AppsTabsOnSnapAndAltTabMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AppsTabsOnSnapAndAltTab
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > multitasking
                #   configure the inclusion of app tabs into Alt-Tab
                # not configured: delete (default)
                # open windows and 20 most recent tabs in apps: 1 | open windows and 5 most recent tabs in apps: 2
                # open windows and 3 most recent tabs in apps: 3 | open windows only: 4
                $AppsTabsOnSnapAndAltTabGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'MultiTaskingAltTabFilter'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AppsTabsOnSnapAndAltTabMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AppsTabsOnSnapAndAltTabGpo
            }
        }
    }
}
