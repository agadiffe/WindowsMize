#=================================================================================================================
#                      Privacy & Security > Windows Security App > Notifications - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotificationsSetting
        [-VirusAndThreatAllNotifs {Disabled | Enabled}]
        [-AccountAllNotifs {Disabled | Enabled}]
        [<CommonParameters>]

    Set-DefenderNotificationsSetting
        [-RecentActivityAndScanResults {Disabled | Enabled}]
        [-ThreatsFoundNoActionNeeded {Disabled | Enabled}]
        [-FilesOrActivitiesBlocked {Disabled | Enabled}]
        [-WindowsHello {Disabled | Enabled}]
        [-DynamicLock {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DefenderNotificationsSetting
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotificationsSetting -CloudDeliveredProtection 'Disabled' -AutoSampleSubmission 'Disabled'
    #>

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [Parameter(ParameterSetName = 'All')]
        [state] $VirusAndThreatAllNotifs,

        [Parameter(ParameterSetName = 'All')]
        [state] $AccountAllNotifs,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $RecentActivityAndScanResults,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $ThreatsFoundNoActionNeeded,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $FilesOrActivitiesBlocked,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $WindowsHello,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $DynamicLock
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
            'VirusAndThreatAllNotifs'      { Set-DefenderVirusAndThreatNotifs -AllNotifs $VirusAndThreatAllNotifs }
            'AccountAllNotifs'             { Set-DefenderAccountNotifs -AllNotifs $AccountAllNotifs }

            'RecentActivityAndScanResults' { Set-DefenderVirusAndThreatNotifs -RecentActivityAndScanResults $RecentActivityAndScanResults }
            'ThreatsFoundNoActionNeeded'   { Set-DefenderVirusAndThreatNotifs -ThreatsFoundNoActionNeeded $ThreatsFoundNoActionNeeded }
            'FilesOrActivitiesBlocked'     { Set-DefenderVirusAndThreatNotifs -FilesOrActivitiesBlocked $FilesOrActivitiesBlocked }
            'WindowsHello'                 { Set-DefenderAccountNotifs -WindowsHello $WindowsHello }
            'DynamicLock'                  { Set-DefenderAccountNotifs -DynamicLock $DynamicLock }
        }
    }
}
