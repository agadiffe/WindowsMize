#=================================================================================================================
#                               Accessibility > Narrator > Show The Narrator Cursor
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorShowNarratorCursor
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorShowNarratorCursor
{
    <#
    .EXAMPLE
        PS> Set-NarratorShowNarratorCursor -State 'Enabled'
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
        $ShowNarratorCursor = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'NarratorCursorHighlight'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Show The Narrator Cursor' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowNarratorCursor
    }
}
