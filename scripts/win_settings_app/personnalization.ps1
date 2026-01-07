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

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\personnalization"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                               Personnalization
#==============================================================================

Write-Section -Name 'Windows Settings App - Personnalization'

#==========================================================
#                        Background
#==========================================================
#region background

Write-Section -Name 'Background' -SubSection

# --- Personalize your background
# default: Windows spotlight

#                Picture
#=======================================

# --- Choose a photo
# default: "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
#Set-BackgroundSetting -Wallpaper "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"

# --- Choose a fit for your desktop image
# State: Fill (default) | Fit | Stretch | Span | Tile | Center
#Set-BackgroundSetting -WallpaperStyle 'Fill'

#endregion background

#==========================================================
#                          Colors
#==========================================================
#region colors

Write-Section -Name 'Colors' -SubSection

# --- Choose your mode
# State: Dark | Light (default)
Set-ColorsSetting -Theme 'Dark'
#Set-ColorsSetting -AppsTheme 'Dark' -SystemTheme 'Dark'

# --- Transparency effects (default: Enabled)
Set-ColorsSetting -Transparency 'Enabled'

# --- Accent color
# default manual color: blue (#0078D4)
# State: Manual | Automatic (default)
Set-ColorsSetting -AccentColorMode 'Manual'

# --- Show accent color on Start and taskbar (default: Disabled)
# Requires Dark mode.
Set-ColorsSetting -ShowAccentColorOnStartAndTaskbar 'Disabled'

# --- Show accent color on title bars and windows borders (default: Disabled)
Set-ColorsSetting -ShowAccentColorOnTitleAndBorders 'Disabled'

#endregion colors

#==========================================================
#                          Themes
#==========================================================
#region themes

Write-Section -Name 'Themes' -SubSection

#         Desktop icon settings
#=======================================

# --- Desktop icons
$DesktopIcons = @(
    'ThisPC'
    #'UserFiles'
    #'Network'
    'RecycleBin'
    #'ControlPanel'
)
Set-ThemesSetting -DesktopIcons $DesktopIcons
#Set-ThemesSetting -HideAllDesktopIcons

# --- Allow themes to change desktop icons (default: Enabled)
Set-ThemesSetting -ThemesCanChangeDesktopIcons 'Disabled'

#endregion themes

#==========================================================
#                     Dynamic Lighting
#==========================================================
#region dynamic lighting

Write-Section -Name 'Dynamic Lighting' -SubSection

# --- Use Dynamic Lighting on my device (default: Enabled)
Set-DynamicLightingSetting -DynamicLighting 'Disabled'

# --- Compatible apps in the foreground always control lighting (default: Enabled)
Set-DynamicLightingSetting -ControlledByForegroundApp 'Disabled'

#endregion dynamic lighting

#==========================================================
#                       Lock screen
#==========================================================
#region lock screen

Write-Section -Name 'Lock screen' -SubSection

# --- Personalize your lock screen (default: Windows spotlight)
# Picture choice is not handled.
# Default images location: C:\Windows\Web\Screen
#Set-LockScreenSetting -SetToPicture

# --- Get fun facts, tips, tricks, and more on your lock screen (default: Enabled)
# If disabled, Windows spotlight will be unset.
#Set-LockScreenSetting -GetFunFactsTipsTricks 'Disabled'

# --- Show the lock screen background picture on the sign-in screen (default: Enabled)
Set-LockScreenSetting -ShowPictureOnSigninScreen 'Enabled' -ShowPictureOnSigninScreenGPO 'NotConfigured'

# --- Your widgets (default: Enabled)
# Windows 11 24H2+ only.
Set-LockScreenSetting -YourWidgets 'Disabled' -YourWidgetsGPO 'NotConfigured'

#endregion lock screen

#==========================================================
#                          Start
#==========================================================
#region start
# See "scripts > win_settings_app > start_&_taskbar.ps1"
#endregion start

#==========================================================
#                         Taskbar
#==========================================================
#region taskbar
# See "scripts > win_settings_app > start_&_taskbar.ps1"
#endregion taskbar

#==========================================================
#                       Device usage
#==========================================================
#region device usage

Write-Section -Name 'Device usage' -SubSection

# default: DisableAll
$DeviceUsageOption = @(
    #'Creativity'
    #'Business'
    #'Development'
    'Entertainment'
    #'Family'
    #'Gaming'
    #'School'
)
#Set-DeviceUsageSetting -Value $DeviceUsageOption
Set-DeviceUsageSetting -DisableAll

#endregion device usage
