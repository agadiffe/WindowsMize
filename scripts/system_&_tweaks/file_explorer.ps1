#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

$Global:ModuleVerbosePreference = 'Continue' # Do not disable (log file will be empty)
Write-Output -InputObject 'Loading ''File_explorer'' Module ...'
Import-Module -Name "$PSScriptRoot\..\src\modules\file_explorer"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                                  File Explorer
#=================================================================================================================

Write-Section -Name 'File Explorer'

#==============================================================================
#                                   General
#==============================================================================
#region general

Write-Section -Name 'General' -SubSection

# --- Open file explorer to
# State: ThisPC | Home (default) | Downloads | OneDrive
Set-FileExplorerSetting -LaunchTo 'Home'

# --- Open each folder in same/new window
# State: SameWindow (default) | NewWindow
#Set-FileExplorerSetting -OpenFolder 'SameWindow'

# --- Open desktop folders and external folder links in new tab (default: Enabled)
# Requires 'Open each folder in the same window'.
#Set-FileExplorerSetting -OpenFolderInNewTab 'Enabled'

# --- Single/Double-click to open an item
# State: SingleClick | DoubleClick (default)
#Set-FileExplorerSetting -OpenItem 'DoubleClick'

# --- Show recently used files (default: Enabled)
Set-FileExplorerSetting -ShowRecentFiles 'Enabled'

# --- Show frequently used folders (default: Enabled)
Set-FileExplorerSetting -ShowFrequentFolders 'Disabled'

# --- Include account-based insights, recent, favorite, and recommended files (default: Enabled)
# (aka Show files from Office.com)
Set-FileExplorerSetting -ShowCloudFiles 'Disabled'

# --- Recommended Section (default: Enabled)
# Requires "Show files from Office.com".
Set-FileExplorerSetting -ShowRecommendedSection 'Disabled'

#endregion general

#==============================================================================
#                                     View
#==============================================================================
#region view

Write-Section -Name 'View' -SubSection

#           Files and Folders
#=======================================

# --- Always show icons, never thumbnails (default: Disabled)
#Set-FileExplorerSetting -ShowIconsOnly 'Disabled'

# --- Decrease space between items (compact view) (default: Disabled)
Set-FileExplorerSetting -CompactView 'Enabled'

# --- Display file icon on thumbnails (default: Enabled)
#Set-FileExplorerSetting -ShowFileIconOnThumbnails 'Enabled'

# --- Display file size information in folder tips (default: Enabled)
#Set-FileExplorerSetting -ShowFileSizeInFolderTips 'Enabled'

# --- Display the full path in the title bar (default: Disabled)
#Set-FileExplorerSetting -ShowFullPathInTitleBar 'Disabled'

# --- Hidden files, folders, and drives (default: Disabled)
Set-FileExplorerSetting -ShowHiddenItems 'Enabled'

# --- Hide empty drives (default: Enabled)
#Set-FileExplorerSetting -HideEmptyDrives 'Enabled'

# --- Hide extensions for known file types (default: Enabled)
Set-FileExplorerSetting -HideFileExtensions 'Disabled'

# --- Hide folder merge conflicts (default: Enabled)
Set-FileExplorerSetting -HideFolderMergeConflicts 'Disabled'

# --- Hide protected operating system files (Recommended) (default: Enabled)
#Set-FileExplorerSetting -HideProtectedSystemFiles 'Enabled'

# --- Launch folder windows in a separate process (default: Disabled)
#Set-FileExplorerSetting -LaunchFolderInSeparateProcess 'Disabled'

# --- Restore previous folder windows at logon (default: Disabled)
#Set-FileExplorerSetting -RestorePreviousFoldersAtLogon 'Disabled'

# --- Show drive letters (default: Enabled)
#Set-FileExplorerSetting -ShowDriveLetters 'Enabled'

# --- Show encrypted or compressed NTFS files in color (default: Disabled)
#Set-FileExplorerSetting -ColorEncryptedAndCompressedFiles 'Disabled'

# --- Show pop-up description for folder and desktop items (default: Enabled)
#Set-FileExplorerSetting -ShowItemsInfoPopup 'Enabled'

