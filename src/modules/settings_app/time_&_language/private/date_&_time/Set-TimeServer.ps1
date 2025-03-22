#=================================================================================================================
#                              Time & Language > Date & Time > Internet Time Server
#=================================================================================================================

# control panel (icons view) > date and time (timedate.cpl) > internet time

<#
.SYNTAX
    Set-TimeServer
        [-Server] {Windows | NistGov | PoolNtpOrg}
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
            'Windows'    { 'time.windows.com' }
            'NistGov'    { 'time.nist.gov' }
            'PoolNtpOrg' { '0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org' }
        }

        Write-Verbose -Message "Setting 'Internet Time Server' to '$TimeServer' ..."

        Start-Service -Name 'W32Time'
        Start-Sleep -Seconds 0.5
        w32tm.exe /config /syncfromflags:manual /manualpeerlist:"$TimeServer" /update | Out-Null
    }
}
