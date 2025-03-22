#==============================================================================
#                         Bluetooth & Devices - Enums
#==============================================================================

# bluetooth
enum BluetoothDiscoveryMode
{
    Default  = 0
    Advanced = 1
}


# mouse
enum MouseButtonMode
{
    Left  = 0
    Right = 1
}

enum WheelScrollMode
{
    MultipleLines
    OneScreen
}

enum ScrollingDirectionMode
{
    DownMotionScrollsDown
    DownMotionScrollsUp
}


# touchpad
enum TouchpadSensitivityMode
{
    Max    = 0
    High   = 1
    Medium = 2
    Low    = 3
}

enum TouchpadTapMode
{
    Nothing            = 0
    OpenSearch         = 1
    NotificationCenter = 2
    PlayPause          = 3
    MiddleMouseButton  = 4
    MouseBackButton    = 5
    MouseForwardButton = 6
}

enum TouchpadSwipesMode
{
    Nothing                      = 0
    SwitchAppsAndShowDesktop     = 1
    SwitchDesktopsAndShowDesktop = 2
    ChangeAudioAndVolume         = 3
    Custom                       = 65535
}

enum TouchpadSwipesCustomMode
{
    Nothing                 = 0
    SwitchApps              = 1
    TaskView                = 2
    ShowDesktop             = 3
    SwitchDesktops          = 4
    HideAllExceptAppInFocus = 5
    CreateDesktop           = 6
    RemoveDesktop           = 7
    ForwardNavigation       = 8
    BackwardNavigation      = 9
    SnapWindowToLeft        = 10
    SnapWindowToRight       = 12
    MaximizeWindow          = 11
    MinimizeWindow          = 13
    NextTrack               = 14
    PreviousTrack           = 15
    VolumeUp                = 16
    VolumeDown              = 17
    Mute                    = 18
}
