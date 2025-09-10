#=================================================================================================================
#                        Privacy & Security > Search > Search The Contents Of Online Files
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsCloudFileContentSearch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsCloudFileContentSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsCloudFileContentSearch -State 'Disabled'
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
        $WinPermissionsCloudFileContentSearch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsGlobalFileSearchProviderToggleEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $CloudFileContentSearchMsg = 'Search: Search The Contents Of Online Files'

        Write-Verbose -Message "Setting 'Windows Permissions - $CloudFileContentSearchMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsCloudFileContentSearch
    }
}
