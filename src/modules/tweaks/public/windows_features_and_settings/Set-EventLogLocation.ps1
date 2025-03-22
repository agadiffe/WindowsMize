#=================================================================================================================
#                                             Move Event Log Location
#=================================================================================================================

# Somehow a test to see if it would help to reduce SSD write.
# I guess it can be used for other purpose than SSD longevity.

<#
.SYNTAX
    Set-EventLogLocation
        [-Path] <String>
        [<CommonParameters>]

    Set-EventLogLocation
        -Default
        [<CommonParameters>]
#>

function Set-EventLogLocation
{
    <#
    .EXAMPLE
        PS> Set-EventLogLocation -Path 'X:\MyEventLogs'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string] $Path,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [switch] $Default
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Default' -and -not $Default)
        {
            return
        }

        $EventLogPath = $Default ? "$env:SystemRoot\system32\winevt\Logs" : $Path

        Write-Verbose -Message "Setting 'Event Log Location' to '$EventLogPath' ..."

        if (-not (Test-Path -Path $EventLogPath))
        {
            try
            {
                New-Item -ItemType 'Directory' -Path $EventLogPath -Force -ErrorAction 'Stop' | Out-Null
            }
            catch
            {
                throw
            }
        }

        $EventLogs = wevtutil.exe enum-logs
        foreach ($Name in $EventLogs)
        {
            wevtutil.exe set-log "$Name" /logfilename:"$EventLogPath\$($Name.Replace('/', '%4')).evtx" 2>&1 | Out-Null
        }

        # Error message:
        # Failed to save configuration or activate log Microsoft-Windows-USBVideo/Analytic.
        # The requested operation cannot be performed over an enabled direct channel. The channel must first be disabled.
    }
}
