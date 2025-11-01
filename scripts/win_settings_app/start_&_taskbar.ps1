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
Write-Output -InputObject 'Loading ''Win_settings_app\Personnalization'' Module ...'
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

# --- Show All Pins By Default (default: Disabled)
# This setting has moved directly into the Start Menu with "Show more"/"Show less" options.
Set-StartSetting -ShowAllPins 'Enabled'

# --- Show recently added apps (default: Enabled)
Set-StartSetting -ShowRecentlyAddedApps 'Disabled' -ShowRecentlyAddedAppsGPO 'NotConfigured'

# --- Show most used apps (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowMostUsedApps 'Disabled' -ShowMostUsedAppsGPO 'NotConfigured'

# --- Show recommended files in Start, recent files in File Explorer, and items in Jump Lists (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-StartSetting -ShowRecentlyOpenedItems 'Enabled' -ShowRecentlyOpenedItemsGPO 'NotConfigured'

# --- Show Websites From Your Browsing History
Set-StartSetting -ShowWebsitesFromHistoryGPO 'Disabled'

# --- Show recommendations for tips, shortcuts, new apps, and more (default: Enabled)
Set-StartSetting -ShowRecommendations 'Disabled'

# --- Show account-related notifications (default: Enabled)
Set-StartSetting -ShowAccountNotifications 'Disabled'

# --- Folders (choose which folders appear on Start next to the Power button)
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

# --- Show mobile device in Start (default: Disabled)
Set-StartSetting -ShowMobileDevice 'Disabled'

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

# --- Task view (default: Enabled)
Set-TaskbarSetting -TaskView 'Disabled' -TaskViewGPO 'NotConfigured'

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

# --- Taskbar alignment
# State: Left | Center (default)
Set-TaskbarSetting -Alignment 'Center'

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
#Set-TaskbarSetting -ShareAnyWindow 'Enabled'

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
