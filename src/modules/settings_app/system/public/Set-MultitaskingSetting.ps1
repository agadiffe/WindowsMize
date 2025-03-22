#=================================================================================================================
#                                        System > Multitasking - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-MultitaskingSetting
        [-ShowAppsTabsOnSnapAndAltTab {TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled}]
        [-ShowAppsTabsOnSnapAndAltTabGPO {TwentyMostRecent | FiveMostRecent | ThreeMostRecent | Disabled | NotConfigured}]
        [-ShowAllWindowsOnTaskbar {AllDesktops | CurrentDesktop}]
        [-ShowAllWindowsOnAltTab {AllDesktops | CurrentDesktop}]
        [-TitleBarWindowShake {Disabled | Enabled}]
        [-TitleBarWindowShakeGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MultitaskingSetting
{
    <#
    .EXAMPLE
        PS> Set-MultitaskingSetting -MainToggle 'Enabled' -TitleBarWindowShake 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [AppsTabsOnSnapMode] $ShowAppsTabsOnSnapAndAltTab,

        [GpoAppsTabsOnSnapMode] $ShowAppsTabsOnSnapAndAltTabGPO,

        [WindowVisibilty] $ShowAllWindowsOnTaskbar,

        [WindowVisibilty] $ShowAllWindowsOnAltTab,

        [state] $TitleBarWindowShake,

        [GpoStateWithoutEnabled] $TitleBarWindowShakeGPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'ShowAppsTabsOnSnapAndAltTab'    { Set-MultitaskingShowAppsTabsOnSnapAndAltTab -State $ShowAppsTabsOnSnapAndAltTab }
            'ShowAppsTabsOnSnapAndAltTabGPO' { Set-MultitaskingShowAppsTabsOnSnapAndAltTab -GPO $ShowAppsTabsOnSnapAndAltTabGPO }
            'ShowAllWindowsOnTaskbar'        { Set-VirtualDesktopShowAllWindowsOnTaskbar -Value $ShowAllWindowsOnTaskbar }
            'ShowAllWindowsOnAltTab'         { Set-VirtualDesktopShowAllWindowsOnAltTab -Value $ShowAllWindowsOnAltTab }
            'TitleBarWindowShake'            { Set-TitleBarWindowShake -State $TitleBarWindowShake }
            'TitleBarWindowShakeGPO'         { Set-TitleBarWindowShake -GPO $TitleBarWindowShakeGPO }
        }
    }
}
