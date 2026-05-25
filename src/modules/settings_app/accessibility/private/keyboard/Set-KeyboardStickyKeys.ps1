#=================================================================================================================
#                                     Accessibility > Keyboard > Sticky Keys
#=================================================================================================================

# Sticky Keys
#   Keyboard shortcut: SHIFT is pressed five times
#   Show the Sticky keys icon on the taskbar
#   Lock shortcut keys when pressed twice in a row
#   Turn off Sticky keys when two keys are pressed at the same time
#   Play a sound when shortcut keys are pressed and released
#   Display a warning message when turning a setting on
#   Make a sound when turning a setting on or off

<#
.SYNTAX
    Set-KeyboardStickyKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShortcut {Disabled | Enabled}]
        [-ShowTrayIcon {Disabled | Enabled}]
        [-LockOnDoublePress {Disabled | Enabled}]
        [-DisableOnTwoKeypress {Disabled | Enabled}]
        [-KeypressSound {Disabled | Enabled}]
        [-HotkeyActivationPrompt {Disabled | Enabled}]
        [-HotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardStickyKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardStickyKeys -State 'Disabled' -KeyboardShortcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShortcut,

        [state] $ShowTrayIcon,

        [state] $LockOnDoublePress,

        [state] $DisableOnTwoKeypress,

        [state] $KeypressSound,

        [state] $HotkeyActivationPrompt,

        [state] $HotkeyToggleSound
    )

    process
    {
        $StickyKeysFlag = @{
            State                  = 0x00000001 # SKF_STICKYKEYSON\    1st bit\ on: 1 | off: 0 (default)
            KeyboardShortcut       = 0x00000004 # SKF_HOTKEYACTIVE\    3rd bit\ on: 1 (default) | off: 0
            ShowTrayIcon           = 0x00000020 # SKF_INDICATOR\       6th bit\ on: 1 (default) | off: 0
            LockOnDoublePress      = 0x00000080 # SKF_TRISTATE\        8th bit\ on: 1 (default) | off: 0
            DisableOnTwoKeypress   = 0x00000100 # SKF_TWOKEYSOFF\      9th bit\ on: 1 (default) | off: 0
            KeypressSound          = 0x00000040 # SKF_AUDIBLEFEEDBACK\ 7th bit\ on: 1 (default) | off: 0
            HotkeyActivationPrompt = 0x00000008 # SKF_CONFIRMHOTKEY\   4th bit\ on: 1 (default) | off: 0
            HotkeyToggleSound      = 0x00000010 # SKF_HOTKEYSOUND\     5th bit\ on: 1 (default) | off: 0
        }

        $StickyKeysRegPath = 'Control Panel\Accessibility\StickyKeys'
        $StickyKeysSetting = Get-LoggedOnUserItemPropertyValue -Path $StickyKeysRegPath -Name 'Flags'

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Write-Verbose -Message "Setting 'Keyboard Sticky Keys - $($Param.Key)' to '$($Param.Value)' ..."

            $BitFlagParam = @{
                Flags   = $StickyKeysSetting
                BitFlag = $StickyKeysFlag[$Param.Key]
                State   = $Param.Value -eq 'Enabled'
            }
            $StickyKeysSetting = Get-UpdatedIntegerBitFlag @BitFlagParam
        }

        $KeyboardStickyKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\StickyKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $StickyKeysSetting
                    Type  = 'String'
                }
            )
        }

        if ($PSBoundParameters.Count -gt 1)
        {
            Write-Verbose -Message 'Keyboard Sticky Keys Flags:'
        }
        Set-RegistryEntry -InputObject $KeyboardStickyKeys
    }
}
