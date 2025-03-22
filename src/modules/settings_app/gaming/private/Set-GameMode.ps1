#=================================================================================================================
#                                               Gaming > Game Mode
#=================================================================================================================

<#
.SYNTAX
    Set-GameMode
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-GameMode
{
    <#
    .EXAMPLE
        PS> Set-GameMode -State 'Disabled'
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
        $GameMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\GameBar'
            Entries = @(
                @{
                    Name  = 'AutoGameModeEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Gaming - Game Mode' to '$State' ..."
        Set-RegistryEntry -InputObject $GameMode
    }
}
