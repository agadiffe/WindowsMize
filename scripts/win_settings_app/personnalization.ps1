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
Start-Transcript -Path "$PSScriptRoot\..\..\log\win_settings_app_$ScriptFileName.log"


#==============================================================================
#                                   Modules
#==============================================================================

Write-Output -InputObject 'Loading ''Win_settings_app\Personnalization'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\personnalization"



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

# Personalize your background
#---------------------------------------
# default: Windows spotlight

#                Picture
#=======================================

# Choose a photo
#---------------------------------------
# Default images location: C:\Windows\Web\Wallpaper
# default: "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
# ThemeA: Glow | ThemeB: Captured Motion | ThemeC: Sunrive | ThemeD: Flow
Set-BackgroundSetting -Wallpaper "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"

# Choose a fit for your desktop image
#---------------------------------------
# Fill (default) | Fit | Stretch | Span | Tile | Center
Set-BackgroundSetting -WallpaperStyle 'Fill'

#endregion background


#==========================================================
#                          Colors
#==========================================================
#region colors

Write-Section -Name 'Colors' -SubSection

# Choose your mode
#---------------------------------------
# Dark | Light (default)
Set-ColorsSetting -Theme 'Dark'
#Set-ColorsSetting -AppsTheme 'Dark' -SystemTheme 'Dark'

# Transparency effects
#---------------------------------------
# Disabled | Enabled (default)
Set-ColorsSetting -Transparency 'Enabled'

# Accent color
#---------------------------------------
# default manual color: blue (#0078D4)
# Manual | Automatic (default)
Set-ColorsSetting -AccentColorMode 'Manual'

# Show accent color on Start and taskbar (requires Dark mode)
#---------------------------------------
# Disabled (default) | Enabled
Set-ColorsSetting -ShowAccentColorOnStartAndTaskbar 'Disabled'

# Show accent color on title bars and windows borders
#---------------------------------------
# Disabled (default) | Enabled
Set-ColorsSetting -ShowAccentColorOnTitleAndBorders 'Disabled'

#endregion colors


#==========================================================
#                          Themes
#==========================================================
#region themes

Write-Section -Name 'Themes' -SubSection

#         Desktop icon settings
#=======================================

# Desktop icons
#---------------------------------------
$DesktopIcons = @(
    'ThisPC'
    #'UserFiles'
    'Network'
    'RecycleBin'
    #'ControlPanel'
)
#Set-ThemesSetting -DesktopIcons $DesktopIcons
Set-ThemesSetting -HideAllDesktopIcons

# Allow themes to change desktop icons
#---------------------------------------
# Disabled | Enabled (default)
Set-ThemesSetting -ThemesCanChangeDesktopIcons 'Disabled'

#endregion themes


#==========================================================
#                     Dynamic Lighting
#==========================================================
#region dynamic lighting

Write-Section -Name 'Dynamic Lighting' -SubSection

# Use Dynamic Lighting on my device
#---------------------------------------
# Disabled | Enabled (default)
Set-DynamicLightingSetting -DynamicLighting 'Disabled'

# Compatible apps in the foreground always control lighting
#---------------------------------------
# Disabled | Enabled (default)
Set-DynamicLightingSetting -ControlledByForegroundApp 'Disabled'

#endregion dynamic lighting


#==========================================================
#                       Lock screen
#==========================================================
#region lock screen

Write-Section -Name 'Lock screen' -SubSection

# Personalize your lock screen
#---------------------------------------
# default: Windows spotlight
# Picture choice is not handled.
# Default images location: C:\Windows\Web\Screen
Set-LockScreenSetting -SetToPicture

# Get fun facts, tips, tricks, and more on your lock screen
#---------------------------------------
# If disabled, Windows spotlight will be unset.
# Disabled | Enabled (default)
Set-LockScreenSetting -GetFunFactsTipsTricks 'Disabled'

# Show the lock screen background picture on the sign-in screen
#---------------------------------------
# Disabled | NotConfigured
Set-LockScreenSetting -ShowPictureOnSigninScreenGPO 'NotConfigured'

# Your widgets
#---------------------------------------
# Windows 11 24H2+ only.
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-LockScreenSetting -YourWidgets 'Disabled' -YourWidgetsGPO 'NotConfigured'

#endregion lock screen


#==========================================================
#                          Start
#==========================================================
#region start

Write-Section -Name 'Start' -SubSection

# Layout
#---------------------------------------
# Default (default) | MorePins | MoreRecommendations
Set-StartSetting -LayoutMode 'Default'

# Show recently added apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-StartSetting -ShowRecentlyAddedApps 'Disabled' -ShowRecentlyAddedAppsGPO 'NotConfigured'

