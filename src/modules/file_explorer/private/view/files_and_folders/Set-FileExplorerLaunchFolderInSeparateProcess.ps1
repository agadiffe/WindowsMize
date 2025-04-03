#=================================================================================================================
#                       File Explorer - View > Launch Folder Windows In A Separate Process
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerLaunchFolderInSeparateProcess
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerLaunchFolderInSeparateProcess
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerLaunchFolderInSeparateProcess -State 'Disabled'
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

        $SeparateProcess = [HkcuExplorerAdvanced]::new('SeparateProcess', [int]$State, 'DWord')
        $SeparateProcess.WriteVerboseMsg('File Explorer - Launch Folder Windows In A Separate Process', $State)
        $SeparateProcess.SetRegistryEntry()
    }
}
