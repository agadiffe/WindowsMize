#=================================================================================================================
#                                   Privacy & Security > Search > Find My Files
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsFindMyFiles
        [-Mode] {Classic | Enhanced}
        [<CommonParameters>]
#>

function Set-WinPermissionsFindMyFiles
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsFindMyFiles -Mode 'Classic'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [FindMyFilesMode] $Mode
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
                    Value = $Mode -eq 'Classic' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search: Find My Files' to '$Mode' ..."
        Set-RegistryEntry -InputObject $WinPermissionsFindMyFiles
    }
}
