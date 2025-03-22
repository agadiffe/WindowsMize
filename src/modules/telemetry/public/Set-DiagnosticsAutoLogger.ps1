#=================================================================================================================
#                                       Telemetry - Diagnostics Auto-Logger
#=================================================================================================================

# all apps > windows tools > performance monitor > data collector sets > startup events trace sessions (perfmon.msc)

# Log files are stored in: $env:SystemRoot\System32\LogFiles\WMI\
# e.g. $env:SystemRoot\System32\LogFiles\WMI\Diagtrack-Listener.etl

# They will then be used by their associated services.
# e.g. "Connected User Experiences and Telemetry (DiagTrack)"

# These log files are utilized for diagnostic and telemetry purposes.

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
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet('DiagTrack-Listener')]
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
