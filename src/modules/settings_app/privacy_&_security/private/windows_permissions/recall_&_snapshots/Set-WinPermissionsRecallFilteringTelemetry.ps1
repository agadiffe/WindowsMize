#=================================================================================================================
#                Privacy & Security > Recall & Snapshots > Help Improve Recall Snapshots Filtering
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsRecallFilteringTelemetry
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsRecallFilteringTelemetry
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsRecallFilteringTelemetry -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $WinPermissionsRecallFilteringTelemetry = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\A9\SnapshotCapture'
            Entries = @(
                @{
                    Name  = 'IsFilteringTelemetryEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $RecallFilteringTelemetryMsg = 'Recall & Snapshots: Help Improve Recall Snapshots Filtering'

        Write-Verbose -Message "Setting 'Windows Permissions - $RecallFilteringTelemetryMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsRecallFilteringTelemetry
    }
}
