#=================================================================================================================
#                           Personnalization > Start > Show Recent And Suggested Files
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowRecentFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowRecentFiles
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecentFiles -State 'Enabled'
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
        $RecentFiles = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'ShowSuggestedFiles'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Recent And Suggested Files' to '$State' ..."
        Set-RegistryEntry -InputObject $RecentFiles
    }
}
