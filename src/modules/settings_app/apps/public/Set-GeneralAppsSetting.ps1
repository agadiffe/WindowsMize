#=================================================================================================================
#                                                 Apps - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-GeneralAppsSetting

        # advanced app settings
        [-ChooseWhereToGetApps {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly}]
        [-ChooseWhereToGetAppsGPO {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured}]
        [-ShareAcrossDevices {Disabled | DevicesOnly | EveryoneNearby}]
        [-AutoArchiveApps {Disabled | Enabled}]
        [-AutoArchiveAppsGPO {Disabled | Enabled | NotConfigured}]

        # apps for websites
        [-AppsOpenLinksInsteadOfBrowserGPO {Disabled | NotConfigured}]

        # resume
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
            # advanced app settings
            'ChooseWhereToGetApps'              { Set-ChooseWhereToGetApps -Mode $ChooseWhereToGetApps }
            'ChooseWhereToGetAppsGPO'           { Set-ChooseWhereToGetApps -GPO $ChooseWhereToGetAppsGPO }
            'ShareAcrossDevices'                { Set-AppsShareAcrossDevices -Mode $ShareAcrossDevices }
            'AutoArchiveApps'                   { Set-AppsAutoArchive -State $AutoArchiveApps }
            'AutoArchiveAppsGPO'                { Set-AppsAutoArchive -GPO $AutoArchiveAppsGPO }

            # apps for websites
            'AppsOpenLinksInsteadOfBrowserGPO'  { Set-AppsOpenLinksInsteadOfBrowser -GPO $AppsOpenLinksInsteadOfBrowserGPO }

            # resume
            'AppsResume'                        { Set-AppsResume -State $AppsResume }
            'AppsResumeGPO'                     { Set-AppsResume -GPO $AppsResumeGPO }
        }
    }
}
