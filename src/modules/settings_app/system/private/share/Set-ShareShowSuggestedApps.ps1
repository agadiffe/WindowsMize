#=================================================================================================================
#                            System > Share > Show Me Suggested Apps In Share Surfaces
#=================================================================================================================

<#
.SYNTAX
    Set-ShareShowSuggestedApps
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ShareShowSuggestedApps
{
    <#
    .EXAMPLE
        PS> Set-ShareShowSuggestedApps -State 'Disabled'
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
        $ShareShowSuggestedApps = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
            Entries = @(
                @{
                    Name  = 'EnablePromotionalAppsForShare'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Share - Show Me Suggested Apps In Share Surfaces' to '$State' ..."
        Set-RegistryEntry -InputObject $ShareShowSuggestedApps
    }
}
