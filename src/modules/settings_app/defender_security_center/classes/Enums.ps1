#==============================================================================
#       Settings App > Privacy & Security > Windows Security App - Enums
#==============================================================================

# virus & threat protection
enum CloudDeliveredMode
{
    Disabled = 0
    Basic    = 1
    Advanced = 2
}

enum GpoCloudDeliveredMode
{
    Disabled = 0
    Basic    = 1
    Advanced = 2
    NotConfigured
}

enum SampleSubmissionMode
{
    NeverSend       = 2
    AlwaysPrompt    = 0
    SendSafeSamples = 1
    SendAllSamples  = 3
}

enum GpoSampleSubmissionMode
{
    NeverSend       = 2
    AlwaysPrompt    = 0
    SendSafeSamples = 1
    SendAllSamples  = 3
    NotConfigured
}


# app & browser control
enum GpoCheckAppsAndFilesMode
{
    Disabled = 0
    Warn     = 1
    Block    = 1
    NotConfigured
}

enum PUAProtectionMode
{
    Disabled  = 0
    Enabled   = 1
    AuditMode = 2
}

enum GpoPUAProtectionMode
{
    Disabled  = 0
    Enabled   = 1
    AuditMode = 2
    NotConfigured
}
