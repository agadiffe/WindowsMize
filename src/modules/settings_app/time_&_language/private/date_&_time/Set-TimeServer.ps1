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
            'PoolNtpOrg' { '0.pool.ntp.org', '1.pool.ntp.org', '2.pool.ntp.org', '3.pool.ntp.org' }
        }
        $TimeServer = $TimeServer.ForEach{( "$_,0x9" )} -join ' '

        Write-Verbose -Message "Setting 'Internet Time Server' to '$TimeServer' ..."

        $TimeService = Start-Service -Name 'W32Time' -PassThru
        $TimeService.WaitForStatus('Running', [TimeSpan]::FromSeconds(5))
        if ($TimeService.Status -eq 'Running')
        {
            w32tm.exe /config /syncfromflags:manual /manualpeerlist:"$TimeServer" /update | Out-Null
        }
        else
        {
            Write-Error -Message "    Cannot start W32Time service. Setting not applied."
        }
    }
}
