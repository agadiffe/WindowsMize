#=================================================================================================================
#                                      Personnalization > Themes - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ThemesSetting
        [-DesktopIcons {ThisPC | UserFiles | Network | RecycleBin | ControlPanel}]
        [-ThemesCanChangeDesktopIcons {Disabled | Enabled}]
        [<CommonParameters>]

    Set-ThemesSetting
        [-HideAllDesktopIcons]
        [-ThemesCanChangeDesktopIcons {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ThemesSetting
{
    <#
    .EXAMPLE
        PS> Set-ThemesSetting -DesktopIcons 'ThisPC', 'Network' -ThemesCanChangeDesktopIcons 'Disabled'

    .EXAMPLE
        PS> Set-ThemesSetting -HideAllDesktopIcons -ThemesCanChangeDesktopIcons 'Disabled'
    #>

    [CmdletBinding(DefaultParameterSetName = 'DesktopIcons')]
    param
    (
        [Parameter(ParameterSetName = 'DesktopIcons')]
        [DesktopIcons[]] $DesktopIcons,

        [Parameter(ParameterSetName = 'HideAllDesktopIcons')]
        [switch] $HideAllDesktopIcons,

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
            'DesktopIcons'                { Set-ThemesDesktopIcons -Value $DesktopIcons }
            'HideAllDesktopIcons'         { Set-ThemesDesktopIcons -HideAll:$HideAllDesktopIcons }
            'ThemesCanChangeDesktopIcons' { Set-ThemesCanChangeDesktopIcons -State $ThemesCanChangeDesktopIcons }
        }
    }
}
