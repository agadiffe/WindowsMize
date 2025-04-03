#=================================================================================================================
#                                        File Explorer - Misc > Show Home
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowHome
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowHome
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowHome -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 or delete (default) | off: 0
        $ShowHome = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}'
            Entries = @(
                @{
                    Name  = 'System.IsPinnedToNameSpaceTree'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Show Home' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowHome
    }
}
