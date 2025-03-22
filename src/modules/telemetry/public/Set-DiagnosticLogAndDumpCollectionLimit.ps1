#=================================================================================================================
#                              Telemetry - Limit Diagnostic Log and Dump Collection
#=================================================================================================================

# Data are not sent if 'send optional diagnostic data' is disabled.
# This setting prevent the creation of the log file.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-DiagnosticLogAndDumpCollectionLimit
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-DiagnosticLogAndDumpCollectionLimit
{
    <#
    .EXAMPLE
        PS> Set-DiagnosticLogAndDumpCollectionLimit -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
        #   limit diagnostic log collection
        #   limit dump collection
        # not configured: delete (default) | on: 1
        $DiagnosticLogAndDumpLimitGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'LimitDiagnosticLogCollection'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'LimitDumpCollection'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Limit Diagnostic Log and Dump Collection (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $DiagnosticLogAndDumpLimitGpo
    }
}
