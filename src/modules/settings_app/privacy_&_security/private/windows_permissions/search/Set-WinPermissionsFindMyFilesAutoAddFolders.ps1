#=================================================================================================================
#         Privacy & Security > Search > Find My Files > Automatically Find Additional Relevant Locations
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsFindMyFilesAutoAddFolders
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsFindMyFilesAutoAddFolders
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsFindMyFilesAutoAddFolders -State 'Disabled'
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
        $WinPermissionsFindMyFilesAutoAddFolders = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Search\ScopeExpansion'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $FindMyFilesMsg = 'Search: Find My Files: Automatically Find Additional Relevant Locations'

        Write-Verbose -Message "Setting 'Windows Permissions - $FindMyFilesMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsFindMyFilesAutoAddFolders
    }
}
