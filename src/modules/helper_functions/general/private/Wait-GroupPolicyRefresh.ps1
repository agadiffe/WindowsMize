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
        [datetime] $QueryStartTime = (Get-Date).AddSeconds(-1),

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
        $EventIds = 4004, 4005
        $StartEvent = @()

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
                $StartEvent += $CurrentEvent
                $EventIds = $EventIds | Where-Object -FilterScript { $_ -ne $CurrentEvent.Id }
            }

            Start-Sleep -Seconds $RetryIntervalSeconds

        } while ($EventIds.Count -ne 0 -and $Stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds)

        if ($StartEvent.Count -ne 2)
        {
            Write-Verbose -Message 'Timed out waiting for Group Policy start event 4004 & 4005.'
            return
        }

        $StartActivityId = $StartEvent.ActivityId.Guid

        # wait for the matching completion events
        $QueryStartTimeUtc = $QueryStartTime.ToUniversalTime().ToString('o')
        $EndEvent = @()

        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        foreach ($Id in $StartActivityId)
        {
            do {
                $CompletionXPath = "
                    *[System[
                        (EventID=8004 or EventID=8005) and
                        TimeCreated[@SystemTime >= '$QueryStartTimeUtc'] and
                        Correlation[@ActivityID='$Id']
                    ]]"
                $CompletionEvent = Get-WinEvent -LogName $LogName -FilterXPath $CompletionXPath -MaxEvents 1 -ErrorAction 'SilentlyContinue'

                Start-Sleep -Seconds $RetryIntervalSeconds

            } while (-not $CompletionEvent -and $Stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds)

            $EndEvent += $CompletionEvent
        }

        if ($EndEvent.Count -ne 2)
        {
            Write-Verbose -Message 'Timed out waiting for Group Policy completion events 8004 & 8005.'
            return
        }
    }
}
