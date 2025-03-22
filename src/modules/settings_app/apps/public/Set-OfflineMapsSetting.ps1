#=================================================================================================================
#                                         Apps > Offline Maps - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-OfflineMapsSetting
        [-DownloadOverMeteredConnection {Disabled | Enabled}]
        [-AutoUpdateOnACAndWifi {Disabled | Enabled}]
        [-AutoUpdateOnACAndWifiGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-OfflineMapsSetting
{
    <#
    .EXAMPLE
        PS> Set-OfflineMapsSetting -DownloadOverMeteredConnection 'Disabled' -AutoUpdateOnACAndWifi 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $DownloadOverMeteredConnection,

        [state] $AutoUpdateOnACAndWifi,

        [GpoState] $AutoUpdateOnACAndWifiGPO
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
            'DownloadOverMeteredConnection' { Set-OfflineMapsDownloadOverMeteredConnection -State $DownloadOverMeteredConnection }
            'AutoUpdateOnACAndWifi'         { Set-OfflineMapsAutoUpdateOnACAndWifi -State $AutoUpdateOnACAndWifi }
            'AutoUpdateOnACAndWifiGPO'      { Set-OfflineMapsAutoUpdateOnACAndWifi -GPO $AutoUpdateOnACAndWifiGPO }
        }
    }
}
