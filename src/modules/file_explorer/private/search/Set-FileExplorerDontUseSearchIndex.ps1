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
        PS> Set-FileExplorerDontUseSearchIndex -State 'Disabled'
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

        $SearchIndex = [HkcuExplorerSearchPrefs]::new('WholeFileSystem', [int]$State, 'DWord')
        $SearchIndex.WriteVerboseMsg('File Explorer - Don''t Use The Index When Searching', $State)
        $SearchIndex.SetRegistryEntry()
    }
}
