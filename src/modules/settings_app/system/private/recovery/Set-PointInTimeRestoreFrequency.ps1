#=================================================================================================================
#                       System > Recovery > Point-In-Time Restore > Restore Point Frequency
#=================================================================================================================

<#
.SYNTAX
    Set-PointInTimeRestoreFrequency
        [-Value] {4 | 6 | 12 | 16 | 24}
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreFrequency
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreFrequency -Value 24
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(4, 6, 12, 16, 24)]
        [int] $Value
    )

    process
    {
        # Every\ 4 hours: 240 | 6 hours: 360 | 12 hours: 720 | 16 hours: 960 | 24 hours: 1440 (default)
        $PointInTimeRestoreFrequency = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\Recovery\PITR\Settings'
            Entries = @(
                @{
                    Name  = 'SnapshotInterval_UX'
                    Value = $Value * 60
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recovery - Point-In-Time Restore: Restore Point Frequency' to '$Value hours' ..."
        Set-RegistryEntry -InputObject $PointInTimeRestoreFrequency
    }
}
