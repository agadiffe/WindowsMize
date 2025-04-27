#=================================================================================================================
#    Time & Language > Typing > Advanced Keyboard Settings > Input Language Hot Keys > Switch Keyboard Layout
#=================================================================================================================

# 'Win + Space' hot key is not affected by this setting.

<#
.SYNTAX
    Set-KeyboardHotKeySwitchKeyboardLayout
        [-Value] {NotAssigned | CtrlShift | LeftAltShift | GraveAccent}
        [<CommonParameters>]
#>

function Set-KeyboardHotKeySwitchKeyboardLayout
{
    <#
    .EXAMPLE
        PS> Set-KeyboardHotKeySwitchKeyboardLayout -Value 'NotAssigned'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SwitchInputHotKeys] $Value
    )

    process
    {
        # NotAssigned: 3 | CtrlShift: 2 (default) | LeftAltShift: 1 | GraveAccent: 4
        $SwitchKeyboardLayoutHotkey = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Keyboard Layout\Toggle'
            Entries = @(
                @{
                    Name  = 'Layout Hotkey'
                    Value = [int]$Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Language Hot Keys: Switch Keyboard Layout' to '$Value' ..."
        Set-RegistryEntry -InputObject $SwitchKeyboardLayoutHotkey

        $LanguageHotkey = Get-LoggedOnUserItemPropertyValue -Path 'Keyboard Layout\Toggle' -Name 'Language Hotkey'
        if ($Value -ne 'NotAssigned' -and [int]$Value -eq $LanguageHotkey)
        {
            Write-Verbose -Message ('  Hot key is also assigned to ''Switch Input Language''.' +
                                   ' Resetting ''Switch Input Language'' to ''NotAssigned''.')
            Set-KeyboardHotKeySwitchInputLanguage -Value 'NotAssigned'
        }
    }
}
