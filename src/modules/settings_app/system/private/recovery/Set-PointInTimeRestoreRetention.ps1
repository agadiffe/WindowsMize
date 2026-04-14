#=================================================================================================================
#                       System > Recovery > Point-In-Time Restore > Restore Point Retention
#=================================================================================================================

<#
.SYNTAX
    Set-PointInTimeRestoreRetention
        [-Value] {6 | 12 | 16 | 24 | 72}
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreRetention
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreRetention -Value 72
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(6, 12, 16, 24, 72)]
        [int] $Value
    )

    process
    {
        # 6 hours: 360 | 12 hours: 720 | 16 hours: 960 | 24 hours: 1440 | 72 hours: 4320 (default)
        $PointInTimeRestoreRetention = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\Recovery\PITR\Settings'
            Entries = @(
                @{
                    Name  = 'MaxTimespan_UX'
                    Value = $Value * 60
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recovery - Point-In-Time Restore: Restore Point Retention' to '$Value hours' ..."
        Set-RegistryEntry -InputObject $PointInTimeRestoreRetention
    }
}