# Show most used apps
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowMostUsedApps 'Disabled' -ShowMostUsedAppsGPO 'NotConfigured'

# Show recommended files in Start, recent files in File Explorer, and items in Jump Lists
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowRecentlyOpenedItems 'Enabled' -ShowRecentlyOpenedItemsGPO 'NotConfigured'

# Show recommendations for tips, shortcuts, new apps, and more
#---------------------------------------
# Disabled | Enabled (default)
Set-StartSetting -ShowRecommendations 'Disabled'

# Show account-related notifications
#---------------------------------------
# Disabled | Enabled (default)
Set-StartSetting -ShowAccountNotifications 'Disabled'

# Folders (choose which folders appear on Start next to the Power button)
#---------------------------------------
# Windows 11 only.
$StartMenuFolders = @(
    'Settings'
    #'FileExplorer'
    #'Network'
    'PersonalFolder'
    #'Documents'
    #'Downloads'
    #'Music'
    #'Pictures'
    #'Videos'
)
Set-StartSetting -FoldersNextToPowerButton $StartMenuFolders
#Set-StartSetting -HideAllFoldersNextToPowerButton

# Show mobile device in Start
#---------------------------------------
# Disabled (default) | Enabled
Set-StartSetting -ShowMobileDevice 'Disabled'

#endregion start


#==========================================================
#                         Taskbar
#==========================================================
#region taskbar

Write-Section -Name 'Taskbar' -SubSection

#             Taskbar items
#=======================================

# Search
#---------------------------------------
# State: Hide | IconOnly | Box (default) | IconAndLabel
# GPO: Hide | IconOnly | Box | IconAndLabel | NotConfigured
Set-TaskbarSetting -SearchBox 'Hide' -SearchBoxGPO 'NotConfigured'

# Task view
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -TaskView 'Disabled' -TaskViewGPO 'NotConfigured'

#           System tray icons
#=======================================

# Emoji and more
#---------------------------------------
# Never | WhileTyping (default) | Always
Set-TaskbarSetting -EmojiAndMore 'Never'

# Pen menu
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -PenMenu 'Disabled'

# Touch keyboard
#---------------------------------------
# Never | Always | WhenNoKeyboard (default)
Set-TaskbarSetting -TouchKeyboard 'Never'

# Virtual touchpad
#---------------------------------------
# Disabled (default) | Enabled
Set-TaskbarSetting -VirtualTouchpad 'Disabled'

#        Other system tray icons
#=======================================

# Hidden icon menu
#---------------------------------------
# If disabled, don't forget to manually turn on icons you want to be visible.
# Disabled | Enabled (default)
Set-TaskbarSetting -HiddenIconMenu 'Enabled'

#           Taskbar behaviors
#=======================================

# Taskbar alignment
#---------------------------------------
# Left | Center (default)
Set-TaskbarSetting -Alignment 'Center'

# Optimize taskbar for touch interactions when this device is used as a tablet
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -TouchOptimized 'Enabled'

# Automatically hide the taskbar
#---------------------------------------
# Disabled (default) | Enabled
Set-TaskbarSetting -AutoHide 'Disabled'

# Show badges on taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowAppsBadges 'Enabled'

# Show flashing on taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowAppsFlashing 'Enabled'

# Show my taskbar on all displays
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -ShowOnAllDisplays 'Disabled' -ShowOnAllDisplaysGPO 'NotConfigured'

# When using multiple displays, show my taskbar apps on
#---------------------------------------
# AllTaskbars (default) | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen
Set-TaskbarSetting -ShowAppsOnMultipleDisplays 'AllTaskbars'

# Share any window from my taskbar
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShareAnyWindow 'Enabled'

# Select the far corner of the taskbar to show the desktop
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -FarCornerToShowDesktop 'Enabled'

# Combine taskbar buttons and hide labels
#---------------------------------------
# State: Always (default) | WhenTaskbarIsFull | Never
# GPO: Disabled | NotConfigured
Set-TaskbarSetting -GroupAndHideLabelsMainTaskbar 'Always' -GroupAndHideLabelsGPO 'NotConfigured'

# Combine taskbar buttons and hide labels on other taskbars
#---------------------------------------
# Always (default) | WhenTaskbarIsFull | Never
Set-TaskbarSetting -GroupAndHideLabelsOtherTaskbars 'Always'

# Show hover cards for inactive and pinned taskbar apps
#---------------------------------------
# Disabled | Enabled (default)
Set-TaskbarSetting -ShowJumplistOnHover 'Disabled'

#endregion taskbar


#==========================================================
#                       Device usage
#==========================================================
#region device usage

Write-Section -Name 'Device usage' -SubSection

# default: Disabled
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


Stop-Transcript
