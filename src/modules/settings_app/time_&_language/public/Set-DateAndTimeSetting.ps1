#=================================================================================================================
#                                    Time & Language > Date & Time - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DateAndTimeSetting
        [-AutoTimeZone {Disabled | Enabled}]
        [-AutoTime {Disabled | Enabled}]
        [-ShowInSystemTray {Disabled | Enabled}]
        [-ShowAbbreviatedValue {Disabled | Enabled}]
        [-ShowSecondsInSystemClock {Disabled | Enabled}]
        [-ShowTimeInNotifCenter {Disabled | Enabled}]
        [-TimeServer {Cloudflare | Windows | NistGov | PoolNtpOrg}]
        [<CommonParameters>]
#>

function Set-DateAndTimeSetting
{
    <#
    .EXAMPLE
        PS> Set-DateAndTimeSetting -AutoTime 'Enabled' -ShowInSystemTray 'Enabled' -ShowSecondsInSystemClock 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AutoTimeZone,

        [state] $AutoTime,

        [state] $ShowInSystemTray,

        [state] $ShowAbbreviatedValue,

        [state] $ShowSecondsInSystemClock,

        [state] $ShowTimeInNotifCenter,

        [InternetTimeServer] $TimeServer
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'AutoTimeZone'             { Set-TimeZoneAutomatically -State $AutoTimeZone }
            'AutoTime'                 { Set-TimeAutomatically -State $AutoTime }
            'ShowInSystemTray'         { Set-DateAndTimeShowInSystemTray -State $ShowInSystemTray }
            'ShowAbbreviatedValue'     { Set-DateAndTimeShowAbbreviatedValue -State $ShowAbbreviatedValue }
            'ShowSecondsInSystemClock' { Set-DateAndTimeShowSecondsInSystemClock -State $ShowSecondsInSystemClock }
            'ShowTimeInNotifCenter'    { Set-DateAndTimeShowTimeInNotifCenter -State $ShowTimeInNotifCenter }
            'TimeServer'               { Set-TimeServer -Server $TimeServer }
        }
    }
}
