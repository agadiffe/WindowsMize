#=================================================================================================================
#                              System > Recovery > Point-In-Time Restore - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-PointInTimeRestoreSetting
        [-PointInTimeRestore {Disabled | Enabled}]
        [-FrequencyHours {4 | 6 | 12 | 16 | 24}]
        [-RetentionHours {4 | 6 | 12 | 16 | 24 | 72}]
        [-MaxDiskUsageGB <int>]
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreSetting
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreSetting -PointInTimeRestore 'Enabled' -FrequencyHours 24 -MaxDiskUsageGB 4
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $PointInTimeRestore,

        [ValidateSet(4, 6, 12, 16, 24)]
        [int] $FrequencyHours,

        [ValidateSet(4, 6, 12, 16, 24, 72)]
        [int] $RetentionHours,

        [ValidateRange(2, 50)]
        [int] $MaxDiskUsageGB
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
            'PointInTimeRestore' { Set-PointInTimeRestore -State $PointInTimeRestore }
            'FrequencyHours'     { Set-PointInTimeRestoreFrequency -Hours $FrequencyHours }
            'RetentionHours'     { Set-PointInTimeRestoreRetention -Hours $RetentionHours }
            'MaxDiskUsageGB'     { Set-PointInTimeRestoreMaxDiskUsage -GB $MaxDiskUsageGB }
        }
    }
}
