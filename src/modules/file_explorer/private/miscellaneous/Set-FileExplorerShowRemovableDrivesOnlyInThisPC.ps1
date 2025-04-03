#=================================================================================================================
#                         File Explorer - Misc > Show Removable Drives Only In 'This PC'
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowRemovableDrivesOnlyInThisPC
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowRemovableDrivesOnlyInThisPC
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowRemovableDrivesOnlyInThisPC -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete key | off: key present (default)
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

        Write-Verbose -Message "Setting 'File Explorer - Show Removable Drives Only In 'This PC'' to '$State' ..."
        Set-RegistryEntry -InputObject $DuplicateRemovableDrives
    }
}
