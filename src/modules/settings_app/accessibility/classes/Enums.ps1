#==============================================================================
#                            Accessibility - Enums
#==============================================================================

# narrator
enum NarratorVerbosityLevel
{
    TextOnly           = 1
    SomeControlDetails = 2
    AllControlDetails  = 3
    SomeTextDetails    = 4
    AllTextDetails     = 5
}

enum NarratorCapitalizationReadingMode
{
    NoAnnounce    = 0
    IncreasePitch = 1
    SayCap        = 2
}

enum NarratorContextLevel
{
    NoContext                      = 1
    ImmediateContext               = 2
    ImmediateContextNameAndType    = 3
    FullContextOfNewControl        = 4
    FullContextOfOldAndNewControls = 5
}

enum NarratorContextDetailsOrder
{
    AfterControls  = 0
    BeforeControls = 1
}

enum NarratorKey
{
    CapsLock         = 1
    Insert           = 2
    CapsLockOrInsert = 3
}

enum NarratorKeyboardLayout
{
    Legacy   = 0
    Standard = 1
}

enum NarratorNavigationMode
{
    Normal   = 2
    Advanced = 1
}
