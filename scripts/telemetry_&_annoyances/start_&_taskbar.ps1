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
#                          Start
#==========================================================
#region start

Write-Section -Name 'Start' -SubSection

# --- Layout | old
# State: Default (default) | MorePins | MoreRecommendations
#Set-StartSetting -LayoutMode 'Default'

# --- Start menu size
# State: Auto (default) | Small | Large
Set-StartSetting -StartMenuSize 'Small'

#           Pinned (section)
#=======================================

# --- Pinned section (default: Enabled)
Set-StartSetting -PinnedSection 'Enabled'

# --- --- Show All Pins By Default (default: Disabled)
# This setting is on the Start Menu itself.
Set-StartSetting -ShowAllPins 'Enabled'

#           Recent (section)
#=======================================

# --- Recent section (default: Enabled)
Set-StartSetting -RecentSection 'Enabled' -RecentSectionGPO 'NotConfigured'

# --- --- Show recently added apps (default: Enabled)
Set-StartSetting -ShowRecentAddedApps 'Disabled' -ShowRecentAddedAppsGPO 'NotConfigured'

# --- --- Show recent and suggested files (default: Enabled)
Set-StartSetting -ShowRecentFilesInStart 'Enabled'

# --- --- Show tips and app recommendations (default: Enabled)
Set-StartSetting -ShowTipsAndAppRecommendations 'Disabled'

# --- --- Show websites from your browsing history | old ?
Set-StartSetting -ShowWebsitesFromBrowsingHistoryGPO 'Disabled'

#          All (apps section)
#=======================================

# --- All apps section (default: Enabled)
Set-StartSetting -AllAppsSection 'Enabled' -AllAppsSectionGPO 'NotConfigured'

# --- --- All apps view mode
# This setting is on the Start Menu itself.
# Mode: Category (default) | Grid | List
Set-StartSetting -AllAppsViewMode 'Category'

# --- --- Show most used apps (grid and list views only) (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowMostUsedApps 'Disabled' -ShowMostUsedAppsGPO 'NotConfigured'

#                 Other
#=======================================

# --- Show mobile device in Start (default: Disabled)
Set-StartSetting -ShowMobileDevice 'Disabled'

# --- Folders (choose which folders appear on Start next to the Power button)
# Windows 11 only.
# Comment every items to hide all shortcuts.
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

# --- Show account-related notifications (default: Enabled)
Set-StartSetting -ShowAccountNotifications 'Disabled'

# --- Show recent items in jump lists and File Explorer (default: Enabled)
# Disabled: also turn off recent files in the Start menu.
Set-StartSetting -ShowRecentItems 'Enabled' -ShowRecentItemsGPO 'NotConfigured'

# --- Hide your name and profile picture on Start (default: Disabled)
Set-StartSetting -HideNameAndPicture 'Disabled'

#endregion start

#==========================================================
#                         Taskbar
#==========================================================
#region taskbar

Write-Section -Name 'Taskbar' -SubSection

#             Taskbar items
#=======================================

# --- Search
# State: Hide | IconOnly | Box (default) | IconAndLabel
# GPO: Hide | IconOnly | Box | IconAndLabel | NotConfigured
Set-TaskbarSetting -SearchBox 'Hide' -SearchBoxGPO 'NotConfigured'

# --- Ask Copilot (default: Disabled)
# Disabled: also set the "Copilot and Win+C" keys to "None Selected".
Set-TaskbarSetting -AskCopilot 'Disabled'

# --- Task view (default: Enabled)
Set-TaskbarSetting -TaskView 'Disabled' -TaskViewGPO 'NotConfigured'

# ---  Widgets (default: Enabled)
# UCPD protected
#Set-TaskbarSetting -Widgets 'Disabled'

# --- Resume (default: Enabled)
Set-TaskbarSetting -ResumeAppNotif 'Disabled'

#           System tray icons
#=======================================

# --- Emoji and more
# State: Never | WhileTyping (default) | Always
Set-TaskbarSetting -EmojiAndMore 'Never'

# --- Pen menu (default: Enabled)
Set-TaskbarSetting -PenMenu 'Disabled'

# --- Touch keyboard
# State: Never | Always | WhenNoKeyboard (default)
Set-TaskbarSetting -TouchKeyboard 'WhenNoKeyboard'

# --- Virtual touchpad (default: Disabled)
Set-TaskbarSetting -VirtualTouchpad 'Disabled'

#        Other system tray icons
#=======================================

# --- Hidden icon menu (default: Enabled)
# If disabled, don't forget to manually turn on icons you want to be visible.
Set-TaskbarSetting -HiddenIconMenu 'Enabled'

#           Taskbar behaviors
#=======================================

# --- Taskbar position
# State: Left | Top | Right | Bottom (default)
Set-TaskbarSetting -Position 'Bottom'

# --- Taskbar icon alignment
# State: Left | Center (default)
Set-TaskbarSetting -IconAlignment 'Center'

# --- Taskbar size
# State: Default (default) | Small
Set-TaskbarSetting -Size 'Default'

# --- Optimize taskbar for touch interactions when this device is used as a tablet (default: Enabled)
#Set-TaskbarSetting -TouchOptimized 'Enabled'

# --- Automatically hide the taskbar (default: Disabled)
Set-TaskbarSetting -AutoHide 'Disabled'

# --- Show badges on taskbar apps (default: Enabled)
#Set-TaskbarSetting -ShowAppsBadges 'Enabled'

# --- Show flashing on taskbar apps (default: Enabled)
#Set-TaskbarSetting -ShowAppsFlashing 'Enabled'

# --- Show my taskbar on all displays (default: Disabled)
#Set-TaskbarSetting -ShowOnAllDisplays 'Disabled' -ShowOnAllDisplaysGPO 'NotConfigured'

# --- When using multiple displays, show my taskbar apps on
# State: AllTaskbars (default) | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen
#Set-TaskbarSetting -ShowAppsOnMultipleDisplays 'AllTaskbars'

# --- Share any window from my taskbar (default: Enabled)
Set-TaskbarSetting -ShareAnyWindow 'Disabled'

# --- Select the far corner of the taskbar to show the desktop (default: Enabled)
Set-TaskbarSetting -FarCornerToShowDesktop 'Enabled'

# --- Combine taskbar buttons and hide labels
# State: Always (default) | WhenTaskbarIsFull | Never
Set-TaskbarSetting -GroupAndHideLabelsMainTaskbar 'Always' -GroupAndHideLabelsGPO 'NotConfigured'

# --- Combine taskbar buttons and hide labels on other taskbars
# State: Always (default) | WhenTaskbarIsFull | Never
#Set-TaskbarSetting -GroupAndHideLabelsOtherTaskbars 'Always'

# --- Show smaller taskbar buttons
# State: Always | Never | WhenFull (default)
Set-TaskbarSetting -ShowSmallerButtons 'WhenFull'

# --- Show jump list when hovering on inactive taskbar apps (default: Enabled)
Set-TaskbarSetting -ShowJumplistOnHover 'Enabled'

#endregion taskbar
