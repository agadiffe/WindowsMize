#=================================================================================================================
#                          File Explorer - View > Display The Full Path In The Title Bar
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowFullPathInTitleBar
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowFullPathInTitleBar
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowFullPathInTitleBar -State 'Disabled'
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
        $FullPathInTitleBar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
            Entries = @(
                @{
                    Name  = 'FullPath'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Display The Full Path In The Title Bar' to '$Value' ..."
        Set-RegistryEntry -InputObject $FullPathInTitleBar
    }
}
