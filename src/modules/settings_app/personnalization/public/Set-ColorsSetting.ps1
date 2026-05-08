#=================================================================================================================
#                                      Personnalization > Colors - Settings
#=================================================================================================================

<#
    Set-ColorsSetting
        [-Theme {Dark | Light}]
        [-AppsTheme {Dark | Light}]
        [-SystemTheme {Dark | Light}]
        [-Transparency {Disabled | Enabled}]
        [-AccentColorMode {Manual | Automatic}]
        [-ShowAccentColorOnStartAndTaskbar {Disabled | Enabled}]
        [-ShowAccentColorOnTitleAndBorders {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ColorsSetting
{
    <#
    .EXAMPLE
        PS> Set-ColorsSetting -Theme 'Dark' -Transparency 'Disabled' -AccentColorMode 'Manual'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [ColorsTheme] $Theme,

        [ColorsTheme] $AppsTheme,

        [ColorsTheme] $SystemTheme,

        [state] $Transparency,

        [AccentColorMode] $AccentColorMode,

        [state] $ShowAccentColorOnStartAndTaskbar,

        [state] $ShowAccentColorOnTitleAndBorders
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
            'Theme'                            { Set-ColorsTheme -Mode $Theme }
            'AppsTheme'                        { Set-ColorsTheme -Apps $AppsTheme }
            'SystemTheme'                      { Set-ColorsTheme -System $SystemTheme }
            'Transparency'                     { Set-ColorsTransparency -State $Transparency }
            'AccentColorMode'                  { Set-AccentColorMode -Mode $AccentColorMode }
            'ShowAccentColorOnStartAndTaskbar' { Set-AccentColorShowOnStartAndTaskbar -State $ShowAccentColorOnStartAndTaskbar }
            'ShowAccentColorOnTitleAndBorders' { Set-AccentColorShowOnTitleAndBorders -State $ShowAccentColorOnTitleAndBorders }
        }
    }
}
