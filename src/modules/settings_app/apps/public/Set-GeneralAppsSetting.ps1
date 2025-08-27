#=================================================================================================================
#                                                 Apps - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-GeneralAppsSetting
        [-ChooseWhereToGetApps {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly}]
        [-ChooseWhereToGetAppsGPO {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured}]
        [-ShareAcrossDevices {Disabled | DevicesOnly | EveryoneNearby}]
        [-AutoArchiveApps {Disabled | Enabled}]
        [-AutoArchiveAppsGPO {Disabled | Enabled | NotConfigured}]
        [-AppsOpenLinksInsteadOfBrowserGPO {Disabled | NotConfigured}]
        [-AppsResume {Disabled | Enabled}]
        [-AppsResumeGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-GeneralAppsSetting
{
    <#
    .EXAMPLE
        PS> Set-GeneralAppsSetting -ShareAcrossDevices 'Disabled' -AutoArchiveApps 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # advanced app settings
        [AppInstallControl] $ChooseWhereToGetApps,

        [GpoAppInstallControl] $ChooseWhereToGetAppsGPO,

        [ShareAcrossDevicesMode] $ShareAcrossDevices,

        [state] $AutoArchiveApps,

        [GpoState] $AutoArchiveAppsGPO,

        # apps for websites
        [GpoStateWithoutEnabled] $AppsOpenLinksInsteadOfBrowserGPO,

        # resume
        [state] $AppsResume,

        [GpoStateWithoutEnabled] $AppsResumeGPO
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
            'ChooseWhereToGetApps'              { Set-ChooseWhereToGetApps -Value $ChooseWhereToGetApps }
            'ChooseWhereToGetAppsGPO'           { Set-ChooseWhereToGetApps -GPO $ChooseWhereToGetAppsGPO }
            'ShareAcrossDevices'                { Set-AppsShareAcrossDevices -Value $ShareAcrossDevices }
            'AutoArchiveApps'                   { Set-AppsAutoArchive -State $AutoArchiveApps }
            'AutoArchiveAppsGPO'                { Set-AppsAutoArchive -GPO $AutoArchiveAppsGPO }

            'AppsOpenLinksInsteadOfBrowserGPO'  { Set-AppsOpenLinksInsteadOfBrowser -GPO $AppsOpenLinksInsteadOfBrowserGPO }

            'AppsResume'                        { Set-AppsResume -State $AppsResume }
            'AppsResumeGPO'                     { Set-AppsResume -GPO $AppsResumeGPO }
        }
    }
}
