#=================================================================================================================
#                  Time & Language > Typing > Advanced Keyboard Settings > Language Bar Options
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardLanguageBar
        [-Value] {FloatingOnDesktop | DockedInTaskbar | Hidden}
        [<CommonParameters>]
#>

function Set-KeyboardLanguageBar
{
    <#
    .EXAMPLE
        PS> Set-KeyboardLanguageBar -Value 'DockedInTaskbar'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [LanguageBarMode] $Value
    )

    process
    {
        # FloatingOnDesktop\ 'desktop language bar' to 'on' + ShowStatus 0
        # DockedInTaskbar (default)\ 'desktop language bar' to 'off' + ShowStatus 4 (or whatever)
        # Hidden\ 'desktop language bar' to 'on' + ShowStatus 3

        # "Use the desktop language bar when it's available" can also be configured with:
        #   'HKEY_CURRENT_USER\Control Panel\Desktop\UserPreferencesMask'
        #   6th byte, 1st bit\ on: 1 | off: 0 (default)

        $DesktopLanguageBarState = $Value -ne 'DockedInTaskbar'
        $DesktopLanguageBar = @{
            UseLegacySwitchMode  = (Get-WinLanguageBarOption).IsLegacySwitchingMode
            UseLegacyLanguageBar = $DesktopLanguageBarState
        }

        $DesktopLanguageBarMsg = "Use the desktop language bar when it's available"
        $DesktopLanguageBarStateMsg = $DesktopLanguageBarState ? 'Enabled' : 'Disabled'

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Methods: $DesktopLanguageBarMsg' to '$DesktopLanguageBarStateMsg' ..."
        Set-WinLanguageBarOption @DesktopLanguageBar

        $LanguageBar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\CTF\LangBar'
            Entries = @(
                @{
                    Name  = 'ShowStatus'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Methods: Language Bar Options' to '$Value' ..."
        Set-RegistryEntry -InputObject $LanguageBar
    }
}
