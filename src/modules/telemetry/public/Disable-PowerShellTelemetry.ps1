#=================================================================================================================
#                                             Telemetry - PowerShell
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Disable-PowerShellTelemetry [<CommonParameters>]
#>

function Disable-PowerShellTelemetry
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Disabling PowerShell Telemetry ...'
        [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', '1', 'Machine')
    }
}
