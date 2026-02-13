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
#                               Windows Notepad
#==============================================================================
#region notepad

Write-Section -Name 'Windows Notepad' -SubSection

#              Appearance
#=======================================

# --- App theme
# State: System (default) | Light | Dark
Set-WindowsNotepadSetting -Theme 'System'

#            Text Formatting
#=======================================

# --- Font family
# State (e.g.): Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman | ...
Set-WindowsNotepadSetting -FontFamily 'Consolas'

# --- Font style
# State: Regular (default) | Italic | Bold | Bold Italic
Set-WindowsNotepadSetting -FontStyle 'Regular'

# --- Font size
# Dropdown GUI values: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72
# default: 11 (range 1-99)
Set-WindowsNotepadSetting -FontSize 11

# --- Word wrap (default: Enabled)
Set-WindowsNotepadSetting -WordWrap 'Enabled'

# --- Formatting (default: Enabled)
Set-WindowsNotepadSetting -Formatting 'Enabled'

#            Opening Notepad
#=======================================

# --- Opening files
# State: NewTab (default) | NewWindow
Set-WindowsNotepadSetting -OpenFile 'NewTab'

# --- When Notepad starts : Continue previous session (default: Enabled)
Set-WindowsNotepadSetting -ContinuePreviousSession 'Disabled'

# --- Recent Files (default: Enabled)
Set-WindowsNotepadSetting -RecentFiles 'Enabled'

#               Spelling
#=======================================

# --- Spell check (default: Enabled)
Set-WindowsNotepadSetting -SpellCheck 'Disabled'

# --- Autocorrect (default: Enabled)
Set-WindowsNotepadSetting -AutoCorrect 'Disabled'

#              AI Features
#=======================================

# --- Copilot (default: Enabled)
Set-WindowsNotepadSetting -Copilot 'Disabled'

#             Miscellaneous
#=======================================

# --- Status bar (default: Enabled)
Set-WindowsNotepadSetting -StatusBar 'Enabled'

# --- Continue Previous Session tip (notepad automatically saves your progress) (default: Enabled)
Set-WindowsNotepadSetting -ContinuePreviousSessionTip 'Disabled'

# --- Formatting tips (default: Enabled)
Set-WindowsNotepadSetting -FormattingTips 'Disabled'

#endregion windows notepad

#==============================================================================
#                                Windows Photos
#==============================================================================
#region photos

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

# --- Performance (run in the background at startup) (default: Enabled)
Set-WindowsPhotosSetting -RunAtStartup 'Disabled'

#             Miscellaneous
#=======================================

# --- First Run Experience (default: Enabled)
#   First Run Experience dialog
#   Image categorization popup
#   OneDrive Promo flyout
#   Designer Editor flyout
#   ClipChamp flyout
#   AI Generative Erase tip
Set-WindowsPhotosSetting -FirstRunExperience 'Disabled'

#endregion photos

#==============================================================================
#                            Windows Snipping Tool
#==============================================================================
#region snipping tool

Write-Section -Name 'Windows Snipping Tool' -SubSection

#               Snipping
#=======================================

# --- Automatically copy changes (default: Enabled)
Set-WindowsSnippingToolSetting -AutoCopyScreenshotChangesToClipboard 'Enabled'

# --- Automatically save original screenshots (default: Enabled)
Set-WindowsSnippingToolSetting -AutoSaveScreenshots 'Enabled'

# --- Ask to save edited screenshots (default: Disabled)
Set-WindowsSnippingToolSetting -AskToSaveEditedScreenshots 'Disabled'

# --- Multiple windows (default: Disabled)
Set-WindowsSnippingToolSetting -MultipleWindows 'Disabled'

# --- Add border to each screenshot (default: Disabled)
Set-WindowsSnippingToolSetting -ScreenshotBorder 'Disabled'

# --- HDR screenshot color corrector (default: Disabled)
Set-WindowsSnippingToolSetting -HDRColorCorrector 'Disabled'

#           Screen recording
#=======================================

# --- Automatically copy changes (default: Enabled)
Set-WindowsSnippingToolSetting -AutoCopyRecordingChangesToClipboard 'Enabled'

# --- Automatically save original screen recordings (default: Enabled)
Set-WindowsSnippingToolSetting -AutoSaveRecordings 'Enabled'

# --- Ask to save edited screen recordings (default: Enabled)
Set-WindowsSnippingToolSetting -AskToSaveEditedRecordings 'Disabled'

# --- Include microphone input by default when a screen recording starts (default: Disabled)
Set-WindowsSnippingToolSetting -IncludeMicrophoneInRecording 'Disabled'

# --- Include system audio by default when a screen recording starts (default: Enabled)
Set-WindowsSnippingToolSetting -IncludeSystemAudioInRecording 'Enabled'

#              Appearance
#=======================================

# --- App theme
# State: System (default) | Light | Dark
Set-WindowsSnippingToolSetting -Theme 'System'

#             Miscellaneous
#=======================================

# --- Teaching tips (default: Enabled)
#   Auto save banner (Recordings & Sceenshots)
#   Color Picker beacon (blue dot)
#   Text Extractor beacon (blue dot)
#   Live Annotation Mode tip
Set-WindowsPhotosSetting -TeachingTips 'Disabled'

#endregion snipping tool
