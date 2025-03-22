#==============================================================================
#                           Personnalization - Enums
#==============================================================================

# background
enum WallpaperFitMode
{
    Fill    = 10
    Fit     = 6
    Stretch = 2
    Span    = 22
    Tile    = 0
    Center  = 0
}


# colors
enum ColorsTheme
{
    Dark  = 0
    Light = 1
}

enum AccentColorMode
{
    Manual    = 0
    Automatic = 1
}


# start
enum StartLayoutMode
{
    Default             = 0
    MorePins            = 1
    MoreRecommendations = 2
}


enum StartFoldersName
{
    Settings
    FileExplorer
    Network
    PersonalFolder
    Documents
    Downloads
    Music
    Pictures
    Videos
}


# taskbar
enum SearchBoxMode
{
    Hide         = 0
    IconOnly     = 1
    Box          = 2
    IconAndLabel = 3
}

enum GpoSearchBoxMode
{
    Hide         = 0
    IconOnly     = 1
    Box          = 2
    IconAndLabel = 3
    NotConfigured
}

enum TouchKeyboardMode
{
    Never          = 0
    Always         = 1
    WhenNoKeyboard = 2
}

enum TaskbarAlignment
{
    Left   = 0
    Center = 1
}

enum TaskbarAppsVisibility
{
    AllTaskbars                  = 0
    MainAndTaskbarWhereAppIsOpen = 1
    TaskbarWhereAppIsOpen        = 2
}

enum TaskbarGroupingMode
{
    Always            = 0
    WhenTaskbarIsFull = 1
    Never             = 2
}


# themes
enum DesktopIcons
{
    ThisPC
    UserFiles
    Network
    RecycleBin
    ControlPanel
}
