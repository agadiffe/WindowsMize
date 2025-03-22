#=================================================================================================================
#                                 File Explorer - General > Open File Explorer To
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerLaunchTo
        [-Value] {ThisPC | Home | Downloads | OneDrive}
        [<CommonParameters>]
#>

function Set-FileExplorerLaunchTo
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerLaunchTo -Value 'Home'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [LaunchTo] $Value
    )

    process
    {
        # This PC: 1 | Home: 2 (default) | Downloads: 3 | OneDrive: 4

        $LaunchTo = [HkcuExplorerAdvanced]::new('LaunchTo', [int]$Value, 'DWord')
        $LaunchTo.WriteVerboseMsg('File Explorer - Open File Explorer To', $Value)
        $LaunchTo.SetRegistryEntry()
    }
}
