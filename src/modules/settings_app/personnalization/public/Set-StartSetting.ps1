#=================================================================================================================
#                                       Personnalization > Start - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-StartSetting
        [-LayoutMode {Default | MorePins | MoreRecommendations}]
        [-ShowRecentlyAddedApps {Disabled | Enabled}]
        [-ShowRecentlyAddedAppsGPO {Disabled | NotConfigured}]
        [-ShowMostUsedApps {Disabled | Enabled}]
        [-ShowMostUsedAppsGPO {Disabled | Enabled | NotConfigured}]
        [-ShowRecentlyOpenedItems {Disabled | Enabled}]
        [-ShowRecentlyOpenedItemsGPO {Disabled | NotConfigured}]
        [-ShowRecommendations {Disabled | Enabled}]
        [-ShowAccountNotifications {Disabled | Enabled}]
        [-ShowMobileDevice {Disabled | Enabled}]
        [-FoldersNextToPowerButton {Settings | FileExplorer | Network | PersonalFolder |
                                    Documents | Downloads | Music | Pictures | Videos}]
        [<CommonParameters>]

    Set-StartSetting
        [-LayoutMode {Default | MorePins | MoreRecommendations}]
        [-ShowRecentlyAddedApps {Disabled | Enabled}]
        [-ShowRecentlyAddedAppsGPO {Disabled | NotConfigured}]
        [-ShowMostUsedApps {Disabled | Enabled}]
        [-ShowMostUsedAppsGPO {Disabled | Enabled | NotConfigured}]
        [-ShowRecentlyOpenedItems {Disabled | Enabled}]
        [-ShowRecentlyOpenedItemsGPO {Disabled | NotConfigured}]
        [-ShowRecommendations {Disabled | Enabled}]
        [-ShowAccountNotifications {Disabled | Enabled}]
        [-ShowMobileDevice {Disabled | Enabled}]
        [-HideAllFoldersNextToPowerButton]
        [<CommonParameters>]
#>

function Set-StartSetting
{
    <#
    .EXAMPLE
        PS> Set-StartSetting -LayoutMode 'Default' -FoldersNextToPowerButton 'Settings', 'PersonalFolder'

    .EXAMPLE
        PS> Set-StartSetting -LayoutMode 'Default' -ShowRecommendations 'Disabled' -HideAllFoldersNextToPowerButton
    #>

    [CmdletBinding(DefaultParameterSetName = 'StartFoldersQuickLaunch')]
    param
    (
        [StartLayoutMode] $LayoutMode,

        [state] $ShowRecentlyAddedApps,

        [GpoStateWithoutEnabled] $ShowRecentlyAddedAppsGPO,

        [state] $ShowMostUsedApps,

        [GpoState] $ShowMostUsedAppsGPO,

        [state] $ShowRecentlyOpenedItems,

        [GpoStateWithoutEnabled] $ShowRecentlyOpenedItemsGPO,

        [state] $ShowRecommendations,

        [state] $ShowAccountNotifications,

        [state] $ShowMobileDevice,

        [Parameter(ParameterSetName = 'StartFoldersQuickLaunch')]
        [StartFoldersName[]] $FoldersNextToPowerButton,

        [Parameter(ParameterSetName = 'HideAllStartFoldersQuickLaunch')]
        [switch] $HideAllFoldersNextToPowerButton
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
            'LayoutMode'                      { Set-StartLayoutMode -Value $LayoutMode }
            'ShowMostUsedApps'                { Set-StartShowMostUsedApps -State $ShowMostUsedApps }
            'ShowMostUsedAppsGPO'             { Set-StartShowMostUsedApps -GPO $ShowMostUsedAppsGPO }
            'ShowRecentlyAddedApps'           { Set-StartShowRecentlyAddedApps -State $ShowRecentlyAddedApps }
            'ShowRecentlyAddedAppsGPO'        { Set-StartShowRecentlyAddedApps -GPO $ShowRecentlyAddedAppsGPO }
            'ShowRecentlyOpenedItems'         { Set-StartShowRecentlyOpenedItems -State $ShowRecentlyOpenedItems }
            'ShowRecentlyOpenedItemsGPO'      { Set-StartShowRecentlyOpenedItems -GPO $ShowRecentlyOpenedItemsGPO }
            'ShowRecommendations'             { Set-StartShowRecommendations -State $ShowRecommendations }
            'ShowAccountNotifications'        { Set-StartShowAccountNotifications -State $ShowAccountNotifications }
            'FoldersNextToPowerButton'        { Set-StartFoldersNextToPowerButton -Value $FoldersNextToPowerButton }
            'HideAllFoldersNextToPowerButton' { Set-StartFoldersNextToPowerButton -None:$HideAllFoldersNextToPowerButton }
            'ShowMobileDevice'                { Set-StartShowMobileDevice -State $ShowMobileDevice }
        }
    }
}
