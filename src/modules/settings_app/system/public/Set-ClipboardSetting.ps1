#=================================================================================================================
#                                          System > Clipboard - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ClipboardSetting
        [-History {Disabled | Enabled}]
        [-HistoryGPO {Disabled | Enabled | NotConfigured}]
        [-SyncAcrossDevices {Disabled | AutoSync | ManualSync}]
        [-SyncAcrossDevicesGPO {Disabled | Enabled | NotConfigured}]
        [-SuggestedActions {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ClipboardSetting
{
    <#
    .EXAMPLE
        PS> Set-ClipboardSetting -History 'Disabled' -HistoryGPO 'Disabled' -SuggestedActions 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $History,

        [GpoState] $HistoryGPO,

        [ClipboardSyncState] $SyncAcrossDevices,

        [GpoState] $SyncAcrossDevicesGPO,

        [state] $SuggestedActions
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'History'              { Set-ClipboardHistory -State $History }
            'HistoryGPO'           { Set-ClipboardHistory -GPO $HistoryGPO }
            'SyncAcrossDevices'    { Set-ClipboardSyncAcrossDevices -State $SyncAcrossDevices }
            'SyncAcrossDevicesGPO' { Set-ClipboardSyncAcrossDevices -GPO $SyncAcrossDevicesGPO }
            'SuggestedActions'     { Set-ClipboardSuggestedActions -State $SuggestedActions }
        }
    }
}
