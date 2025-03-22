#==============================================================================
#       Settings App > Privacy & Security > Windows Security App - Enums
#==============================================================================

# virus & threat protection
enum CloudDelivereMode
{
    Disabled
    Basic
    Advanced
}

enum GpoCloudDelivereMode
{
    Disabled = 0
    Basic    = 1
    Advanced = 2
    NotConfigured
}

enum SampleSubmissionMode
{
    NeverSend
    AlwaysPrompt
    SendSafeSamples
    SendAllSamples
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
    Disabled
    Enabled
    AuditMode
}

enum GpoPUAProtectionMode
{
    Disabled  = 0
    Enabled   = 1
    AuditMode = 2
    NotConfigured
}
