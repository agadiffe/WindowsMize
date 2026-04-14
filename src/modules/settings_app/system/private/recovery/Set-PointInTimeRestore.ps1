#=================================================================================================================
#                                    System > Recovery > Point-In-Time Restore
#=================================================================================================================

<#
.SYNTAX
    Set-PointInTimeRestore
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-PointInTimeRestore
{
    <#
    .EXAMPLE
        PS> Set-PointInTimeRestore -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $PointInTimeRestore = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\Recovery\PITR\Settings'
            Entries = @(
                @{
                    Name  = 'Active_UX'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recovery - Point-In-Time Restore' to '$State' ..."
        Set-RegistryEntry -InputObject $PointInTimeRestore
    }
}
