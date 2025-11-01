#=================================================================================================================
#                                         MSOffice - Privacy > Telemetry
#=================================================================================================================

# If not configured, required and optional diagnostic data are sent to Microsoft.

<#
.SYNTAX
    Set-MSOfficeTelemetry
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeTelemetry
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeTelemetry -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   configure the level of client software diagnostic data sent by Office to Microsoft
        # not configured: delete (default) | on: Required (1), Optional (2), Neither (3)
        $MSOfficeTelemetryGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\Common\ClientTelemetry'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SendTelemetry'
                    Value = '3'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Telemetry (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeTelemetryGpo
    }
}
