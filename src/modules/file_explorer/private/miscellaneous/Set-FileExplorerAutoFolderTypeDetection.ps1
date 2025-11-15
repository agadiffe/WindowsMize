#=================================================================================================================
#                             File Explorer - Misc > Automatic Folder Type Detection
#=================================================================================================================

# Disabling this feature will speedup File Explorer.
# Usefull for folders that contains big or many files.

<#
.SYNTAX
    Set-FileExplorerAutoFolderTypeDetection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerAutoFolderTypeDetection
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerAutoFolderTypeDetection -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsDisabled = $State -eq 'Disabled'
        $IsEnabled = $State -eq 'Enabled'

        # Bags & BagMRU\ current saved folders type
        # FolderType\ on: delete (default) | off: NotSpecified
        $AutoFolderTypeDetection = @(
            @{
                RemoveKey = $IsDisabled
                SkipKey = $IsEnabled
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
                Entries = @()
            }
            @{
                RemoveKey = $IsDisabled
                SkipKey = $IsEnabled
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
                Entries = @()
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'
                Entries = @(
                    @{
                        RemoveEntry = $IsEnabled
                        Name  = 'FolderType'
                        Value = 'NotSpecified'
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'File Explorer - Automatic Folder Type Detection' to '$State' ..."
        $AutoFolderTypeDetection | Set-RegistryEntry
    }
}
