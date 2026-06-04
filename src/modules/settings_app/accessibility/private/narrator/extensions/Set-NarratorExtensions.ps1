#=================================================================================================================
#                              Accessibility > Narrator > Enable Narrator Extensions
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorExtensions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorExtensions
{
    <#
    .EXAMPLE
        PS> Set-NarratorExtensions -State 'Enabled'
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
        $NarratorExtensions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'ScriptingEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator Extensions' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorExtensions
    }
}
