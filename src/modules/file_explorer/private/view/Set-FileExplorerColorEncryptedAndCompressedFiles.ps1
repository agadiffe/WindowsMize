#=================================================================================================================
#                     File Explorer - View > Show Encrypted Or Compressed NTFS Files In Color
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerColorEncryptedAndCompressedFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerColorEncryptedAndCompressedFiles
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerColorEncryptedAndCompressedFiles -State 'Disabled'
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

        $ColorFiles = [HkcuExplorerAdvanced]::new('ShowEncryptCompressedColor', [int]$State, 'DWord')
        $ColorFiles.WriteVerboseMsg('File Explorer - Show Encrypted Or Compressed NTFS Files In Color', $State)
        $ColorFiles.SetRegistryEntry()
    }
}
