#=================================================================================================================
#                       Accessibility > Notification Preferences > Hotkey Activation Prompt
#=================================================================================================================

# Notify me when I turn on Contrast Themes, Mouse, Sticky, Filter, or Toggle keys from the keyboard
# control panel wording: Display a warning message when turning a setting on

# The registry entry 'Warning Sounds' control the GUI toggle for all the accessibility keys.
# It doesn't control the setting behavior, only the visual GUI toggle.
# We can deativate the feature for one setting but the GUI toggle will be deactivated for all of them.
# In control panel, they are all linked and toggling a setting will apply to all of them.
# This is not the case for the Windows Settings app ...

<#
.SYNTAX
    Set-AccessibilityKeysHotkeyActivationPrompt
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AccessibilityKeysHotkeyActivationPrompt
{
    <#
    .EXAMPLE
        PS> Set-AccessibilityKeysHotkeyActivationPrompt -State 'Disabled'
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
        $HotkeyActivationPrompt = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility'
            Entries = @(
                @{
                    Name  = 'Warning Sounds'
                    Value = $State
                    Type  = 'DWord'
                }
            )
        }

        $NotifKeysMsg = 'Contrast Themes, Mouse, Sticky, Filter, or Toggle'
        Write-Verbose -Message "Setting 'Accessibility - Notify me when I turn on $NotifKeysMsg keys from the keyboard' to '$State' ..."
        Set-RegistryEntry -InputObject $HotkeyActivationPrompt

        Set-ContrastThemes -HotkeyActivationPrompt $State
        Set-KeyboardFilterKeys -HotkeyActivationPrompt $State
        Set-KeyboardStickyKeys -HotkeyActivationPrompt $State
        Set-KeyboardToggleKeysTone -HotkeyActivationPrompt $State
        Set-MouseKeys -HotkeyActivationPrompt $State
    }
}
