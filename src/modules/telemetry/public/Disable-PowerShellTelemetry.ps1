#=================================================================================================================
#                                             Telemetry - PowerShell
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

function Disable-PowerShellTelemetry
{
    Write-Verbose -Message 'Disabling PowerShell Telemetry ...'
    [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'Machine')
}
