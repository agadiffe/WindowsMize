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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\applications\settings"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

Write-Section -Name 'Applications Settings'

#==============================================================================
#                                Windows Photos
#==============================================================================

Write-Section -Name 'Windows Photos' -SubSection

#               Settings
#=======================================

# --- Customize theme
# State: System | Light | Dark (default)
Set-WindowsPhotosSetting -Theme 'Dark'

# --- Show gallery tiles attributes (default: Enabled)
Set-WindowsPhotosSetting -ShowGalleryTilesAttributes 'Enabled'

# --- Enable location based features (default: Disabled)
Set-WindowsPhotosSetting -LocationBasedFeatures 'Disabled'

# --- Show iCloud photos (default: Enabled)
Set-WindowsPhotosSetting -ShowICloudPhotos 'Disabled'

# --- Ask for permission to delete photos (default: Enabled)
Set-WindowsPhotosSetting -DeleteConfirmationDialog 'Enabled'

# --- Mouse wheel
# State: ZoomInOut (default) | NextPreviousItems
Set-WindowsPhotosSetting -MouseWheelBehavior 'ZoomInOut'

# --- Zoom preference (media smaller than window)
# State: FitWindow | ViewActualSize (default)
Set-WindowsPhotosSetting -SmallMediaZoomPreference 'ViewActualSize'

# --- Allow image categorization (default: Disabled)
Set-WindowsPhotosSetting -ImageCategorization 'Disabled'

# --- Performance (run in the background at startup) (default: Enabled) | old
#Set-WindowsPhotosSetting -RunAtStartup 'Disabled'

# --- Include a watermark when content is Al-generated
# State: Never (default) | Always | Ask
Set-WindowsPhotosSetting -AIWatermark 'Never'

#             Miscellaneous
#=======================================

# --- Gallery type
# State: River (default) | Square
Set-WindowsPhotosSetting -GalleryType 'River'

# --- Gallery size
# State: Small | Medium (default) | Large
Set-WindowsPhotosSetting -GallerySize 'Medium'

# --- First Run Experience (default: Enabled)
#   First Run Experience dialog
#   Image categorization popup
#   OneDrive Promo flyout
#   Designer Editor flyout
#   ClipChamp flyout
#   AI Generative Erase tip
Set-WindowsPhotosSetting -FirstRunExperience 'Disabled'
