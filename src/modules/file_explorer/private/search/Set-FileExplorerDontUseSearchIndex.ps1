#=================================================================================================================
#          File Explorer - Search > Don't Use The Index When Searching In File Folders For System Files
#=================================================================================================================

# If search indexing is disabled, you will see a message banner:
#   Your searches might be slow because the index is not running. Click to turn on the index.

# Disable this setting (tick "Don't use ...") to supress the message.

<#
.SYNTAX
    Set-FileExplorerDontUseSearchIndex
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerDontUseSearchIndex
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerDontUseSearchIndex -State 'Enabled'
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
        $SearchIndex = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences'
            Entries = @(
                @{
                    Name  = 'WholeFileSystem'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Don't Use The Index When Searching' to '$State' ..."
        Set-RegistryEntry -InputObject $SearchIndex
    }
}
