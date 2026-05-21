#=================================================================================================================
#                  Personnalization > Start > Show Recent Items In Jump Lists And File Explorer
#=================================================================================================================

# not yet available

<#
.SYNTAX
    Set-StartShowRecentItemsInExplorer
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowRecentItemsInExplorer
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecentItemsInExplorer -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        return

        # on: 1 (default) | off: 0
        $RecentItemsInExplorer = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = '???'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Recent Items In Jump Lists And File Explorer' to '$State' ..."
        Set-RegistryEntry -InputObject $RecentItemsInExplorer
    }
}
