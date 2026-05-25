#=================================================================================================================
#                                         Accessibility > Contrast Themes
#=================================================================================================================

# Contrast Themes
#   Keyboard shortcut: left ALT + left SHIFT + PRINT SCREEN

<#
.SYNTAX
    Set-ContrastThemes
        [-KeyboardShortcut {Disabled | Enabled}]
        [-HotkeyActivationPrompt {Disabled | Enabled}]
        [-HotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ContrastThemes
{
    <#
    .EXAMPLE
        PS> Set-ContrastThemes -KeyboardShortcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShortcut,

        [state] $HotkeyActivationPrompt,

        [state] $HotkeyToggleSound
    )

    process
    {
        $ContrastThemesFlag = @{
            KeyboardShortcut       = 0x00000004 # HCF_HOTKEYACTIVE\  3rd bit\ on: 1 (default) | off: 0
            HotkeyActivationPrompt = 0x00000008 # HCF_CONFIRMHOTKEY\ 4th bit\ on: 1 (default) | off: 0
            HotkeyToggleSound      = 0x00000010 # HCF_HOTKEYSOUND\   5th bit\ on: 1 (default) | off: 0
        }

        $ContrastThemesRegPath = 'Control Panel\Accessibility\HighContrast'
        $ContrastThemesSetting = Get-LoggedOnUserItemPropertyValue -Path $ContrastThemesRegPath -Name 'Flags'

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Write-Verbose -Message "Setting 'Contrast Themes - $($Param.Key)' to '$($Param.Value)' ..."

            $BitFlagParam = @{
                Flags   = $ContrastThemesSetting
                BitFlag = $ContrastThemesFlag[$Param.Key]
                State   = $Param.Value -eq 'Enabled'
            }
            $ContrastThemesSetting = Get-UpdatedIntegerBitFlag @BitFlagParam
        }

        $ContrastThemes = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\HighContrast'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $ContrastThemesSetting
                    Type  = 'String'
                }
            )
        }

        if ($PSBoundParameters.Count -gt 1)
        {
            Write-Verbose -Message 'Contrast Themes Flags:'
        }
        Set-RegistryEntry -InputObject $ContrastThemes
    }
}
