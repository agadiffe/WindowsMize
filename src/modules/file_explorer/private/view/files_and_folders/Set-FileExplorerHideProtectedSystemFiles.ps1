#=================================================================================================================
#                   File Explorer - View > Hide Protected Operating System Files (Recommended)
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerHideProtectedSystemFiles
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerHideProtectedSystemFiles
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerHideProtectedSystemFiles -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1

        $Value = $State -eq 'Enabled' ? '0' : '1'
        $ProtectedSystemFiles = [HkcuExplorerAdvanced]::new('ShowSuperHidden', $Value, 'DWord')
        $ProtectedSystemFiles.WriteVerboseMsg('File Explorer - Hide Protected Operating System Files (Recommended)', $State)
        $ProtectedSystemFiles.SetRegistryEntry()
    }
}
