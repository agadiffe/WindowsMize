#==============================================================================
#                          Privacy & Security - Enums
#==============================================================================

# diagnostics & feedback
enum DiagnosticDataMode
{
    Disabled            = 0
    OnlyRequired        = 1
    OptionalAndRequired = 3
}

enum GpoDiagnosticDataMode
{
    Disabled            = 0
    OnlyRequired        = 1
    OptionalAndRequired = 3
    NotConfigured
}

enum FeedbackFrequencyMode
{
    Never
    Automatically
    Always
    Daily
    Weekly
}


# search
enum SafeSearchMode
{
    Disabled = 0
    Moderate = 1
    Strict   = 2
}

enum FindMyFilesMode
{
    Classic
    Enhanced
}


# app permissions
enum BackgroundAppMode
{
    Always
    Optimized
    Never
}
