#=================================================================================================================
#     Time & Language > Typing > Advanced Keyboard Settings > Input Language Hot Keys > Switch Input Language
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardHotKeySwitchInputLanguage
        [-Value] {NotAssigned | CtrlShift | LeftAltShift | GraveAccent}
        [<CommonParameters>]
#>

function Set-KeyboardHotKeySwitchInputLanguage
{
    <#
    .EXAMPLE
        PS> Set-KeyboardHotKeySwitchInputLanguage -Value 'NotAssigned'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SwitchInputHotKeys] $Value
    )

    process
    {
        # NotAssigned: 3 | CtrlShift: 2 | LeftAltShift: 1 (default) | GraveAccent: 4
        $SwitchInputLanguageHotkey = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Keyboard Layout\Toggle'
            Entries = @(
                @{
                    Name  = 'Hotkey'
                    Value = [int]$Value
                    Type  = 'String'
                }
                @{
                    Name  = 'Language Hotkey'
                    Value = [int]$Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Typing - Keyboard Input Language Hot Keys: Switch Input Language' to '$Value' ..."
        Set-RegistryEntry -InputObject $SwitchInputLanguageHotkey

        $LayoutHotkey = Get-LoggedOnUserItemPropertyValue -Path 'Keyboard Layout\Toggle' -Name 'Layout Hotkey'
        if ($Value -ne 'NotAssigned' -and [int]$Value -eq $LayoutHotkey)
        {
            Write-Verbose -Message ('  Hot key is also assigned to ''Switch Keyboard Layout''.' +
                                   ' Resetting ''Switch Keyboard Layout'' to ''NotAssigned''.')
            Set-KeyboardHotKeySwitchKeyboardLayout -Value 'NotAssigned'
        }
    }
}
