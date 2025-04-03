#=================================================================================================================
#                                    File Explorer - View > Use Sharing Wizard
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerSharingWizard
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerSharingWizard
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerSharingWizard -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0

        $SharingWizard = [HkcuExplorerAdvanced]::new('SharingWizardOn', [int]$State, 'DWord')
        $SharingWizard.WriteVerboseMsg('File Explorer - Use Sharing Wizard', $State)
        $SharingWizard.SetRegistryEntry()
    }
}
