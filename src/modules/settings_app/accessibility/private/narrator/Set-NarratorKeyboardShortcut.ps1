#=================================================================================================================
#                            Accessibility > Narrator > Keyboard Shortcut For Narrator
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorKeyboardShortcut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorKeyboardShortcut
{
    <#
    .EXAMPLE
        PS> Set-NarratorKeyboardShortcut -State 'Disabled'
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
        $NarratorKeyboardShortcut = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'WinEnterLaunchEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Keyboard Shortcut' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorKeyboardShortcut
    }
}
