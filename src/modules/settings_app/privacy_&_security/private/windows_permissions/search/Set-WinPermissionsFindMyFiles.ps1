#=================================================================================================================
#                                   Privacy & Security > Search > Find My Files
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsFindMyFiles
        [-State] {Classic | Enhanced}
        [<CommonParameters>]
#>

function Set-WinPermissionsFindMyFiles
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsFindMyFiles -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [FindMyFilesMode] $State
    )

    process
    {
        # classic: 0 (default) | enhanced: 1
        $WinPermissionsFindMyFiles = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Search'
            Entries = @(
                @{
                    Name  = 'EnableFindMyFiles'
                    Value = $State -eq 'Classic' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search: Find My Files' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsFindMyFiles
    }
}
