#==============================================================================
#                            File Explorer - Enums
#==============================================================================

enum LaunchTo
{
    ThisPC    = 1
    Home      = 2
    Downloads = 3
    OneDrive  = 4
}

enum OpenFolderMode
{
    SameWindow
    NewWindow
}

enum OpenItemMode
{
    SingleClick
    DoubleClick
}

enum TypingIntoListViewMode
{
    SelectItemInView    = 0
    AutoTypeInSearchBox = 1
}

enum DriveLettersMode
{
    Disabled        = 2
    AfterDriveName  = 0
    BeforeDriveName = 4
}
