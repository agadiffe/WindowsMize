#=================================================================================================================
#                                     Accessibility > Keyboard > Filter Keys
#=================================================================================================================

# Filter Keys
#   Keyboard shortcut: right SHIFT is pressed for 8 seconds
#   Show the Filter keys icon on the taskbar
#   Beep when keys are pressed or accepted
#   Display a warning message when turning a setting on
#   Make a sound when turning a setting on or off

<#
.SYNTAX
    Set-KeyboardFilterKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShortcut {Disabled | Enabled}]
        [-ShowTrayIcon {Disabled | Enabled}]
        [-KeypressSound {Disabled | Enabled}]
        [-HotkeyActivationPrompt {Disabled | Enabled}]
        [-HotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardFilterKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardFilterKeys -State 'Disabled' -KeyboardShortcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShortcut,

        [state] $ShowTrayIcon,

        [state] $KeypressSound,

        [state] $HotkeyActivationPrompt,

        [state] $HotkeyToggleSound
    )

    process
    {
        $FilterKeysFlag = @{
            State                  = 0x00000001 # FKF_FILTERKEYSON\  1st bit\ on: 1 | off: 0 (default)
            KeyboardShortcut       = 0x00000004 # FKF_HOTKEYACTIVE\  3rd bit\ on: 1 (default) | off: 0
            ShowTrayIcon           = 0x00000020 # FKF_INDICATOR\     6th bit\ on: 1 (default) | off: 0
            KeypressSound          = 0x00000040 # FKF_CLICKON\       7th bit\ on: 1 (default) | off: 0
            HotkeyActivationPrompt = 0x00000008 # FKF_CONFIRMHOTKEY\ 4th bit\ on: 1 (default) | off: 0
            HotkeyToggleSound      = 0x00000010 # FKF_HOTKEYSOUND\   5th bit\ on: 1 (default) | off: 0
        }

        $FilterKeysRegPath = 'Control Panel\Accessibility\Keyboard Response'
        $FilterKeysSetting = Get-LoggedOnUserItemPropertyValue -Path $FilterKeysRegPath -Name 'Flags'

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Write-Verbose -Message "Setting 'Keyboard Filter Keys - $($Param.Key)' to '$($Param.Value)' ..."

            $BitFlagParam = @{
                Flags   = $FilterKeysSetting
                BitFlag = $FilterKeysFlag[$Param.Key]
                State   = $Param.Value -eq 'Enabled'
            }
            $FilterKeysSetting = Get-UpdatedIntegerBitFlag @BitFlagParam
        }

        $KeyboardFilterKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\Keyboard Response'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $FilterKeysSetting
                    Type  = 'String'
                }
            )
        }

        if ($PSBoundParameters.Count -gt 1)
        {
            Write-Verbose -Message 'Keyboard Filter Keys Flags:'
        }
        Set-RegistryEntry -InputObject $KeyboardFilterKeys
    }
}
