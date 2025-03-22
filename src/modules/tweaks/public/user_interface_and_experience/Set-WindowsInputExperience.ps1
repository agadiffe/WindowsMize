#=================================================================================================================
#                                            Windows Input Experience
#=================================================================================================================

# It manages several input-related tasks:
#   Text Input: Manages keyboard input, including predictive text and auto-correction features.
#   Pen and Touch Input: Supports inputs from touchscreens and stylus pens, facilitating handwriting recognition and touch gestures.
#   Speech Recognition: Enables voice inputs, commands, and dictation features.
#   Input Method Editors (IMEs): Supports different language inputs and character sets, especially for non-Latin scripts.

# Recommendation: Disabled (Depends on your hardware and usage)
# Keyboard will of course still works even if disabled.

<#
.SYNTAX
    Set-WindowsInputExperience
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WindowsInputExperience
{
    <#
    .EXAMPLE
        PS> Set-WindowsInputExperience -State 'Disabled'
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
        $WindowsInputExperience = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Input'
            Entries = @(
                @{
                    Name  = 'IsInputAppPreloadEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Input Experience' to '$State' ..."
        Set-RegistryEntry -InputObject $WindowsInputExperience
    }
}
