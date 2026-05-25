#=================================================================================================================
#                      System > Recovery > Point-In-Time Restore > Restore Point Disk Usage
#=================================================================================================================

# Maximum usage limit (in GB)

<#
.SYNTAX
    Set-PointInTimeRestoreMaxDiskUsage
        [-GB] <int>
        [<CommonParameters>]
#>

function Set-PointInTimeRestoreMaxDiskUsage
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestoreMaxDiskUsage -GB 4
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(2, 50)]
        [int] $GB
    )

    process
    {
        # default: 2% of disk (range: 2-50 GB) | Value is in MB
        $PointInTimeRestoreMaxDiskUsage = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\Recovery\PITR\Settings'
            Entries = @(
                @{
                    Name  = 'MaxTimespan_UX'
                    Value = $GB * 1024
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recovery - Point-In-Time Restore: Restore Point Disk Usage' to '$GB GB' ..."
        Set-RegistryEntry -InputObject $PointInTimeRestoreMaxDiskUsage
    }
}
