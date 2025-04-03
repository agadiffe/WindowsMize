#=================================================================================================================
#                                      File Explorer - View > Show Libraries
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowLibraries
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowLibraries
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowLibraries -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $ShowLibraries = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Classes\CLSID\{031e4825-7b94-4dc3-b131-e946b44c8dd5}'
            Entries = @(
                @{
                    Name  = 'System.IsPinnedToNameSpaceTree'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Show Libraries' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowLibraries
    }
}
