#=================================================================================================================
#                                             File Explorer Settings
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerSetting

        # General
        [-LaunchTo {ThisPC | Home | Downloads | OneDrive}]
        [-OpenFolder {SameWindow | NewWindow}]
        [-OpenFolderInNewTab {Disabled | Enabled}]
        [-OpenItem {SingleClick | DoubleClick}]
        [-ShowRecentFiles {Disabled | Enabled}]
        [-ShowFrequentFolders {Disabled | Enabled}]
        [-ShowCloudFiles {Disabled | Enabled}]
        [-ShowRecommendedSection {Disabled | Enabled}]

        # View
        [-ShowIconsOnly {Disabled | Enabled}]
        [-CompactView {Disabled | Enabled}]
        [-ShowFileIconOnThumbnails {Disabled | Enabled}]
        [-ShowFileSizeInFolderTips {Disabled | Enabled}]
        [-ShowFullPathInTitleBar {Disabled | Enabled}]
        [-Prelaunch {Disabled | Enabled}]
        [-ShowHiddenItems {Disabled | Enabled}]
        [-HideEmptyDrives {Disabled | Enabled}]
        [-HideFileExtensions {Disabled | Enabled}]
        [-HideFolderMergeConflicts {Disabled | Enabled}]
        [-HideProtectedSystemFiles {Disabled | Enabled}]
        [-LaunchFolderInSeparateProcess {Disabled | Enabled}]
        [-RestorePreviousFoldersAtLogon {Disabled | Enabled}]
        [-ShowDriveLetters {Disabled | Enabled}]
        [-ShowPreviewHandlers {Disabled | Enabled}]
        [-ShowStatusBar {Disabled | Enabled}]
        [-ColorEncryptedAndCompressedFiles {Disabled | Enabled}]
        [-ShowItemsInfoPopup {Disabled | Enabled}]
        [-ShowSyncProviderNotifications {Disabled | Enabled}]
        [-ItemsCheckBoxes {Disabled | Enabled}]
        [-SharingWizard {Disabled | Enabled}]
        [-TypingIntoListViewBehavior {SelectItemInView | AutoTypeInSearchBox}]
        [-ShowCloudStatesOnNavPane {Disabled | Enabled}]
        [-ExpandToCurrentFolder {Disabled | Enabled}]
        [-ShowAllFolders {Disabled | Enabled}]
        [-ShowLibraries {Disabled | Enabled}]
        [-ShowNetwork {Disabled | Enabled}]
        [-ShowThisPC {Disabled | Enabled}]

        # Search
        [-DontUseSearchIndex {Disabled | Enabled}]
        [-IncludeSystemFolders {Disabled | Enabled}]
        [-IncludeCompressedFiles {Disabled | Enabled}]
        [-SearchFileNamesAndContents {Disabled | Enabled}]

        # Miscellaneous
        [-ShowNavigationPane {Disabled | Enabled}]
        [-ShowHome {Disabled | Enabled}]
        [-ShowGallery {Disabled | Enabled}]
        [-ShowRemovableDrivesOnlyInThisPC {Disabled | Enabled}]
        [-MaxIconCacheSize <int>]
        [-AutoFolderTypeDetection {Disabled | Enabled}]
        [-UndoRedo {Disabled | Enabled}]
        [-ConfirmFileDelete {Disabled | Enabled}]
        [-ConfirmFileDeleteGPO {Disabled | NotConfigured}]
        [-RecycleBin {Disabled | Enabled}]
        [-RecycleBinGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-FileExplorerSetting
{
    <#
    .DESCRIPTION
        "OpenFolderInNewTab" requires "Open each folder in the same window" to work.

    .EXAMPLE
        PS> Set-FileExplorerSetting -LaunchTo 'ThisPC' -ShowRecentFiles 'Enabled' -CompactView 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # General
        [LaunchTo] $LaunchTo,
        [OpenFolderMode] $OpenFolder,
        [state] $OpenFolderInNewTab,
        [OpenItemMode] $OpenItem,
        [state] $ShowRecentFiles,
        [state] $ShowFrequentFolders,
        [state] $ShowCloudFiles,
        [state] $ShowRecommendedSection,

        # View
        [state] $ShowIconsOnly,
        [state] $CompactView,
        [state] $ShowFileIconOnThumbnails,
        [state] $ShowFileSizeInFolderTips,
        [state] $ShowFullPathInTitleBar,
        [state] $Prelaunch,
        [state] $ShowHiddenItems,
        [state] $HideEmptyDrives,
        [state] $HideFileExtensions,
        [state] $HideFolderMergeConflicts,
        [state] $HideProtectedSystemFiles,
        [state] $LaunchFolderInSeparateProcess,
        [state] $RestorePreviousFoldersAtLogon,
        [state] $ShowDriveLetters,
        [state] $ShowPreviewHandlers,
        [state] $ShowStatusBar,
        [state] $ColorEncryptedAndCompressedFiles,
        [state] $ShowItemsInfoPopup,
        [state] $ShowSyncProviderNotifications,
        [state] $ItemsCheckBoxes,
        [state] $SharingWizard,
        [TypingIntoListViewMode] $TypingIntoListViewBehavior,

        [state] $ShowCloudStatesOnNavPane,
        [state] $ExpandToCurrentFolder,
        [state] $ShowAllFolders,
        [state] $ShowLibraries,
        [state] $ShowNetwork,
        [state] $ShowThisPC,

        # Search
        [state] $DontUseSearchIndex,
        [state] $IncludeSystemFolders,
        [state] $IncludeCompressedFiles,
        [state] $SearchFileNamesAndContents,

        # Miscellaneous
        [state] $ShowNavigationPane,
        [state] $ShowHome,
        [state] $ShowGallery,
        [state] $ShowRemovableDrivesOnlyInThisPC,
        [int] $MaxIconCacheSize,
        [state] $AutoFolderTypeDetection,
        [state] $UndoRedo,
        [state] $ConfirmFileDelete,
        [GpoStateWithoutEnabled] $ConfirmFileDeleteGPO,
        [state] $RecycleBin,
        [GpoStateWithoutEnabled] $RecycleBinGPO
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
            # General
            'LaunchTo'                         { Set-FileExplorerLaunchTo -Value $LaunchTo }
            'OpenFolder'                       { Set-FileExplorerOpenFolder -Value $OpenFolder }
            'OpenFolderInNewTab'               { Set-FileExplorerOpenFolderInNewTab -State $OpenFolderInNewTab }
            'OpenItem'                         { Set-FileExplorerOpenItem -Value $OpenItem }
            'ShowRecentFiles'                  { Set-FileExplorerShowRecentFiles -State $ShowRecentFiles }
            'ShowFrequentFolders'              { Set-FileExplorerShowFrequentFolders -State $ShowFrequentFolders }
            'ShowCloudFiles'                   { Set-FileExplorerShowCloudFiles -State $ShowCloudFiles }
            'ShowRecommendedSection'           { Set-FileExplorerShowRecommendedSection -State $ShowRecommendedSection }

            # View
            'ShowIconsOnly'                    { Set-FileExplorerShowIconsOnly -State $ShowIconsOnly }
            'CompactView'                      { Set-FileExplorerCompactView -State $CompactView }
            'ShowFileIconOnThumbnails'         { Set-FileExplorerShowFileIconOnThumbnails -State $ShowFileIconOnThumbnails }
            'ShowFileSizeInFolderTips'         { Set-FileExplorerShowFileSizeInFolderTips -State $ShowFileSizeInFolderTips }
            'ShowFullPathInTitleBar'           { Set-FileExplorerShowFullPathInTitleBar -State $ShowFullPathInTitleBar }
            'Prelaunch'                        { Set-FileExplorerPrelaunch -State $Prelaunch }
            'ShowHiddenItems'                  { Set-FileExplorerShowHiddenItems -State $ShowHiddenItems }
            'HideEmptyDrives'                  { Set-FileExplorerHideEmptyDrives -State $HideEmptyDrives }
            'HideFileExtensions'               { Set-FileExplorerHideFileExtensions -State $HideFileExtensions }
            'HideFolderMergeConflicts'         { Set-FileExplorerHideFolderMergeConflicts -State $HideFolderMergeConflicts }
            'HideProtectedSystemFiles'         { Set-FileExplorerHideProtectedSystemFiles -State $HideProtectedSystemFiles }
            'LaunchFolderInSeparateProcess'    { Set-FileExplorerLaunchFolderInSeparateProcess -State $LaunchFolderInSeparateProcess }
            'RestorePreviousFoldersAtLogon'    { Set-FileExplorerRestorePreviousFoldersAtLogon -State $RestorePreviousFoldersAtLogon }
            'ShowDriveLetters'                 { Set-FileExplorerShowDriveLetters -State $ShowDriveLetters }
            'ShowPreviewHandlers'              { Set-FileExplorerShowPreviewHandlers -State $ShowPreviewHandlers }
            'ShowStatusBar'                    { Set-FileExplorerShowStatusBar -State $ShowStatusBar }
            'ColorEncryptedAndCompressedFiles' { Set-FileExplorerColorEncryptedAndCompressedFiles -State $ColorEncryptedAndCompressedFiles }
            'ShowItemsInfoPopup'               { Set-FileExplorerShowItemsInfoPopup -State $ShowItemsInfoPopup }
            'ShowSyncProviderNotifications'    { Set-FileExplorerShowSyncProviderNotifications -State $ShowSyncProviderNotifications }
            'ItemsCheckBoxes'                  { Set-FileExplorerItemsCheckBoxes -State $ItemsCheckBoxes }
            'SharingWizard'                    { Set-FileExplorerSharingWizard -State $SharingWizard }
            'TypingIntoListViewBehavior'       { Set-FileExplorerTypingIntoListViewBehavior -Value $TypingIntoListViewBehavior }

            'ShowCloudStatesOnNavPane'         { Set-FileExplorerShowCloudStatesOnNavPane -State $ShowCloudStatesOnNavPane }
            'ExpandToCurrentFolder'            { Set-FileExplorerExpandToCurrentFolder -State $ExpandToCurrentFolder }
            'ShowAllFolders'                   { Set-FileExplorerShowAllFolders -State $ShowAllFolders }
            'ShowLibraries'                    { Set-FileExplorerShowLibraries -State $ShowLibraries }
            'ShowNetwork'                      { Set-FileExplorerShowNetwork -State $ShowNetwork }
            'ShowThisPC'                       { Set-FileExplorerShowThisPC -State $ShowThisPC }

            # Search
            'DontUseSearchIndex'               { Set-FileExplorerDontUseSearchIndex -State $DontUseSearchIndex }
            'IncludeSystemFolders'             { Set-FileExplorerIncludeSystemFolders -State $IncludeSystemFolders }
            'IncludeCompressedFiles'           { Set-FileExplorerIncludeCompressedFiles -State $IncludeCompressedFiles }
            'SearchFileNamesAndContents'       { Set-FileExplorerSearchFileNamesAndContents -State $SearchFileNamesAndContents }

            # Miscellaneous
            'ShowNavigationPane'               { Set-FileExplorerNavigationPane -State $ShowNavigationPane }
            'ShowHome'                         { Set-FileExplorerShowHome -State $ShowHome }
            'ShowGallery'                      { Set-FileExplorerShowGallery -State $ShowGallery }
            'ShowRemovableDrivesOnlyInThisPC'  { Set-FileExplorerShowRemovableDrivesOnlyInThisPC -State $ShowRemovableDrivesOnlyInThisPC }
            'MaxIconCacheSize'                 { Set-FileExplorerMaxIconCacheSize -Value $MaxIconCacheSize }
            'AutoFolderTypeDetection'          { Set-FileExplorerAutoFolderTypeDetection -State $AutoFolderTypeDetection }
            'UndoRedo'                         { Set-FileExplorerUndoRedo -State $UndoRedo }
            'ConfirmFileDelete'                { Set-RecycleBinConfirmFileDelete -State $ConfirmFileDelete }
            'ConfirmFileDeleteGPO'             { Set-RecycleBinConfirmFileDelete -GPO $ConfirmFileDeleteGPO }
            'RecycleBin'                       { Set-RecycleBin -State $RecycleBin }
            'RecycleBinGPO'                    { Set-RecycleBin -GPO $RecycleBinGPO }
        }
    }
}
