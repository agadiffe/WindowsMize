#=================================================================================================================
#        Defender > Settings > Notifications > Virus & Threat Protection > Files Or Activities Are Blocked
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotifsFilesOrActivitiesBlocked
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderNotifsFilesOrActivitiesBlocked
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotifsFilesOrActivitiesBlocked -State 'Disabled'
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
        $DefenderNotifsFilesOrActivitiesBlocked = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection'
            Entries = @(
                @{
                    Name  = 'FilesBlockedNotificationDisabled'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender Notifications - Files Or Activities Are Blocked' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderNotifsFilesOrActivitiesBlocked
    }
}
