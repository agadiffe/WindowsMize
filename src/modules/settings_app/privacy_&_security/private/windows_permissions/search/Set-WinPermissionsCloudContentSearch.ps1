#=================================================================================================================
#              Privacy & Security > Search Permissions > Enable Deep Content Search Of Cloud Content
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsCloudContentSearch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsCloudContentSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsCloudContentSearch -State 'Disabled'
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
        $WinPermissionsCloudContentSearch = @{
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

        $CloudContentSearchMsg = 'Search Permissions: Enable Deep Content Search Of Cloud Content'

        Write-Verbose -Message "Setting 'Windows Permissions - $CloudContentSearchMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsCloudContentSearch
    }
}
