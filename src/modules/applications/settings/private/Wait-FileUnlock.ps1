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
    <#
    .EXAMPLE
        PS> try
            {
                Wait-FileUnlock -FilePath $FilePath -TimeoutSeconds 3
            }
            catch
            {
                Write-Error -Message "$($_.Exception.Message) Setting not applied."
                return
            }
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [ValidateRange('NonNegative')]
        [double] $TimeoutSeconds = 3,

        [ValidateRange('NonNegative')]
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
