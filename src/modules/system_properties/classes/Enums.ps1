#==============================================================================
#                          System Properties - Enums
#==============================================================================

# remote assistance
enum RemoteAssistanceState
{
    Disabled
    FullControl
    ViewOnly
}

enum RemoteAssistanceGpoState
{
    Disabled
    FullControl
    ViewOnly
    NotConfigured
}

enum TimeUnitMHD
{
    Minutes = 0
    Hours   = 1
    Days    = 2
}

enum InvitationMethod
{
    SimpleMAPI = 0
    Mailto     = 1
}


# system failure
enum DebugInfoMethod
{
    None      = 0
    Complete  = 1
    Kernel    = 2
    Small     = 3
    Automatic = 7
    Active    = 1
}
