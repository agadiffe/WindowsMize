#==============================================================================
#                         State and GPO State - Enums
#==============================================================================

enum State
{
    Disabled = 0
    Enabled  = 1
}

enum GpoState
{
    Disabled = 0
    Enabled  = 1
    NotConfigured
}

enum GpoStateWithoutEnabled
{
    Disabled
    NotConfigured
}

enum GpoStateWithoutDisabled
{
    Enabled
    NotConfigured
}
