#=================================================================================================================
# Accessibility > Narrator > Read And Interact With The Screen Using The Mouse > Narrator Cursor Follow My Mouse
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorCursorFollowMouse
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorCursorFollowMouse
{
    <#
    .EXAMPLE
        PS> Set-NarratorCursorFollowMouse -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $NarratorCursorFollowMouse = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'CoupleNarratorCursorMouse'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Mouse Interaction: Narrator Cursor Follow My Mouse' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorCursorFollowMouse
    }
}
