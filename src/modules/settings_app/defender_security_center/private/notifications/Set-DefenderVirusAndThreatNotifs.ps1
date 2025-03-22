#=================================================================================================================
#        Defender > Settings > Notifications > Virus & Threat Protection > Get Informational Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderVirusAndThreatNotifs
        [-AllNotifs] {Disabled | Enabled}
        [<CommonParameters>]

    Set-DefenderVirusAndThreatNotifs
        [-RecentActivityAndScanResults {Disabled | Enabled}]
        [-ThreatsFoundNoActionNeeded {Disabled | Enabled}]
        [-FilesOrActivitiesBlocked {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DefenderVirusAndThreatNotifs
{
    <#
    .EXAMPLE
        PS> Set-DefenderVirusAndThreatNotifs -AllNotifs 'Disabled'
    #>

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'All')]
        [state] $AllNotifs,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $RecentActivityAndScanResults,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $ThreatsFoundNoActionNeeded,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $FilesOrActivitiesBlocked
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'All')
        {
            $PSBoundParameters.RecentActivityAndScanResults = $AllNotifs
            $PSBoundParameters.ThreatsFoundNoActionNeeded = $AllNotifs
            $PSBoundParameters.FilesOrActivitiesBlocked = $AllNotifs
        }

        switch ($PSBoundParameters.Keys)
        {
            'RecentActivityAndScanResults' { Set-DefenderNotifsRecentActivityAndScanResults -State $PSBoundParameters.RecentActivityAndScanResults }
            'ThreatsFoundNoActionNeeded'   { Set-DefenderNotifsThreatsFoundNoActionNeeded -State $PSBoundParameters.ThreatsFoundNoActionNeeded }
            'FilesOrActivitiesBlocked'     { Set-DefenderNotifsFilesOrActivitiesBlocked -State $PSBoundParameters.FilesOrActivitiesBlocked }
        }

        # on: 0 (default) | off: 1
        $DefenderVirusAndThreatNotifs = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Defender Security Center\Notifications'
            Entries = @(
                @{
                    Name  = 'DisableEnhancedNotifications'
                    Value = (Test-DefenderNotifsEnabled -Name 'VirusAndThreat') ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }
        Set-RegistryEntry -InputObject $DefenderVirusAndThreatNotifs
    }
}
