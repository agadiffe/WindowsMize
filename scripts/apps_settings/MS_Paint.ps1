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

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

Write-Section -Name 'Applications Settings'

#==============================================================================
#                               Microsoft Paint
#==============================================================================

Write-Section -Name 'Microsoft Paint' -SubSection

#==========================================================
#                        Appearance
#==========================================================

# --- App theme
# State: System (default) | Light | Dark
Set-MicrosoftPaintSetting -Theme 'System'

#==========================================================
#                            AI
#==========================================================

# --- Include a watermark when content is Al-generated
# State: Never (default) | Always | Ask
Set-MicrosoftPaintSetting -AIWatermark 'Never'

#==========================================================
#                     Image Properties
#==========================================================

# --- Units
# State: Pixels (default) | Inches | Centimeters
Set-MicrosoftPaintSetting -Unit 'Pixels'

#              Image Size
#=======================================

# --- Width (default: 1152 (range: 1-99999))
Set-MicrosoftPaintSetting -ImageWidthPixel 1152

# --- Height (default: 648 (range: 1-99999))
Set-MicrosoftPaintSetting -ImageHeightPixel 648

#==========================================================
#                           View
#==========================================================

# --- Rulers (default: Disabled)
Set-MicrosoftPaintSetting -Rulers 'Disabled'

# --- Gridlines (default: Disabled)
Set-MicrosoftPaintSetting -Gridlines 'Disabled'

# --- StatusBar (default: Enabled)
Set-MicrosoftPaintSetting -StatusBar 'Enabled'

# --- Automatically hide toolbar (default: Disabled)
Set-MicrosoftPaintSetting -AutoHideToolbar 'Disabled'
