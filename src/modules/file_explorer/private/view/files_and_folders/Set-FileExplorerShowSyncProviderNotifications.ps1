#=================================================================================================================
#                             File Explorer - View > Show Sync Provider Notifications
#=================================================================================================================

# Show OneDrive Ads in File Explorer.

<#
.SYNTAX
    Set-FileExplorerShowSyncProviderNotifications
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowSyncProviderNotifications
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowSyncProviderNotifications -State 'Disabled'
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

        $SyncProviderNotifs = [HkcuExplorerAdvanced]::new('ShowSyncProviderNotifications', [int]$State, 'DWord')
        $SyncProviderNotifs.WriteVerboseMsg('File Explorer - Show Sync Provider Notifications', $State)
        $SyncProviderNotifs.SetRegistryEntry()
    }
}
