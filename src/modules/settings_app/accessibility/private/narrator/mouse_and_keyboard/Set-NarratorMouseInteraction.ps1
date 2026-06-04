#=================================================================================================================
#                  Accessibility > Narrator > Read And Interact With The Screen Using The Mouse
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMouseInteraction
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorMouseInteraction
{
    <#
    .EXAMPLE
        PS> Set-NarratorMouseInteraction -State 'Disabled'
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
        $NarratorMouseInteraction = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'InteractionMouse'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Read And Interact With The Screen Using The Mouse' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorMouseInteraction
    }
}
