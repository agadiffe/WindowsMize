#=================================================================================================================
#                                    File Explorer - View > Show Drive Letters
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowDriveLetters
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowDriveLetters
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowDriveLetters -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 2

        $Value = $State -eq 'Enabled' ? '0' : '2'
        $ShowDriveLetters = [HkcuExplorer]::new('ShowDriveLettersFirst', $Value, 'DWord')
        $ShowDriveLetters.WriteVerboseMsg('File Explorer - Show Drive Letters', $State)
        $ShowDriveLetters.SetRegistryEntry()
    }
}
