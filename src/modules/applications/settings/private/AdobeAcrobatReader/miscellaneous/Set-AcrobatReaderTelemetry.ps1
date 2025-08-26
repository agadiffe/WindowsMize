#=================================================================================================================
#                                   Acrobat Reader - Miscellaneous > Telemetry
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTelemetry
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderTelemetry
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTelemetry -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ UsageMeasurement
        #   specifies whether to send usage measurement data back to Adobe and controls the welcome screen
        # not configured: delete (default) | off: 0
        $AcrobatReaderTelemetryGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bUsageMeasurement'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Telemetry (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderTelemetryGpo
    }
}
