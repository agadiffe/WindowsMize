#=================================================================================================================
#                                 File Explorer - General > Open File Explorer To
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerLaunchTo
        [-LaunchTo] {ThisPC | Home | Downloads | OneDrive}
        [<CommonParameters>]
#>

function Set-FileExplorerLaunchTo
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerLaunchTo -LaunchTo 'Home'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [LaunchTo] $LaunchTo
    )

    process
    {
        # This PC: 1 | Home: 2 (default) | Downloads: 3 | OneDrive: 4

        $LaunchToReg = [HkcuExplorerAdvanced]::new('LaunchTo', [int]$LaunchTo, 'DWord')
        $LaunchToReg.WriteVerboseMsg('File Explorer - Open File Explorer To', $LaunchTo)
        $LaunchToReg.SetRegistryEntry()
    }
}
