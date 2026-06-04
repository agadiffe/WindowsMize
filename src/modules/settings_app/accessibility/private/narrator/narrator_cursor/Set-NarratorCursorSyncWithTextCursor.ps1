#=================================================================================================================
#         Accessibility > Narrator > Move My Text Cursor With The Narrator Cursor As Narrator Reads Text
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorCursorSyncWithTextCursor
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorCursorSyncWithTextCursor
{
    <#
    .EXAMPLE
        PS> Set-NarratorCursorSyncWithTextCursor -State 'Disabled'
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
        $NarratorCursorSyncWithTextCursor = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'FollowInsertionPoint'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Move My Text Cursor With The Narrator Cursor' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorCursorSyncWithTextCursor
    }
}
