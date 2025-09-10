#=================================================================================================================
#                                  Privacy & Security > Search > Search History
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsSearchHistory
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsSearchHistory
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsSearchHistory -State 'Disabled'
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
        $WinPermissionsSearchHistory = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsDeviceSearchHistoryEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search Permissions: Search History' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsSearchHistory
    }
}
