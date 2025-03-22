#=================================================================================================================
#                                             File Explorer Settings
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerSetting
        [-LaunchTo {ThisPC | Home | Downloads | OneDrive}]
        [-OpenFolder {SameWindow | NewWindow}]
        [-OpenFolderInNewTab {Disabled | Enabled}]
        [-OpenItem {SingleClick | DoubleClick}]
        [-ShowRecentFiles {Disabled | Enabled}]
        [-ShowFrequentFolders {Disabled | Enabled}]
        [-ShowCloudFiles {Disabled | Enabled}]
        [-CompactView {Disabled | Enabled}]
        [-ShowHiddenItems {Disabled | Enabled}]
        [-HideFileExtensions {Disabled | Enabled}]
        [-HideFolderMergeConflicts {Disabled | Enabled}]
        [-LaunchFolderInSeparateProcess {Disabled | Enabled}]
        [-ColorEncryptedAndCompressedFiles {Disabled | Enabled}]
        [-ShowSyncProviderNotifications {Disabled | Enabled}]
        [-ItemsCheckBoxes {Disabled | Enabled}]
        [-SharingWizard {Disabled | Enabled}]
        [-ExpandToCurrentFolder {Disabled | Enabled}]
        [-ShowAllFolders {Disabled | Enabled}]
        [-DontUseSearchIndex {Disabled | Enabled}]
        [-ShowGallery {Disabled | Enabled}]
        [-HideDuplicateRemovableDrives {Disabled | Enabled}]
        [-MaxIconCacheSize <int>]
        [-AutoFolderTypeDetection {Disabled | Enabled}]
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
        # general
        [LaunchTo] $LaunchTo,
        [OpenFolderMode] $OpenFolder,
        [state] $OpenFolderInNewTab,
        [OpenItemMode] $OpenItem,
        [state] $ShowRecentFiles,
        [state] $ShowFrequentFolders,
        [state] $ShowCloudFiles,

        # view
        [state] $CompactView,
        [state] $ShowHiddenItems,
        [state] $HideFileExtensions,
        [state] $HideFolderMergeConflicts,
        [state] $LaunchFolderInSeparateProcess,
        [state] $ColorEncryptedAndCompressedFiles,
        [state] $ShowSyncProviderNotifications,
        [state] $ItemsCheckBoxes,
        [state] $SharingWizard,
        [state] $ExpandToCurrentFolder,
        [state] $ShowAllFolders,

        # search
        [state] $DontUseSearchIndex,

        # misc
        [state] $ShowGallery,
        [state] $HideDuplicateRemovableDrives,
        [int] $MaxIconCacheSize,
        [state] $AutoFolderTypeDetection,
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
            'LaunchTo'                         { Set-FileExplorerLaunchTo -Value $LaunchTo }
            'OpenFolder'                       { Set-FileExplorerOpenFolder -Value $OpenFolder }
            'OpenFolderInNewTab'               { Set-FileExplorerOpenFolderInNewTab -State $OpenFolderInNewTab }
            'OpenItem'                         { Set-FileExplorerOpenItem -Value $OpenItem }
            'ShowRecentFiles'                  { Set-FileExplorerShowRecentFiles -State $ShowRecentFiles }
            'ShowFrequentFolders'              { Set-FileExplorerShowFrequentFolders -State $ShowFrequentFolders }
            'ShowCloudFiles'                   { Set-FileExplorerShowCloudFiles -State $ShowCloudFiles }

            'CompactView'                      { Set-FileExplorerCompactView -State $CompactView }
            'ShowHiddenItems'                  { Set-FileExplorerShowHiddenItems -State $ShowHiddenItems }
            'HideFileExtensions'               { Set-FileExplorerHideFileExtensions -State $HideFileExtensions }
            'HideFolderMergeConflicts'         { Set-FileExplorerHideFolderMergeConflicts -State $HideFolderMergeConflicts }
            'LaunchFolderInSeparateProcess'    { Set-FileExplorerLaunchFolderInSeparateProcess -State $LaunchFolderInSeparateProcess }
            'ColorEncryptedAndCompressedFiles' { Set-FileExplorerColorEncryptedAndCompressedFiles -State $ColorEncryptedAndCompressedFiles }
            'ShowSyncProviderNotifications'    { Set-FileExplorerShowSyncProviderNotifications -State $ShowSyncProviderNotifications }
            'ItemsCheckBoxes'                  { Set-FileExplorerItemsCheckBoxes -State $ItemsCheckBoxes }
            'SharingWizard'                    { Set-FileExplorerSharingWizard -State $SharingWizard }
            'ExpandToCurrentFolder'            { Set-FileExplorerExpandToCurrentFolder -State $ExpandToCurrentFolder }
            'ShowAllFolders'                   { Set-FileExplorerShowAllFolders -State $ShowAllFolders }

            'DontUseSearchIndex'               { Set-FileExplorerDontUseSearchIndex -State $DontUseSearchIndex }

            'ShowGallery'                      { Set-FileExplorerShowGallery -State $ShowGallery }
            'HideDuplicateRemovableDrives'     { Set-FileExplorerHideDuplicateRemovableDrives -State $HideDuplicateRemovableDrives }
            'MaxIconCacheSize'                 { Set-FileExplorerMaxIconCacheSize -Value $MaxIconCacheSize }
            'AutoFolderTypeDetection'          { Set-FileExplorerAutoFolderTypeDetection -State $AutoFolderTypeDetection }
            'ConfirmFileDelete'                { Set-RecycleBinConfirmFileDelete -State $ConfirmFileDelete }
            'ConfirmFileDeleteGPO'             { Set-RecycleBinConfirmFileDelete -GPO $ConfirmFileDeleteGPO }
            'RecycleBin'                       { Set-RecycleBinRemoveFilesImmediately -State $RecycleBin }
            'RecycleBinGPO'                    { Set-RecycleBinRemoveFilesImmediately -GPO $RecycleBinGPO }
        }
    }
}
