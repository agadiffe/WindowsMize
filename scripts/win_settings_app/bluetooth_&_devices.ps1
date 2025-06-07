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

Write-Output -InputObject 'Loading ''Win_settings_app\Bluetooth_&_devices'' Module ...'

# Do not disable, otherwise the log file will be empty.
$Global:ModuleVerbosePreference = 'Continue'

Import-Module -Name "$PSScriptRoot\..\..\src\modules\settings_app\bluetooth_&_devices"



#=================================================================================================================
#                                              Windows Settings App
#=================================================================================================================

#==============================================================================
#                             Bluetooth & devices
#==============================================================================

Write-Section -Name 'Windows Settings App - Bluetooth & devices'

#==========================================================
#                         Devices
#==========================================================
#region devices

Write-Section -Name 'Devices' -SubSection

# Bluetooth
#---------------------------------------
# Disabled | NotConfigured
Set-BluetoothSetting -BluetoothGPO 'NotConfigured'

# Show notifications to connect using Swift Pair
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-BluetoothSetting -ShowQuickPairConnectionNotif 'Enabled' -ShowQuickPairConnectionNotifGPO 'NotConfigured'

# Download over metered connections (device software (drivers, info, and apps))
#---------------------------------------
# Disabled (default) | Enabled
Set-DevicesSetting -DownloadOverMeteredConnections 'Disabled'

# Use LE Audio when available
#---------------------------------------
# Disabled | Enabled (default)
Set-BluetoothSetting -LowEnergyAudio 'Enabled'

# Bluetooth devices discovery | deprecated
#---------------------------------------
# Default (default) | Advanced
Set-BluetoothSetting -DiscoveryMode 'Default'

#endregion devices


#==========================================================
#                   Printers & scanners
#==========================================================
#region printers & scanners

Write-Section -Name 'Printers & scanners' -SubSection

# Let Windows manage my default printer
#---------------------------------------
# Disabled | Enabled (default)
Set-DevicesSetting -DefaultPrinterSystemManaged 'Disabled'

# Download drivers and devices software over metered connections
#---------------------------------------
# See 'Windows Settings App > Bluetooth & devices > Devices > Download over metered connections'

#endregion printers & scanners


#==========================================================
#                      Mobile devices
#==========================================================
#region mobile devices

Write-Section -Name 'Mobile devices' -SubSection

# Allow this PC to access your mobile devices
#---------------------------------------
# Disabled (default) | Enabled
Set-MobileDevicesSetting -MobileDevices 'Disabled'

# Phone Link
#---------------------------------------
# State: Disabled (default) | Enabled
# GPO: Disabled | NotConfigured
Set-MobileDevicesSetting -PhoneLink 'Disabled' -PhoneLinkGPO 'NotConfigured'

# Show me suggestions for using my mobile device with Windows
#---------------------------------------
# Disabled | Enabled (default)
Set-MobileDevicesSetting -ShowUsageSuggestions 'Disabled'

#endregion mobile devices


#==========================================================
#                          Mouse
#==========================================================
#region mouse

Write-Section -Name 'Mouse' -SubSection

# Primary mouse button
#---------------------------------------
# Left (default) | Right
Set-MouseSetting -PrimaryButton 'Left'

# Mouse pointer speed
#---------------------------------------
# default: 10 (range 1-20)
Set-MouseSetting -PointerSpeed 10

# Enhance pointer precision
#---------------------------------------
# Disabled | Enabled (default)
Set-MouseSetting -EnhancedPointerPrecision 'Enabled'

#               Scrolling
#=======================================

# Roll the mouse wheel to scroll
# Lines to scroll at a time
#---------------------------------------
# MultipleLines (default) | OneScreen
# WheelScrollLinesToScroll: 3 (default) (range 1-100)
#Set-MouseSetting -WheelScroll 'OneScreen'
Set-MouseSetting -WheelScroll 'MultipleLines' -WheelScrollLinesToScroll 3

# Scroll inactive windows when hovering over them
#---------------------------------------
# Disabled | Enabled (default)
Set-MouseSetting -ScrollInactiveWindowsOnHover 'Enabled'

# Scrolling direction
#---------------------------------------
# DownMotionScrollsDown (default) | DownMotionScrollsUp
Set-MouseSetting -ScrollingDirection 'DownMotionScrollsDown'

#endregion mouse


#==========================================================
#                         Touchpad
#==========================================================
#region touchpad

Write-Section -Name 'Touchpad' -SubSection

# Touchpad
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -Touchpad 'Enabled'

# Leave touchpad on when a mouse is connected
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -LeaveOnWithMouse 'Enabled'

# Cursor speed
#---------------------------------------
# default: 5 (range 1-10)
Set-TouchpadSetting -CursorSpeed 5

#                 Taps
#=======================================

# Touchpad sensitivity
#---------------------------------------
# Max | High | Medium (default) | Low
Set-TouchpadSetting -Sensitivity 'Medium'

