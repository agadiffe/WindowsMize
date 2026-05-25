#=================================================================================================================
#                                       Accessibility > Mouse > Mouse Keys
#=================================================================================================================

# Mouse Keys
#   Keyboard shortcut: left ALT + left SHIFT + NUM LOCK
#   Only use mouse keys when Num lock is on
#   Show the mouse keys icon on the taskbar
#   Hold the Ctrl key to speed up and Shift key to slow down
#   Display a warning message when turning a setting on
#   Make a sound when turning a setting on or off

<#
.SYNTAX
    Set-MouseKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShortcut {Disabled | Enabled}]
        [-UseWhenNumLockOn {Disabled | Enabled}]
        [-ShowTrayIcon {Disabled | Enabled}]
        [-CtrlShiftSpeedAdjust {Disabled | Enabled}]
        [-HotkeyActivationPrompt {Disabled | Enabled}]
        [-HotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MouseKeys
{
    <#
    .EXAMPLE
        PS> Set-MouseKeys -State 'Disabled' -KeyboardShortcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShortcut,

        [state] $UseWhenNumLockOn,

        [state] $ShowTrayIcon,

        [state] $CtrlShiftSpeedAdjust,

        [state] $HotkeyActivationPrompt,

        [state] $HotkeyToggleSound
    )

    process
    {
        $MouseKeysFlag = @{
            State                  = 0x00000001 # MKF_MOUSEKEYSON\    1st bit\ on: 1 | off: 0 (default)
            KeyboardShortcut       = 0x00000004 # MKF_HOTKEYACTIVE\   3rd bit\ on: 1 (default) | off: 0
            UseWhenNumLockOn       = 0x00000080 # MKF_REPLACENUMBERS\ 8th bit\ on: 1 (default) | off: 0
            ShowTrayIcon           = 0x00000020 # MKF_INDICATOR\      6th bit\ on: 1 | off: 0 (default)
            CtrlShiftSpeedAdjust   = 0x00000040 # MKF_MODIFIERS\      7th bit\ on: 1 | off: 0 (default)
            HotkeyActivationPrompt = 0x00000008 # MKF_CONFIRMHOTKEY\  4th bit\ on: 1 (default) | off: 0
            HotkeyToggleSound      = 0x00000010 # MKF_HOTKEYSOUND\    5th bit\ on: 1 (default) | off: 0
        }

        $MouseKeysRegPath = 'Control Panel\Accessibility\MouseKeys'
        $MouseKeysSetting = Get-LoggedOnUserItemPropertyValue -Path $MouseKeysRegPath -Name 'Flags'

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Write-Verbose -Message "Setting 'Mouse Keys - $($Param.Key)' to '$($Param.Value)' ..."

            $BitFlagParam = @{
                Flags   = $MouseKeysSetting
                BitFlag = $MouseKeysFlag[$Param.Key]
                State   = $Param.Value -eq 'Enabled'
            }
            $MouseKeysSetting = Get-UpdatedIntegerBitFlag @BitFlagParam
        }

        $MouseKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\MouseKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $MouseKeysSetting
                    Type  = 'String'
                }
            )
        }

        if ($PSBoundParameters.Count -gt 1)
        {
            Write-Verbose -Message 'Mouse Keys Flags:'
        }
        Set-RegistryEntry -InputObject $MouseKeys
    }
}
