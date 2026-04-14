#=================================================================================================================
#                      System > Recovery > Point-In-Time Restore > Restore Point Disk Usage
#=================================================================================================================

# Maximum usage limit (in GB)

<#
.SYNTAX
    Set-PointInTimeRestoreMaxDiskUsage
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreMaxDiskUsage
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreMaxDiskUsage -Value 4
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(2, 50)]
        [int] $Value
    )

    process
    {
        # default: 2% of disk (range 2-50 GB) | Value is in MB
        $PointInTimeRestoreMaxDiskUsage = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\Recovery\PITR\Settings'
            Entries = @(
                @{
                    Name  = 'MaxTimespan_UX'
                    Value = $Value * 1024
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recovery - Point-In-Time Restore: Restore Point Disk Usage' to '$Value GB' ..."
        Set-RegistryEntry -InputObject $PointInTimeRestoreMaxDiskUsage
    }
}
