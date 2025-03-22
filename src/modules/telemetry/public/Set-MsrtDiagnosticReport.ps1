#=================================================================================================================
#                      Telemetry - Microsoft Windows Malicious Software Removal Tool (MSRT)
#=================================================================================================================

<#
.SYNTAX
    Set-MsrtDiagnosticReport
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MsrtDiagnosticReport
{
    <#
    .EXAMPLE
        PS> Set-MsrtDiagnosticReport -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ Disable Malicious Software Reporting tool diagnostic data (heartbeat report)
        # not configured: delete (default) | on: 1
        $MsrtDiagnosticReportGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\MRT'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DontReportInfectionInformation'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Microsoft Windows MSRT Diagnostic Report (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MsrtDiagnosticReportGpo
    }
}