# --- Show preview handlers in preview pane (default: Enabled)
#Set-FileExplorerSetting -ShowPreviewHandlers 'Enabled'

# --- Show status bar (default: Enabled)
#Set-FileExplorerSetting -ShowStatusBar 'Enabled'

# --- Show sync provider notifications (OneDrive Ads) (default: Enabled)
Set-FileExplorerSetting -ShowSyncProviderNotifications 'Disabled'

# --- Use check boxes to select items (default: Disabled)
Set-FileExplorerSetting -ItemsCheckBoxes 'Enabled'

# --- Use sharing wizard (default: Enabled)
Set-FileExplorerSetting -SharingWizard 'Disabled'

# --- When typing into list view
# State: SelectItemInView (default) | AutoTypeInSearchBox
#Set-FileExplorerSetting -TypingIntoListViewBehavior 'SelectItemInView'

#            Navigation pane
#=======================================

# --- Always show availability status (OneDrive files) (default: Enabled)
Set-FileExplorerSetting -ShowCloudStatesOnNavPane 'Disabled'

# --- Expand to open folder (default: Disabled)
#Set-FileExplorerSetting -ExpandToCurrentFolder 'Disabled'

# --- Show all folders (default: Disabled)
#Set-FileExplorerSetting -ShowAllFolders 'Disabled'

# --- Show Libraries (default: Disabled)
#Set-FileExplorerSetting -ShowLibraries 'Disabled'

# --- Show Network (default: Enabled)
#Set-FileExplorerSetting -ShowNetwork 'Enabled'

# --- Show This PC (default: Enabled)
#Set-FileExplorerSetting -ShowThisPC 'Enabled'

#endregion view

#==============================================================================
#                                    Search
#==============================================================================
#region search

Write-Section -Name 'Search' -SubSection

#             How to search
#=======================================

# --- Don't use the index when searching in file folders for system files (default: Disabled)
Set-FileExplorerSetting -DontUseSearchIndex 'Enabled'

# When searching non-indexed locations
#=======================================

# --- Include system directories (default: Enabled)
#Set-FileExplorerSetting -IncludeSystemFolders 'Enabled'

# --- Include compressed files (ZIP, CAB...) (default: Disabled)
#Set-FileExplorerSetting -IncludeCompressedFiles 'Disabled'

# --- Always search file names and contents (this might take several minutes) (default: Disabled)
#Set-FileExplorerSetting -SearchFileNamesAndContents 'Disabled'

#endregion search

#==============================================================================
#                                Miscellaneous
#==============================================================================
#region miscellaneous

Write-Section -Name 'Miscellaneous' -SubSection

# --- Show Navigation Pane (default: Enabled)
#Set-FileExplorerSetting -ShowNavigationPane 'Enabled'

# --- Show Home (default: Enabled)
Set-FileExplorerSetting -ShowHome 'Enabled'

# --- Show Gallery (default: Enabled)
Set-FileExplorerSetting -ShowGallery 'Disabled'

# --- Show removable drives only in 'This PC' (default: Disabled)
Set-FileExplorerSetting -ShowRemovableDrivesOnlyInThisPC 'Enabled'

# --- Max icon cache size (default: 512 KB)
Set-FileExplorerSetting -MaxIconCacheSize 4096

# --- Auto folder type detection (default: Enabled)
Set-FileExplorerSetting -AutoFolderTypeDetection 'Disabled'

# --- Undo/Redo feature (default: Enabled)
#Set-FileExplorerSetting -UndoRedo 'Enabled'

# --- Recycle Bin (default: Enabled)
# Disabled: don't move files to the Recycle Bin. Remove files immediately when deleted.
#Set-FileExplorerSetting -RecycleBin 'Enabled' -RecycleBinGPO 'NotConfigured'

# --- Display delete confirmation dialog (default: Disabled)
#Set-FileExplorerSetting -ConfirmFileDelete 'Disabled' -ConfirmFileDeleteGPO 'NotConfigured'

#endregion miscellaneous
