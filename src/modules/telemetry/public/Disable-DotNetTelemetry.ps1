#=================================================================================================================
#                                               Telemetry - DotNet
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

function Disable-DotNetTelemetry
{
    Write-Verbose -Message 'Disabling DotNet Telemetry ...'
    [Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', '1', 'Machine')
}