# Tap with a single finger to single-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TapToClick 'Enabled'

# Tap with two fingers to right-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TwoFingersTapToRightClick 'Enabled'

# Tap twice and drag to multi-select
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TapTwiceAndDragToMultiSelect 'Enabled'

# Press the lower right corner of the touchpad to right-click
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -RightClickButton 'Enabled'

#             Scroll & zoom
#=======================================

# Drag two fingers to scroll
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -TwoFingersToScroll 'Enabled'

# Scrolling direction
#---------------------------------------
# DownMotionScrollsDown | DownMotionScrollsUp (default)
Set-TouchpadSetting -ScrollingDirection 'DownMotionScrollsUp'

# Pinch to zoom
#---------------------------------------
# Disabled | Enabled (default)
Set-TouchpadSetting -PinchToZoom 'Enabled'

#         Three-finger gestures
#=======================================

# Taps
#---------------------------------------
# Nothing | OpenSearch (default) | NotificationCenter | PlayPause |
# MiddleMouseButton | MouseBackButton | MouseForwardButton
Set-TouchpadSetting -ThreeFingersTap 'OpenSearch'

# Swipes
#---------------------------------------
# Nothing | SwitchAppsAndShowDesktop (default) | SwitchDesktopsAndShowDesktop | ChangeAudioAndVolume | Custom
Set-TouchpadSetting -ThreeFingersSwipes 'SwitchAppsAndShowDesktop'

# Nothing | SwitchApps (left/right) | TaskView (up) | ShowDesktop (down) | SwitchDesktops | HideAllExceptAppInFocus |
# CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation | SnapWindowToLeft | SnapWindowToRight |
# MaximizeWindow | MinimizeWindow | NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute
$ThreeFingersSwipesCustom = @{
    ThreeFingersUp    = 'TaskView'
    ThreeFingersDown  = 'ShowDesktop'
    ThreeFingersLeft  = 'SwitchApps'
    ThreeFingersRight = 'SwitchApps'
}
#Set-TouchpadSetting -ThreeFingersSwipes 'Custom' @ThreeFingersSwipesCustom

#         Four-finger gestures
#=======================================

# Taps
#---------------------------------------
# Nothing | OpenSearch | NotificationCenter (default) | PlayPause |
# MiddleMouseButton | MouseBackButton | MouseForwardButton
Set-TouchpadSetting -FourFingersTap 'NotificationCenter'

# Swipes
#---------------------------------------
# Nothing | SwitchAppsAndShowDesktop | SwitchDesktopsAndShowDesktop (default) | ChangeAudioAndVolume | Custom
Set-TouchpadSetting -FourFingersSwipes 'SwitchDesktopsAndShowDesktop'

# Nothing | SwitchApps | TaskView (up) | ShowDesktop (down) | SwitchDesktops (left/right) | HideAllExceptAppInFocus |
# CreateDesktop | RemoveDesktop | ForwardNavigation | BackwardNavigation | SnapWindowToLeft | SnapWindowToRight |
# MaximizeWindow | MinimizeWindow | NextTrack | PreviousTrack | VolumeUp | VolumeDown | Mute
$FourFingersSwipesCustom = @{
    FourFingersUp    = 'TaskView'
    FourFingersDown  = 'ShowDesktop'
    FourFingersLeft  = 'SwitchDesktops'
    FourFingersRight = 'SwitchDesktops'
}
#Set-TouchpadSetting -FourFingersSwipes 'Custom' @FourFingersSwipesCustom

#endregion touchpad


#==========================================================
#                         AutoPlay
#==========================================================
#region autoplay

Write-Section -Name 'AutoPlay' -SubSection

# Use AutoPlay for all media and devices
#---------------------------------------
# State: Disabled | Enabled (default)
# GPO: Disabled | NotConfigured
Set-AutoPlaySetting -AutoPlay 'Enabled' -AutoPlayGPO 'NotConfigured'

#       Choose AutoPlay defaults
#=======================================

# Removable Drive
#---------------------------------------
# Default (default) | NoAction | OpenFolder | AskEveryTime
Set-AutoPlaySetting -RemovableDrive 'OpenFolder'

# Memory card
#---------------------------------------
# Default (default) | NoAction | OpenFolder | AskEveryTime
Set-AutoPlaySetting -MemoryCard 'OpenFolder'

#endregion autoplay


#==========================================================
#                           USB
#==========================================================
#region usb

Write-Section -Name 'USB' -SubSection

# Connection notifications (if issues with USB)
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -NotifOnErrors 'Enabled'

# USB battery saver
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -BatterySaver 'Enabled'

# Show a notification if this PC is charging slowly over USB
#---------------------------------------
# Disabled | Enabled (default)
Set-UsbSetting -NotifOnWeakCharger 'Enabled'

#endregion usb


Stop-Transcript
