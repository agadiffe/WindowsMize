#=================================================================================================================
#                                      Personnalization > Colors - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ColorsSetting
        [-Theme {Dark | Light}]
        [-Transparency {Disabled | Enabled}]
        [-AccentColorMode {Manual | Automatic}]
        [-ShowAccentColorOnStartAndTaskbar {Disabled | Enabled}]
        [-ShowAccentColorOnTitleAndBorders {Disabled | Enabled}]
        [<CommonParameters>]

    Set-ColorsSetting
        -AppsTheme {Dark | Light}
        -SystemTheme {Dark | Light}
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

    .EXAMPLE
        PS> Set-ColorsSetting -AppsTheme 'Dark' -SystemTheme 'Dark' -AccentColorMode 'Manual'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Theme')]
    param
    (
        [Parameter(ParameterSetName = 'Theme')]
        [ColorsTheme] $Theme,

        [Parameter(Mandatory, ParameterSetName = 'CustomTheme')]
        [ColorsTheme] $AppsTheme,

        [Parameter(Mandatory, ParameterSetName = 'CustomTheme')]
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
            'Theme'                            { Set-ColorsTheme -Value $Theme }
            'SystemTheme'                      { Set-ColorsTheme -System $SystemTheme -Apps $AppsTheme }
            'Transparency'                     { Set-ColorsTransparency -State $Transparency }
            'AccentColorMode'                  { Set-AccentColorMode -Value $AccentColorMode }
            'ShowAccentColorOnStartAndTaskbar' { Set-AccentColorShowOnStartAndTaskbar -State $ShowAccentColorOnStartAndTaskbar }
            'ShowAccentColorOnTitleAndBorders' { Set-AccentColorShowOnTitleAndBorders -State $ShowAccentColorOnTitleAndBorders }
        }
    }
}
