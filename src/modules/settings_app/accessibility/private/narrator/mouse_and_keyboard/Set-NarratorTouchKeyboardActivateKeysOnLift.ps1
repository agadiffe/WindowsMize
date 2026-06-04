#=================================================================================================================
#               Accessibility > Narrator > On Touch Keyboards, Activate Keys When I Lift My Finger
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorTouchKeyboardActivateKeysOnLift
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorTouchKeyboardActivateKeysOnLift
{
    <#
    .EXAMPLE
        PS> Set-NarratorTouchKeyboardActivateKeysOnLift -State 'Disabled'
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
        $NarratorTouchKeyboardActivateKeysOnLift = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'FastKeyEntryEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - On Touch Keyboards, Activate Keys When I Lift My Finger' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorTouchKeyboardActivateKeysOnLift
    }
}
