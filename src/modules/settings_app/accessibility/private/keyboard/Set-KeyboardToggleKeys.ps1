#=================================================================================================================
#                                     Accessibility > Keyboard > Toggle Keys
#=================================================================================================================

# Toggle Keys
#   Keyboard shortcut: NUM LOCK key is pressed for 5 seconds
#   Display a warning message when turning a setting on
#   Make a sound when turning a setting on or off

<#
.SYNTAX
    Set-KeyboardToggleKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShortcut {Disabled | Enabled}]
        [-HotkeyActivationPrompt {Disabled | Enabled}]
        [-HotkeyToggleSound {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardToggleKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardToggleKeys -State 'Disabled' -KeyboardShortcut 'Disabled'
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
        $ToggleKeysFlag = @{
            State                  = 0x00000001 # TKF_TOGGLEKEYSON\  1st bit\ on: 1 | off: 0 (default)
            KeyboardShortcut       = 0x00000004 # TKF_HOTKEYACTIVE\  3rd bit\ on: 1 (default) | off: 0
            HotkeyActivationPrompt = 0x00000008 # TKF_CONFIRMHOTKEY\ 4th bit\ on: 1 (default) | off: 0
            HotkeyToggleSound      = 0x00000010 # TKF_HOTKEYSOUND\   5th bit\ on: 1 (default) | off: 0
        }

        $ToggleKeysRegPath = 'Control Panel\Accessibility\ToggleKeys'
        $ToggleKeysSetting = Get-LoggedOnUserItemPropertyValue -Path $ToggleKeysRegPath -Name 'Flags'

        foreach ($Param in $PSBoundParameters.GetEnumerator())
        {
            Write-Verbose -Message "Setting 'Keyboard Toggle Keys - $($Param.Key)' to '$($Param.Value)' ..."

            $BitFlagParam = @{
                Flags   = $ToggleKeysSetting
                BitFlag = $ToggleKeysFlag[$Param.Key]
                State   = $Param.Value -eq 'Enabled'
            }
            $ToggleKeysSetting = Get-UpdatedIntegerBitFlag @BitFlagParam
        }

        $KeyboardToggleKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\ToggleKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $ToggleKeysSetting
                    Type  = 'String'
                }
            )
        }

        if ($PSBoundParameters.Count -gt 1)
        {
            Write-Verbose -Message 'Keyboard Toggle Keys Flags:'
        }
        Set-RegistryEntry -InputObject $KeyboardToggleKeys
    }
}
