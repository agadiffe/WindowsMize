#=================================================================================================================
#       Defender > Settings > Notifications > Virus & Threat Protection > Recent Activity And Scan Results
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotifsRecentActivityAndScanResults
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderNotifsRecentActivityAndScanResults
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotifsRecentActivityAndScanResults -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $DefenderNotifsActivityAndScanResults = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection'
            Entries = @(
                @{
                    Name  = 'SummaryNotificationDisabled'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender Notifications - Recent Activity And Scan Results' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderNotifsActivityAndScanResults
    }
}
