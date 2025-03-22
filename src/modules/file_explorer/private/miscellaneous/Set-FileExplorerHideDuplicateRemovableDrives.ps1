#=================================================================================================================
#                             File Explorer - Misc > Hide Duplicate Removable Drives
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerHideDuplicateRemovableDrives
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerHideDuplicateRemovableDrives
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerHideDuplicateRemovableDrives -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: key present (default) | off: delete key
        $DuplicateRemovableDrives = @{
            RemoveKey = $State -eq 'Disabled'
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{f5fb2c77-0e2f-4a16-a381-3e560c68bc83}'
            Entries = @(
                @{
                    Name  = '(Default)'
                    Value = 'Removable Drives'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Hide Duplicate Removable Drives' to '$State' ..."
        Set-RegistryEntry -InputObject $DuplicateRemovableDrives
    }
}
