#=================================================================================================================
#                     Privacy & Security > Search Permissions > Let Search Apps Show Results
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsWebSearch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsWebSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsWebSearch -State 'Disabled'
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
        $WinPermissionsWebSearch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsGlobalWebSearchProviderToggleEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search Permissions: Let Search Apps Show Results' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsWebSearch
    }
}
