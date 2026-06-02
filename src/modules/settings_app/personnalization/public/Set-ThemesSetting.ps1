#=================================================================================================================
#                                      Personnalization > Themes - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ThemesSetting
        [-DesktopIcons {ThisPC | UserFiles | Network | RecycleBin | ControlPanel}]
        [-ThemesCanChangeDesktopIcons {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ThemesSetting
{
    <#
    .EXAMPLE
        PS> Set-ThemesSetting -DesktopIcons 'ThisPC', 'Network' -ThemesCanChangeDesktopIcons 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [DesktopIcons[]] $DesktopIcons,

        [state] $ThemesCanChangeDesktopIcons
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
            'DesktopIcons'                { Set-ThemesDesktopIcons -Icon $DesktopIcons }
            'ThemesCanChangeDesktopIcons' { Set-ThemesCanChangeDesktopIcons -State $ThemesCanChangeDesktopIcons }
        }
    }
}
