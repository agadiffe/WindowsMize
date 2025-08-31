#=================================================================================================================
#                                               Telemetry - DotNet
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Disable-DotNetTelemetry [<CommonParameters>]
#>

function Disable-DotNetTelemetry
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Disabling DotNet Telemetry ...'
        [Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', '1', 'Machine')
    }
}
