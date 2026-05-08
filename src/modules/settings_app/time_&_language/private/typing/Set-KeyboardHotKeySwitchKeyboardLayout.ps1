#=================================================================================================================
#    Time & Language > Typing > Advanced Keyboard Settings > Input Language Hot Keys > Switch Keyboard Layout
#=================================================================================================================

# 'Win + Space' hot key is not affected by this setting.

<#
.SYNTAX
    Set-KeyboardHotKeySwitchKeyboardLayout
        [-Hotkey] {NotAssigned | CtrlShift | LeftAltShift | GraveAccent}
        [<CommonParameters>]
#>

function Set-KeyboardHotKeySwitchKeyboardLayout
{
    <#
    .EXAMPLE
        PS> Set-KeyboardHotKeySwitchKeyboardLayout -Hotkey 'NotAssigned'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SwitchInputHotKeys] $Hotkey
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
                    Value = [int]$Hotkey
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Language Hot Keys: Switch Keyboard Layout' to '$Hotkey' ..."
        Set-RegistryEntry -InputObject $SwitchKeyboardLayoutHotkey

        $LanguageHotkey = Get-LoggedOnUserItemPropertyValue -Path 'Keyboard Layout\Toggle' -Name 'Language Hotkey'
        if ($Hotkey -ne 'NotAssigned' -and [int]$Hotkey -eq $LanguageHotkey)
        {
            Write-Verbose -Message ('  Hot key is also assigned to ''Switch Input Language''.' +
                                   ' Resetting ''Switch Input Language'' to ''NotAssigned''.')
            Set-KeyboardHotKeySwitchInputLanguage -Hotkey 'NotAssigned'
        }
    }
}
