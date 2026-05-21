#=================================================================================================================
#                                       Personnalization > Start - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-StartSetting
        [-LayoutMode {Default | MorePins | MoreRecommendations}]
        [-StartMenuSize {Small | Large}]
        [-PinnedSection {Disabled | Enabled}]
        [-ShowAllPins {Disabled | Enabled}]
        [-RecentSection {Disabled | Enabled}]
        [-ShowRecentAddedApps {Disabled | Enabled}]
        [-ShowRecentAddedAppsGPO {Disabled | NotConfigured}]
        [-ShowRecentItems {Disabled | Enabled}]
        [-ShowRecentItemsGPO {Disabled | NotConfigured}]
        [-ShowTipsAndAppRecommendations {Disabled | Enabled}]
        [-ShowWebsitesFromBrowsingHistoryGPO {Disabled | NotConfigured}]
        [-AllAppsSection {Disabled | Enabled}]
        [-ShowMostUsedApps {Disabled | Enabled}]
        [-ShowMostUsedAppsGPO {Disabled | Enabled | NotConfigured}]
        [-ShowMobileDevice {Disabled | Enabled}]
        [-ShowAccountNotifications {Disabled | Enabled}]
        [-ShowRecentItemsInExplorer {Disabled | Enabled}]
        [-HideNameAndPicture {Disabled | Enabled}]
        [-FoldersNextToPowerButton {Settings | FileExplorer | Network | PersonalFolder |
                                    Documents | Downloads | Music | Pictures | Videos}]
        [<CommonParameters>]
#>

function Set-StartSetting
{
    <#
    .EXAMPLE
        PS> Set-StartSetting -LayoutMode 'Default' -FoldersNextToPowerButton 'Settings', 'PersonalFolder'

    .EXAMPLE
        PS> Set-StartSetting -LayoutMode 'Default' -ShowTipsAndAppRecommendations 'Disabled' -HideAllFoldersNextToPowerButton
    #>

    [CmdletBinding(DefaultParameterSetName = 'StartFoldersQuickLaunch')]
    param
    (
        # general
        [StartLayoutMode] $LayoutMode,

        [StartMenuSize] $StartMenuSize,

        # pinned section
        [state] $PinnedSection,

        [state] $ShowAllPins,

        # recent section
        [state] $RecentSection,

        [state] $ShowRecentAddedApps,

        [GpoStateWithoutEnabled] $ShowRecentAddedAppsGPO,

        [state] $ShowRecentItems,

        [GpoStateWithoutEnabled] $ShowRecentItemsGPO,

        [state] $ShowTipsAndAppRecommendations,

        [GpoStateWithoutEnabled] $ShowWebsitesFromBrowsingHistoryGPO,

        # all apps section
        [state] $AllAppsSection,

        [state] $ShowMostUsedApps,

        [GpoState] $ShowMostUsedAppsGPO,

        # other
        [state] $ShowMobileDevice,

        [StartFoldersName[]] $FoldersNextToPowerButton,

        [state] $ShowAccountNotifications,

        [state] $ShowRecentItemsInExplorer,

        [state] $HideNameAndPicture
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
            'LayoutMode'                         { Set-StartLayoutMode -Layout $LayoutMode }
            'StartMenuSize'                      { Set-StartMenuSize -Size $StartMenuSize }

            'PinnedSection'                      { Set-StartPinnedSection -State $PinnedSection }
            'ShowAllPins'                        { Set-StartShowAllPins -State $ShowAllPins }
    
            'RecentSection'                      { Set-StartRecentSection -State $RecentSection }
            'ShowRecentAddedApps'                { Set-StartShowRecentAddedApps -State $ShowRecentAddedApps }
            'ShowRecentAddedAppsGPO'             { Set-StartShowRecentAddedApps -GPO $ShowRecentAddedAppsGPO }
            'ShowRecentItems'                    { Set-StartShowRecentItems -State $ShowRecentItems }
            'ShowRecentItemsGPO'                 { Set-StartShowRecentItems -GPO $ShowRecentItemsGPO }
            'ShowTipsAndAppRecommendations'      { Set-StartShowTipsAndAppRecommendations -State $ShowTipsAndAppRecommendations }
            'ShowWebsitesFromBrowsingHistoryGPO' { Set-StartShowWebsitesFromBrowsingHistory -GPO $ShowWebsitesFromBrowsingHistoryGPO }
    
            'AllAppsSection'                     { Set-StartAllAppsSection -State $AllAppsSection }
            'ShowMostUsedApps'                   { Set-StartShowMostUsedApps -State $ShowMostUsedApps }
            'ShowMostUsedAppsGPO'                { Set-StartShowMostUsedApps -GPO $ShowMostUsedAppsGPO }

            'ShowMobileDevice'                   { Set-StartShowMobileDevice -State $ShowMobileDevice }
            'FoldersNextToPowerButton'           { Set-StartFoldersNextToPowerButton -Item $FoldersNextToPowerButton }
            'ShowAccountNotifications'           { Set-StartShowAccountNotifications -State $ShowAccountNotifications }
            'ShowRecentItemsInExplorer'          { Set-StartShowRecentItemsInExplorer -State $ShowRecentItemsInExplorer }
            'HideNameAndPicture'                 { Set-StartHideNameAndPicture -State $HideNameAndPicture }
        }
    }
}
