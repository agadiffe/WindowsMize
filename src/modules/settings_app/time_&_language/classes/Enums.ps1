#==============================================================================
#                           Time & Language - Enums
#==============================================================================

# date & time
enum InternetTimeServer
{
    Windows
    NistGov
    PoolNtpOrg
}


# language & region
enum DayOfWeek
{
    Monday    = 0
    Tuesday   = 1
    Wednesday = 2
    Thursday  = 3
    Friday    = 4
    Saturday  = 5
    Sunday    = 6
}

# typing
enum SwitchInputHotKeys
{
    NotAssigned  = 3
    CtrlShift    = 2
    LeftAltShift = 1
    GraveAccent  = 4
}

enum LanguageBarMode
{
    FloatingOnDesktop = 0
    DockedInTaskbar   = 4
    Hidden            = 3
}
