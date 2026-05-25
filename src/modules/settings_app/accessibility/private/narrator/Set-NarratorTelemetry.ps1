#=================================================================================================================
#                  Accessibility > Narrator > Automatically Send Diagnostic And Performance Data
#=================================================================================================================

# Disabled by default. Enforce it.

<#
.SYNTAX
    Set-NarratorTelemetry
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorTelemetry
{
    <#
    .EXAMPLE
        PS> Set-NarratorTelemetry -State 'Disabled'
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
        $NarratorTelemetry = @{
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
        Set-RegistryEntry -InputObject $NarratorTelemetry
    }
}
