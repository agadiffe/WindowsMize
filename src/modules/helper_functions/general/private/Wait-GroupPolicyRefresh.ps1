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
    .EXAMPLE
        PS> Wait-GroupPolicyRefresh

    .EXAMPLE
        PS> Wait-GroupPolicyRefresh -QueryStartTime (Get-Date).AddSeconds(-600) -TimeoutSeconds 12
    #>

    [CmdletBinding()]
    param
    (
        [datetime] $QueryStartTime = (Get-Date).AddSeconds(-20),

        [ValidateRange('NonNegative')]
        [double] $TimeoutSeconds = 3,

        [ValidateRange('NonNegative')]
        [double] $RetryIntervalSeconds = 0.1
    )

    process
    {
        $LogName = 'Microsoft-Windows-GroupPolicy/Operational'

        if (-not (Test-GPEventLogReady))
        {
            return
        }

        # wait for the manual GP Refresh start events initialized by LGPO /t
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        do {
            $EventFilter = @{
                LogName   = $LogName
                Id        = 4004, 4005
                StartTime = $QueryStartTime
            }
            $StartEvent = Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 2 -ErrorAction 'SilentlyContinue' -Verbose:$false

            if ($StartEvent -and $StartEvent.Id.Contains(4004) -and $StartEvent.Id.Contains(4005))
            {
                break
            }
            Start-Sleep -Seconds $RetryIntervalSeconds
        } while ($Stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds)

        $Stopwatch.Stop()

        if (-not $StartEvent -or -not ($StartEvent.Id.Contains(4004) -and $StartEvent.Id.Contains(4005)))
        {
            Write-Error -Message 'Timed out waiting for Group Policy start event 4004 & 4005.'
            return
        }

        $StartActivityId = $StartEvent.ActivityId.Guid

        # wait for the matching completion events
        $QueryStartTimeUtc = $QueryStartTime.ToUniversalTime().ToString('o')
        $EndEvent = @()
        foreach ($Id in $StartActivityId)
        {
            $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            do {
                $CompletionXPath = "
                    *[System[
                        (EventID=8004 or EventID=8005) and
                        TimeCreated[@SystemTime >= '$QueryStartTimeUtc'] and
                        Correlation[@ActivityID='$Id']
                    ]]"
                $CompletionEvent = Get-WinEvent -LogName $LogName -FilterXPath $CompletionXPath -MaxEvents 1 -ErrorAction 'SilentlyContinue'

                if ($CompletionEvent)
                {
                    break
                }
                Start-Sleep -Seconds $RetryIntervalSeconds
            } while ($Stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds)

            $Stopwatch.Stop()
            $EndEvent += $CompletionEvent
        }

        if ($EndEvent.Count -ne 2)
        {
            Write-Error -Message 'Timed out waiting for Group Policy completion events 8004 & 8005.'
            return
        }
    }
}
