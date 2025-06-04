#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#==============================================================================
#                                Requirements
#==============================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\..\log\$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''File_explorer'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\src\modules\file_explorer"



#=================================================================================================================
#                                                  File Explorer
#=================================================================================================================

Write-Section -Name 'File Explorer'

#==============================================================================
#                                   General
#==============================================================================

Write-Section -Name 'General' -SubSection

# Open file explorer to
#---------------------------------------
# ThisPC | Home (default) | Downloads | OneDrive
Set-FileExplorerSetting -LaunchTo 'Home'

# Open each folder in same/new window
#---------------------------------------
# SameWindow (default) | NewWindow
Set-FileExplorerSetting -OpenFolder 'SameWindow'

# Open desktop folders and external folder links in new tab
#---------------------------------------
# Requires 'Open each folder in the same window'.
# Disabled | Enabled (default)
Set-FileExplorerSetting -OpenFolderInNewTab 'Enabled'

# Single/Double-click to open an item
#---------------------------------------
# SingleClick | DoubleClick (default)
Set-FileExplorerSetting -OpenItem 'DoubleClick'

# Show recently used files
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowRecentFiles 'Enabled'

# Show frequently used folders
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowFrequentFolders 'Disabled'

# Show files from Office.com
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowCloudFiles 'Disabled'


#==============================================================================
#                                     View
#==============================================================================

Write-Section -Name 'View' -SubSection

#           Files and Folders
#=======================================

# Always show icons, never thumbnails
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowIconsOnly 'Disabled'

# Decrease space between items (compact view)
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -CompactView 'Enabled'

# Display file icon on thumbnails
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowFileIconOnThumbnails 'Enabled'

# Display file size information in folder tips
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowFileSizeInFolderTips 'Enabled'

# Display the full path in the title bar
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowFullPathInTitleBar 'Disabled'

# Hidden files, folders, and drives
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowHiddenItems 'Enabled'

# Hide empty drives
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideEmptyDrives 'Enabled'

# Hide extensions for known file types
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideFileExtensions 'Disabled'

# Hide folder merge conflicts
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideFolderMergeConflicts 'Disabled'

# Hide protected operating system files (Recommended)
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -HideProtectedSystemFiles 'Enabled'

# Launch folder windows in a separate process
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -LaunchFolderInSeparateProcess 'Disabled'

# Restore previous folder windows at logon
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -RestorePreviousFoldersAtLogon 'Disabled'

# Show drive letters
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowDriveLetters 'Enabled'

# Show encrypted or compressed NTFS files in color
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ColorEncryptedAndCompressedFiles 'Disabled'

# Show pop-up description for folder and desktop items
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowItemsInfoPopup 'Enabled'

# Show preview handlers in preview pane
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowPreviewHandlers 'Enabled'

# Show status bar
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowStatusBar 'Enabled'

# Show sync provider notifications (OneDrive Ads)
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowSyncProviderNotifications 'Disabled'

# Use check boxes to select items
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ItemsCheckBoxes 'Enabled'

# Use sharing wizard
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -SharingWizard 'Disabled'

# When typing into list view
#---------------------------------------
# SelectItemInView (default) | AutoTypeInSearchBox
Set-FileExplorerSetting -TypingIntoListViewBehavior 'SelectItemInView'

#            Navigation pane
#=======================================

# Always show availability status (OneDrive files)
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowCloudStatesOnNavPane 'Disabled'

# Expand to open folder
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ExpandToCurrentFolder 'Disabled'

# Show all folders
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowAllFolders 'Disabled'

# Show Libraries
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowLibraries 'Disabled'

# Show Network
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowNetwork 'Enabled'

# Show This PC
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowThisPC 'Enabled'

#==============================================================================
#                                    Search
#==============================================================================

Write-Section -Name 'Search' -SubSection

#             How to search
#=======================================

# Don't use the index when searching in file folders for system files
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -DontUseSearchIndex 'Enabled'

# When searching non-indexed locations
#=======================================

# Include system directories
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -IncludeSystemFolders 'Enabled'

# Include compressed files (ZIP, CAB...)
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -IncludeCompressedFiles 'Disabled'

# Always search file names and contents (this might take several minutes)
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -SearchFileNamesAndContents 'Disabled'


#==============================================================================
#                                Miscellaneous
#==============================================================================

Write-Section -Name 'Miscellaneous' -SubSection

# Show Home
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowHome 'Enabled'

# Show Gallery
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -ShowGallery 'Disabled'

# Show removable drives only in 'This PC'
#---------------------------------------
# Disabled (default) | Enabled
Set-FileExplorerSetting -ShowRemovableDrivesOnlyInThisPC 'Enabled'

# Max icon cache size
#---------------------------------------
# default: 512KB
Set-FileExplorerSetting -MaxIconCacheSize 4096

# Auto folder type detection
#---------------------------------------
# Disabled | Enabled (default)
Set-FileExplorerSetting -AutoFolderTypeDetection 'Disabled'

# Recycle Bin
#---------------------------------------
# Disabled: don't move files to the Recycle Bin. Remove files immediately when deleted.
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-FileExplorerSetting -RecycleBin 'Enabled' -RecycleBinGPO 'NotConfigured'

# Display delete confirmation dialog
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-FileExplorerSetting -ConfirmFileDelete 'Disabled' -ConfirmFileDeleteGPO 'NotConfigured'


Stop-Transcript
