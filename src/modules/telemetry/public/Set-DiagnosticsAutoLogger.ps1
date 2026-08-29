#=================================================================================================================
#                                       Telemetry - Diagnostics Auto-Logger
#=================================================================================================================

# all apps > windows tools > performance monitor > data collector sets > startup events trace sessions (perfmon.msc)

# Log files are stored in: $env:SystemRoot\System32\LogFiles\WMI\
# e.g. $env:SystemRoot\System32\LogFiles\WMI\Diagtrack-Listener.etl

# They will then be used by their associated services.
# e.g. "Connected User Experiences and Telemetry (DiagTrack)"

# Disable these optional Windows ETW AutoLogger sessions to reduce diagnostic/telemetry tracing.
# This may reduce information available for Windows troubleshooting and diagnostics.

# Performance impact: very small / workload-dependent.

# AutoLogger                Specifically tied to user telemetry?    Classification
# -----------------------------------------------------------------------------------------
# Diagtrack-Listener        Yes                                     Telemetry
# SQMLogger                 Very likely                             Telemetry
# DiagLog                   Telemetry/diagnostic data (DPS)         Telemetry/Diagnostic
# CloudExperienceHostOobe   Likely diagnostic/usage telemetry       Telemetry/Diagnostic
# Cellcore                  Cellular diagnostics                    Diagnostic
# LwtNetLog                 Network diagnostics                     Diagnostic
# WdiContextLog             Network-driver diagnostics              Diagnostic
# WiFiSession               WLAN diagnostics                        Diagnostic

<#
.SYNTAX
    Set-DiagnosticsAutoLogger
        [-Name] {DiagTrack-Listener}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DiagnosticsAutoLogger
{
    <#
    .EXAMPLE
        PS> Set-DiagnosticsAutoLogger -Name 'DiagTrack-Listener' -State 'Disabled'

    .EXAMPLE
        PS> $DiagnosticsAutoLogger = @(
                'Diagtrack-Listener'
                'SQMLogger'
                'DiagLog'
                'CloudExperienceHostOobe'
                'Cellcore'
                'LwtNetLog'
                'WdiContextLog'
                'WiFiSession'
            )
        PS> $DiagnosticsAutoLogger | Set-DiagnosticsAutoLogger -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet(
            'Diagtrack-Listener',
            'SQMLogger',
            'DiagLog',
            'CloudExperienceHostOobe',
            'Cellcore',
            'LwtNetLog',
            'WdiContextLog',
            'WiFiSession')]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0
        $DiagnosticsAutoLogger = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = "SYSTEM\CurrentControlSet\Control\WMI\Autologger\$Name"
            Entries = @(
                @{
                    Name  = 'Start'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Diagnostics AutoLogger ($Name)' to '$State' ..."
        Set-RegistryEntry -InputObject $DiagnosticsAutoLogger
    }
}
