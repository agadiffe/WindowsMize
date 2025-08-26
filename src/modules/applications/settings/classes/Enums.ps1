#==============================================================================
#                            File Explorer - Enums
#==============================================================================

# adobe acrobat reader
enum AdobeProtectedViewMode
{
    Disabled             = 0
    UnsafeLocationsFiles = 1
    AllFiles             = 2
}

enum AdobeProtectedViewModeGpo
{
    Disabled             = 0
    UnsafeLocationsFiles = 1
    AllFiles             = 2
    NotConfigured
}

enum AdobeInternetAccessMode
{
    BlockAllWebSites = 1
    AllowAllWebSites = 2
    Custom           = 0
}

enum AdobeInternetAccessModeGpo
{
    BlockAllWebSites = 1
    AllowAllWebSites  = 2
    Custom            = 0
    NotConfigured
}

enum AdobeInternetAccessUnknownUrlMode
{
    Ask   = 1
    Allow = 2
    Block = 3
}

enum AdobeInternetAccessUnknownUrlModeGpo
{
    Ask   = 1
    Allow = 2
    Block = 3
    NotConfigured
}

enum AdobeCrashReportsMode
{
    Ask    = 0
    Always = 1
    Never  = 2
}

enum AdobePageUnits
{
    Points      = 0
    Inches      = 1
    Millimeters = 2
    Centimeters = 3
    Picas       = 4
}

enum AdobeHomeTopBannerMode
{
    Disabled
    Expanded  = 0
    Collapsed = 1
}
