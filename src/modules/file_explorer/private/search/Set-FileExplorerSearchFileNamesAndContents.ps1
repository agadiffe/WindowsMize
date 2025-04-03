#=================================================================================================================
#                         File Explorer - Search > Always Search File Names And Contents
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerSearchFileNamesAndContents
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerSearchFileNamesAndContents
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerSearchFileNamesAndContents -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 | off: 1 (default)
        $SearchFileNamesAndContents = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Search\PrimaryProperties\UnindexedLocations'
            Entries = @(
                @{
                    Name  = 'SearchOnly'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Always Search File Names And Contents' to '$State' ..."
        Set-RegistryEntry -InputObject $SearchFileNamesAndContents
    }
}
