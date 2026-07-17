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
#                            Windows Snipping Tool
#==============================================================================

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
#   Shapes tip | old
#   Visual Search tip | old
Set-WindowsSnippingToolSetting -TeachingTips 'Disabled'
