#=================================================================================================================
#                                                Wait File Unlock
#=================================================================================================================

<#
.SYNTAX
    Wait-FileUnlock
        [-FilePath] <string>
        [[-TimeoutSeconds] <double>]
        [[-RetryIntervalSeconds] <double>]
        [<CommonParameters>]
#>

function Wait-FileUnlock
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [double] $TimeoutSeconds = 3,

        [double] $RetryIntervalSeconds = 0.1
    )

    process
    {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        while (Test-FileLock -FilePath $FilePath)
        {
            if ($Stopwatch.Elapsed.TotalSeconds -ge $TimeoutSeconds)
            {
                throw "File '$FilePath' remained locked after waiting $TimeoutSeconds second(s)."
            }

            Start-Sleep -Seconds $RetryIntervalSeconds
        }
    }
}
