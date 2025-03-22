#=================================================================================================================
#                            Accessibility > Narrator > Keyboard Shorcut For Narrator
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorKeyboardShorcut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorKeyboardShorcut
{
    <#
    .EXAMPLE
        PS> Set-NarratorKeyboardShorcut -State 'Disabled'
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
        $NarratorKeyboardShorcut = @{
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

        Write-Verbose -Message "Setting 'Narrator - Keyboard Shorcut' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorKeyboardShorcut
    }
}
