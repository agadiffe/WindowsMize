#=================================================================================================================
#                                   System > Storage > Storage Sense - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseSetting
        [-TempFilesCleanup {Disabled | Enabled}]
        [-TempFilesCleanupGPO {Disabled | Enabled | NotConfigured}]
        [-StorageSense {Disabled | Enabled}]
        [-StorageSenseGPO {Disabled | Enabled | NotConfigured}]
        [-Schedule {OnLowFreeDiskSpace | Daily | Weekly | Monthly}]
        [-ScheduleGPO {OnLowFreeDiskSpace | Daily | Weekly | Monthly | NotConfigured}]
        [-RecycleBinRetentionDays {0 | 1 | 14 | 30 | 60}]
        [-RecycleBinRetentionDaysGPO <object>] # <int> (range 0-365) | NotConfigured
        [-DownloadsFolderRetentionDays {0 | 1 | 14 | 30 | 60}]
        [-DownloadsFolderRetentionDaysGPO <object>] # <int> (range 0-365) | NotConfigured
        [<CommonParameters>]
#>

function Set-StorageSenseSetting
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $TempFilesCleanup,

        [GpoState] $TempFilesCleanupGPO,

        [state] $StorageSense,

        [GpoState] $StorageSenseGPO,

        [StorageSenseSchedule] $Schedule,

        [GpoStorageSenseSchedule] $ScheduleGPO,

        [ValidateSet(0, 1, 14, 30, 60)]
        [int] $RecycleBinRetentionDays,

        [ValidateScript(
            { ($_ -is [int] -and $_ -ge 0 -and $_ -le 365) -or $_ -eq 'NotConfigured' },
            ErrorMessage = "Invalid value. Specify an integer between 0 and 365, or the string 'NotConfigured'.")]
        [object] $RecycleBinRetentionDaysGPO,

        [ValidateSet(0, 1, 14, 30, 60)]
        [int] $DownloadsFolderRetentionDays,

        [ValidateScript(
            { ($_ -is [int] -and $_ -ge 0 -and $_ -le 365) -or $_ -eq 'NotConfigured' },
            ErrorMessage = "Invalid value. Specify an integer between 0 and 365, or the string 'NotConfigured'.")]
        [object] $DownloadsFolderRetentionDaysGPO
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
            'TempFilesCleanup'                 { Set-StorageSenseTempFilesCleanup -State $TempFilesCleanup }
            'TempFilesCleanupGPO'              { Set-StorageSenseTempFilesCleanup -GPO $TempFilesCleanupGPO }

            'StorageSense'                     { Set-StorageSense -State $StorageSense }
            'StorageSenseGPO'                  { Set-StorageSense -GPO $StorageSenseGPO }
            'Schedule'                         { Set-StorageSenseSchedule -Schedule $Schedule }
            'ScheduleGPO'                      { Set-StorageSenseSchedule -GPO $ScheduleGPO }
            'RecycleBinRetentionDays'          { Set-StorageSenseRecycleBinRetention -Days $RecycleBinRetentionDays }
            'RecycleBinRetentionDaysGPO'       { Set-StorageSenseRecycleBinRetention -GPO $RecycleBinRetentionDaysGPO }
            'DownloadsFolderRetentionDays'     { Set-StorageSenseDownloadsFolderRetention -Days $DownloadsFolderRetentionDays }
            'DownloadsFolderRetentionDaysGPO'  { Set-StorageSenseDownloadsFolderRetention -GPO $DownloadsFolderRetentionDaysGPO }
        }
    }
}
