#==============================================================================
#                                System - Enums
#==============================================================================

# clipboard
enum ClipboardSyncState
{
    Disabled
    AutoSync
    ManualSync
}


# display
enum BrightnessContentState
{
    Disabled    = 0
    Enabled     = 1
    BatteryOnly = 2
}


# for developers
enum SudoMode
{
    Disabled
    NewWindow
    InputDisabled
    Inline
}


# multitasking
enum AppsTabsOnSnapMode
{
    TwentyMostRecent = 0
    FiveMostRecent   = 1
    ThreeMostRecent  = 2
    Disabled         = 3
}

enum GpoAppsTabsOnSnapMode
{
    TwentyMostRecent = 1
    FiveMostRecent   = 2
    ThreeMostRecent  = 3
    Disabled         = 4
    NotConfigured
}

enum WindowVisibilty
{
    AllDesktops    = 0
    CurrentDesktop = 1
}


# nearby sharing
enum NearShareMode
{
    Disabled       = 0
    DevicesOnly    = 1
    EveryoneNearby = 2
}


# power and battery
enum PowerState
{
    Screen
    Sleep
    Hibernate
}

enum PowerMode
{
    BestPowerEfficiency
    Balanced
    BestPerformance
}

enum PowerSource
{
    PluggedIn
    OnBattery
}

enum ButtonControls
{
    PowerButton
    SleepButton
    LidClose
}

enum PowerAction
{
    DoNothing  = 0
    Sleep      = 1
    Hibernate  = 2
    ShutDown   = 3
    DisplayOff = 4
}


# sound
enum AdjustVolumeMode
{
    MuteOtherSounds              = 0
    ReduceOtherSoundsBy80Percent = 1
    ReduceOtherSoundsBy50Percent = 2
    DoNothing                    = 3
}


# notifications
enum NotifsAppsAndOtherSenders
{
    Apps
    Autoplay
    BatterySaver
    MicrosoftStore
    NotificationSuggestions
    PrintNotification
    Settings
    StartupAppNotification
    Suggested
    WindowsBackup
}

enum NotifsPositionIndex
{
    BottomCenter = 1
    TopLeft      = 2
    TopCenter    = 3
}
