#=================================================================================================================
#                      Accessibility > Narrator > Sync The Narrator Cursor And System Focus
#=================================================================================================================

# When this is turned on, the Narrator cursor and the system cursor will be synchronized when possible.

<#
.SYNTAX
    Set-NarratorCursorSyncWithSystemFocus
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorCursorSyncWithSystemFocus
{
    <#
    .EXAMPLE
        PS> Set-NarratorCursorSyncWithSystemFocus -State 'Enabled'
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
        $NarratorCursorSyncWithSystemFocus = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'CoupleNarratorCursorKeyboard'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Sync The Narrator Cursor And System Focus' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorCursorSyncWithSystemFocus
    }
}
