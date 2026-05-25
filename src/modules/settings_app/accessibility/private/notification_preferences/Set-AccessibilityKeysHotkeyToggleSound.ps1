#=================================================================================================================
#                       Accessibility > Notification Preferences > Hotkey Activation Sound
#=================================================================================================================

# Play a sound when I turn Contrast Themes, Mouse, Sticky, Filter, or Toggle keys on or off from the keyboard
# control panel wording: Make a sound when turning a setting on or off

# Also see the comment in Set-AccessibilityKeysActivationDialog.ps1

<#
.SYNTAX
    Set-AccessibilityKeysHotkeyToggleSound
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AccessibilityKeysHotkeyToggleSound
{
    <#
    .EXAMPLE
        PS> Set-AccessibilityKeysHotkeyToggleSound -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $HotkeyToggleSound = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility'
            Entries = @(
                @{
                    Name  = 'Sound on Activation'
                    Value = $State
                    Type  = 'DWord'
                }
            )
        }

        $NotifKeysMsg = 'Contrast Themes, Mouse, Sticky, Filter, or Toggle keys'
        Write-Verbose -Message "Setting 'Accessibility - Play a sound when I turn $NotifKeysMsg keys on or off from the keyboard' to '$State' ..."
        Set-RegistryEntry -InputObject $HotkeyToggleSound

        Set-ContrastThemes -HotkeyToggleSound $State
        Set-KeyboardFilterKeys -HotkeyToggleSound $State
        Set-KeyboardStickyKeys -HotkeyToggleSound $State
        Set-KeyboardToggleKeysTone -HotkeyToggleSound $State
        Set-MouseKeys -HotkeyToggleSound $State
    }
}
