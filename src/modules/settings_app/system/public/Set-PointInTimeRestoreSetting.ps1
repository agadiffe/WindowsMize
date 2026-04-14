#=================================================================================================================
#                                    System > Recovery > Point-In-Time Restore
#=================================================================================================================

<#
.SYNTAX
    Set-PointInTimeRestoreSetting
        [-State {Disabled | Enabled}]
        [-Frequency {4 | 6 | 12 | 16 | 24}]
        [-Retention {6 | 12 | 16 | 24 | 72}]
        [-MaxDiskUsage <int>]
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreSetting
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreSetting -State 'Enabled' -Frequency 24 -MaxDiskUsage 4
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [ValidateSet(4, 6, 12, 16, 24)]
        [int] $Frequency,

        [ValidateSet(6, 12, 16, 24, 72)]
        [int] $Retention,

        [ValidateRange(2, 50)]
        [int] $MaxDiskUsage
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
            'State'        { Set-PointInTimeRestore -State $State }
            'Frequency'    { Set-PointInTimeRestoreFrequency -Value $Frequency }
            'Retention'    { Set-PointInTimeRestoreRetention -Value $Retention }
            'MaxDiskUsage' { Set-PointInTimeRestoreMaxDiskUsage -Value $MaxDiskUsage }
        }
    }
}
