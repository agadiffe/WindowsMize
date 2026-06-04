#=================================================================================================================
#    Accessibility > Narrator > Context Level > Read Hints On How To Interact With Buttons And Other Controls
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorReadInteractionHints
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorReadInteractionHints
{
    <#
    .EXAMPLE
        PS> Set-NarratorReadInteractionHints -State 'Enabled'
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
        $NarratorReadInteractionHints = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'ReadHints'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Context Level: Read Interaction Hints' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorReadInteractionHints
    }
}
