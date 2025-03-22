#=================================================================================================================
#                  Accessibility > Narrator > Automatically Send Diagnostic And Performance Data
#=================================================================================================================

# Disabled by default. Enforce it.

<#
.SYNTAX
    Set-NarratorAutoSendTelemetry
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAutoSendTelemetry
{
    <#
    .EXAMPLE
        PS> Set-NarratorAutoSendTelemetry -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $NarratorSendDiagnosticAndPerformanceData = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'DetailedFeedback'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Automatically Send Diagnostic And Performance Data' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorSendDiagnosticAndPerformanceData
    }
}
