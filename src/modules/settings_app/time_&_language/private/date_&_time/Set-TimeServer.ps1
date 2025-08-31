#=================================================================================================================
#                              Time & Language > Date & Time > Internet Time Server
#=================================================================================================================

# control panel (icons view) > date and time (timedate.cpl) > internet time

<#
.SYNTAX
    Set-TimeServer
        [-Server] {Cloudflare | Windows | NistGov | PoolNtpOrg}
        [<CommonParameters>]
#>

function Set-TimeServer
{
    <#
    .EXAMPLE
        PS> Set-TimeServer -Server 'Windows'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [InternetTimeServer] $Server
    )

    process
    {
        $TimeServer = switch ($Server)
        {
            'Cloudflare' { 'time.cloudflare.com' }
            'Windows'    { 'time.windows.com' }
            'NistGov'    { 'time.nist.gov' }
            'PoolNtpOrg' { '0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org' }
        }

        Write-Verbose -Message "Setting 'Internet Time Server' to '$TimeServer' ..."

        Start-Service -Name 'W32Time'
        Start-Sleep -Seconds 0.25

        $MaxRetries = 10
        $RetryCount = 0

        while ((Get-Service -Name 'W32Time').Status -ne 'Running' -and $RetryCount -lt $MaxRetries)
        {
            Start-Sleep -Seconds 0.25
            $RetryCount++
        }

        if ($RetryCount -eq $MaxRetries)
        {
            Write-Error -Message "    Cannot start W32Time service. Settings not applied."
            return
        }

        w32tm.exe /config /syncfromflags:manual /manualpeerlist:"$TimeServer" /update | Out-Null
    }
}
