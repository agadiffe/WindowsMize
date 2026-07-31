#=================================================================================================================
#                                   Helper Function - Wait Group Policy Refresh
#=================================================================================================================

<#
.SYNTAX
    Wait-GroupPolicyRefresh
        [[-QueryStartTime] <datetime>]
        [[-TimeoutSeconds] <double>]
        [[-RetryIntervalSeconds] <double>]
        [<CommonParameters>]
#>

function Wait-GroupPolicyRefresh
{
    <#
    .DESCRIPTION
        Wait for the Group Policy Refresh completion events.
        In WindowsMize, the process is initialized by LGPO /t.

    .EXAMPLE
        PS> Wait-GroupPolicyRefresh

    .EXAMPLE
        PS> Wait-GroupPolicyRefresh -QueryStartTime (Get-Date).AddSeconds(-30) -TimeoutSeconds 12
    #>

    [CmdletBinding()]
    param
    (
        [datetime] $QueryStartTime = (Get-Date),

        [ValidateRange('NonNegative')]
        [double] $TimeoutSeconds = 3,

        [ValidateRange('NonNegative')]
        [double] $RetryIntervalSeconds = 0.1
    )

    process
    {
        if (-not (Test-GPEventLogReady))
        {
            return
        }

        $LogName = 'Microsoft-Windows-GroupPolicy/Operational'

        $EventIds = 8004, 8005
        $CompletionEvent = @()

        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        do {
            $EventFilter = @{
                LogName   = $LogName
                Id        = $EventIds
                StartTime = $QueryStartTime
            }

            $CurrentEvent = Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 1 -ErrorAction 'SilentlyContinue' -Verbose:$false

            if ($CurrentEvent)
            {
                $CompletionEvent += $CurrentEvent
                $EventIds = $EventIds | Where-Object -FilterScript { $_ -ne $CurrentEvent.Id }
            }

            Start-Sleep -Seconds $RetryIntervalSeconds

        } while ($EventIds.Count -and $Stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds)

        if ($CompletionEvent.Count -ne 2)
        {
            Write-Verbose -Message 'Timed out waiting for Group Policy Refresh completion events 8004 & 8005.'
            return
        }
    }
}
