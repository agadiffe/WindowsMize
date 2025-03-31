#=================================================================================================================
# Time & Language > Typing > Advanced Keyboard Settings > Let Me Use A Different Input Method For Each App Window
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardUseDifferentInputMethodForEachApp
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-KeyboardUseDifferentInputMethodForEachApp
{
    <#
    .EXAMPLE
        PS> Set-KeyboardUseDifferentInputMethodForEachApp -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # default: off

        # Can also be configured with:
        #   'HKEY_CURRENT_USER\Control Panel\Desktop\UserPreferencesMask'
        #   5th byte, 8th bit\ on: 1 | off: 0 (default)

        $DifferentInputMethod = @{
            UseLegacySwitchMode  = $State -eq 'Enabled'
            UseLegacyLanguageBar = (Get-WinLanguageBarOption).IsLegacyLanguageBar
        }

        $DifferentInputMethodMsg = 'Let Me Use A Different Input Method For Each App Window'

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Methods: $DifferentInputMethodMsg' to '$State' ..."
        Set-WinLanguageBarOption @DifferentInputMethod

    }
}
